library(igraph)
library(statnet)
library(ergm)
library(intergraph)
library(jsonlite) #Needed to convert original JSON files

############################################################
#               JSON conversion 
############################################################

#Load data from JSON
starwarsjson <- fromJSON(txt  = "starwarsfull.json")

#Separate nodes and edges
e <- starwarsjson$links
n <- starwarsjson$nodes

#Change source and target from index to names
for (i in 1:length(n$name)) {
  t <- which(e$target == i-1)
  s <- which(e$source == i-1)
  e$target[t] <- n$name[i]
  e$source[s] <- n$name[i]
}

#Write to csv
write.csv(n, row.names = FALSE, file="starwarsNodes.csv")
write.csv(e, row.names = FALSE, file="starwarsEdges.csv")

############################################################
#       End of JSON conversion 
############################################################

#Read in the data
nodes <- read.csv("starwarsNodes.csv")
edges <- read.csv("starwarsEdges.csv")

#create an igraph object
swGraph <- graph_from_data_frame(d=edges, vertices=nodes, directed=FALSE)

#Generate a summary of the igraph object
summary(swGraph)

#Plot the network

#Set the vertex atributes
V(swGraph)$label = V(swGraph)$shortname
V(swGraph)$label.cex = .7

goodguys <- c('jedi','alliance', 'resistance', 'republic', 'naboo')
badguys <- c('trade federaton', 'empire', 'sith', 'first order', 
             'separatist')
V(swGraph)$color <- ifelse(V(swGraph)$affiliation %in% goodguys, "green",
                                ifelse(V(swGraph)$affiliation %in% badguys, "red",
                                       "lightblue"))

par(mar=c(1,1,1,1))

#set random seed to get consistent results
set.seed(500)
plot(swGraph, rescale = TRUE, ylim=c(-1,1.5),xlim=c(-1,1.5), asp = 0, 
     vertex.size=5, layout=layout_with_fr, label='shortername',
     main="Star Wars Network")
legend("topleft", c("Good Guys","Bad Guys", "Neither"), pch=21,
       col="#777777", pt.bg=c("green","red","lightblue"), pt.cex=1.5, cex=.8)

legend("bottomright", c("Friend","Foe", "Neutral"), 
       col=c("green","red","grey"), lty=1, cex=.8)

#Generate Five-Number Summary
V(swGraph)
edge_density(swGraph, loops = FALSE)
count_components(swGraph)
diameter(swGraph)
transitivity(swGraph)

#Centrality
dc <- igraph::degree(swGraph,v=V(swGraph)) #Degree Centrality
dc[dc >= 30] 

cc <- igraph::closeness(swGraph, vids = V(swGraph)) #Closeness Centrality
cc[cc >= .0045]

bc <- igraph::betweenness(swGraph, v=V(swGraph)) #Betweenness Centrality
bc[bc >= 500]

V(swGraph)$name[articulation.points(swGraph)] #Find the cutpoints

#Community Detection

#Check the modularity of affiliation and species to 
#compare community detection algorithms with
grp_nmbr <- as.numeric(factor(V(swGraph)$affiliation))
spc_nmbr <- as.numeric(factor(V(swGraph)$species))
df <- data.frame("Method"=c("Affiliation","Species"), 
                 "Number of Groups"=c(length(unique(V(swGraph)$affiliation)),
                                      length(unique(V(swGraph)$species))),
                 "Modularity"=c(modularity(swGraph,grp_nmbr),
                                modularity(swGraph,spc_nmbr)), 
                 stringsAsFactors = FALSE)

#Find the number of groups and modularity of different
#clustering algorithms
cw <- cluster_walktrap(swGraph)
df <- rbind(df, list("Walktrap", 
               length(unique(membership(cw))), modularity(cw)))

ceb <- cluster_edge_betweenness(swGraph)
df <- rbind(df, list("Edge Betweenness", 
               length(unique(membership(ceb))), modularity(ceb)))

cle <- cluster_leading_eigen(swGraph)
df <- rbind(df, list("Leading Eigenvector", 
               length(unique(membership(cle))), modularity(cle)))

cfg <- cluster_fast_greedy(swGraph)
df <- rbind(df, list("Fast Greedy", 
               length(unique(membership(cfg))), modularity(cfg)))

cl <- cluster_louvain(swGraph)
df <- rbind(df, list("Louvain", 
               length(unique(membership(cl))), modularity(cl)))

clp <- cluster_label_prop(swGraph)
df <- rbind(df, list("Label Propagation", 
               length(unique(membership(clp))), modularity(clp)))

cim <- cluster_infomap(swGraph)
df <- rbind(df, list("Infomap", 
               length(unique(membership(cim))), modularity(cim)))

csg <- cluster_spinglass(swGraph)
df <- rbind(df, list("Springlass", 
               length(unique(membership(csg))), modularity(csg)))

df

#Display best four graphs
par(mar=c(1,1,1,1))
plot(cle, swGraph, vertex.label=V(swGraph)$affiliation, 
     main = "Leading Eigenvector")
plot(cfg, swGraph, vertex.label=V(swGraph)$affiliation, 
     main = "Fast Greedy")
plot(cl, swGraph, vertex.label=V(swGraph)$affiliation, 
     main = "Louvain")
plot(csg, swGraph, vertex.label=V(swGraph)$affiliation, 
     main = "Springlass")

#Examine the FastGreedy method
table(cfg$membership, V(swGraph)[cfg$names]$affiliation)

#See the FastGreedy plot with character names
plot(cfg, swGraph, vertex.label=V(swGraph)$shortname, 
     vertex.size = 7, main = "Fast Greedy")


#Modeling

#Create a NULL model
sw <- asNetwork(swGraph)
swNull <- ergm(sw~edges,control = control.ergm(40))
summary(swNull)
plogis(coef(swNull)) #Check density of the Null model

#Add affiliation to the model
swAf <- ergm(sw~edges +
                     nodefactor('affiliation'),control = control.ergm(40))
summary(swAf)

#Create a model with Node Attributes species and affiliation
swSpAf <- ergm(sw~edges +
                nodefactor('affiliation') +
                nodefactor('species'),control = control.ergm(40))
summary(swSpAf)

#Add the episodes to the model
swAfSpEp <- ergm(sw~edges +
                         nodefactor('affiliation') +
                         nodecov('ep1') +
                         nodecov('ep2') +
                         nodecov('ep3') +
                         nodecov('ep4') +
                         nodecov('ep5') +
                         nodecov('ep6') +
                         nodecov('ep7') 
                 ,control = control.ergm(40))
summary(swAfSpEp)

#Keep the best episodes, 1,3,6, and 7
swAfSpEpBest <- ergm(sw~edges +
                         nodefactor('affiliation') +
                         nodecov('ep1') +
                         nodecov('ep3') +
                         nodecov('ep6') +
                         nodecov('ep7') 
                 ,control = control.ergm(40))
summary(swAfSpEpBest)

#Check the mixinf of affiliation and species
mixingmatrix(sw, 'affiliation')
mixingmatrix(sw, 'species')

#affiliation looked better, so add the dyadic predictor
swDp <- ergm(sw~edges +
                     nodefactor('affiliation') +
                     nodecov('ep1') +
                     nodecov('ep3') +
                     nodecov('ep6') +
                     nodecov('ep7') +
                     nodematch('affiliation'),control = control.ergm(40))
summary(swDp)

#Dyad dependency
#gwdegree
swDegree <- ergm(sw~edges +
                     nodefactor('affiliation') +
                     nodematch('affiliation') +
                     nodecov('ep1') +
                     nodecov('ep3') +
                     nodecov('ep6') +
                     nodecov('ep7') +
                     gwdegree(0.7,fixed=TRUE),control = control.ergm(40))
summary(swDegree)

#gwESP
swESP <- ergm(sw~edges +
                         nodefactor('affiliation') +
                         nodematch('affiliation') +
                         nodecov('ep1') +
                         nodecov('ep3') +
                         nodecov('ep6') +
                         nodecov('ep7') +
                         gwesp(0.7,fixed=TRUE),control = control.ergm(40))
summary(swESP)

#swdsp
swDSP <- ergm(sw~edges +
                         nodefactor('affiliation') +
                         nodematch('affiliation') +
                         nodecov('ep1') +
                         nodecov('ep3') +
                         nodecov('ep6') +
                         nodecov('ep7') +
                         gwdsp(0.7,fixed=TRUE),control = control.ergm(40))
summary(swDSP)



#swDp gave the best results
#Check the model fit for this model

#Check the model fit of swDP
swDp.fit <- gof(swDp, GOF = ~distance + espartners +
                        degree + triadcensus)

swDp.fit

#Run a simulation based on model
sim <- simulate(swDp,nsim=1,seed=123)
simI <- asIgraph(sim)

#Display the network and simulation
op <- par(mfrow=c(1,2),mar=c(0,0,2,0))
plot(swGraph, rescale = TRUE, ylim=c(-1,1.3),xlim=c(-1,1.2), asp = 0, 
     vertex.size=5, layout=layout_with_fr,
     main="Observed Network")
plot(sim, 
     main="Simulated Network")
par(op)


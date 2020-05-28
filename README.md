# Star Wars: A Look At The Relationships Between Characters

## Executive Summary

This study looks at the Star Wars Universe that George Lucas created, particularly the relationships between the characters in the first seven movies. Since the story arc centers around Anakin and Luke Skywalker, it seems plausible that they would be the central characters. The other objective is to create a model that approximates the relationship network.

The dataset was originally published by Evalina Gabasov and can be found at https://zenodo.org/record/1411479#.XtAd7TpKjIU. The JSON file contained nodes representing the characters and edges representing converstions between two characters in the same scene. 

Centrality of the characters was analyzed by looking at degree centrality, closeness centrality, and betweeness centrality. After analyzing the 112-character network, Obi-Wan Kenobi and C-3PO were the most central characters.

The model was built using affiliation, and whether the character appeared in Episodes 1, 3, 6, or 7 as factors. Affiliation was also used as a dyadic predictor. The final model did show some similarities to the observed model, but it did not capture the clustering that was observed.

## Introduction

George Lucas created a vast universe in his epic saga Star Wars. To date, there have been ten motion pictures made that are broken up into three trilogies with two stand alone movies. The final installment of the third trilogy comes out later this year.

His tale is that of the triumph of good over evil. His characters are diverse, with humans, aliens, and droids all interacting with each other. We will be looking at the first seven films, which comprise the Prequel Trilogy (Episodes 1, 2, and 3), the Original Trilogy (Episodes 4, 5, and 6), as well as the first installment of the Final Trilogy (Episode 7). 

 This study will look at what accounts for the most interactions. One of the obvious possibilities is what movie the character appears in. Each trilogy is separated by many years, so many of the characters do not span trilogies. Therefore, the episode that they appear in should help determine their connections.
 
The other two factors that we will look at are affiliation and species. A character’s affiliation is the group that they belong in, such as the Galactic Empire or the Rebel Alliance. Characters in the same group would be expected to form ties with each other. Species is also a characteristic that could cause ties, as creatures of the same species would interact with each other. 

Before we look at the clustering, we will look at the central figures. The obvious candidates are Luke Skywalker or Anakin Skywalker, as they are main characters in the first two trilogies. Centrality analysis should reveal who really is the main character(s). 

## Dataset

The dataset is based off one of Evelina Gabasova’s Star Wars social networks (Gabasova, 2016). Gabosova collected the interactions between characters in seven of the Star Wars movies (McCallum, Star Wars: The Phantom Menace, 1999) (McCallum, Star Wars: Attack of the Clones, 2002) (McCallum, Star Wars: Revenge of the Sith, 2005) (Kurtz, Star Wars: A New Hope, 1977) (Kutz, Star Wars: The Empire Strikes Back, 1980) (McCallum, Star Wars: Return of the Jedi, 1983) (Abrams, 2015).

The nodes represent characters in the movie. The links between the characters appear when they both speak in the same scene. Thus, a link was created between C-3PO and R2-D2 when C-3PO exclaimed, “Did you hear that?” in the opening scene of Star Wars: A New Hope.
The dataset was stored in a JSON file. The file was loaded and parsed, then saved as two csv files, one for the nodes and one for the edges. Once that was done, the csv files were modified to add attributes. 

The original file contained three node attributes: name (the name of the character), value (number of scenes the character appeared in), and colour (used by Gabosova for her visualizations). The following attributes were added: affiliation (group that the character belongs to), shortname (shorter version of character’s name), species (character’s species), and ep1, ep2, ep3, ep4, ep5, ep6, ep7 (true if character appeared in that episode, false if not).   

The original edge file contained one node attribute: value (the number of scenes together). Another attribute was added: color. This attribute corresponds to how the characters are related. Green signifies that they are allies, red signifies that they are enemies, and gray signifies that they are neither.

The attributes were added thanks to information from the Star Wars Databank (Star Wars, n.d.) and Wookipedia (Wookipedia, n.d.). 
The dataset is stored in two comma-delimited files, starwarsNodes.csv and starwarsEdges.csv. They were combined in an igraph object in order to analyze the network. 

## Network Summary
### Network Statistics

A summary of the network gives us:

    IGRAPH df36ae3 UN-- 112 452 -- 
    + attr: name (v/c), value (v/n), colour (v/c), affiliation (v/c), species
    | (v/c), ep1 (v/l), ep2 (v/l), ep3 (v/l), ep4 (v/l), ep5 (v/l), ep6
    | (v/l), ep7 (v/l), shortname (v/c), value (e/n), color (e/c)

There are 112 characters with 452 links between them. There are thirteen vertex attributes and two edge attributes

### Five-Number Summary

The following is the Five-Number Summary suggested in A User’s Buide to Network Analysis in R (Luke, 2015).

    Size: 112 nodes and 452 edges
    Density: 7.3%
    Components: 1
    Diameter: 6
    Transitivity: 0.36

This network is large enough to find some interesting details, but not so large as to be cumbersome for this academic endeavor. It is a sparse network, with just 7.3% of possible links actualized. There is only one component, which means that there is a path from each node to any other node in the network. In fact, every node is within six nodes of each other. The transitivity number indicates that the network is moderately clustered.

## Centrality Analysis

There are several measures of centralization. Degree centralization focuses on the number of connections that a node has. Closeness centrality is the proximity of a node to all of the other nodes in the network. Betweenness centrality involves nodes that are the links between two other nodes. 

Anakin has the highest centrality with 42 connections, followed by Obi-Wan at 37, C-3PO at 36, and Padme at 34. These are the characters that interacted with the most characters. 

None of the characters have a high closeness, which is unsurprising because there are three distinct sets of movies and there are very few characters that have interactions in two or three of them. C-3PO, Obi-Wan, Anakin, Luke, R2-D2, Han, and the Emperor all have a closeness between 0.0045 and 0.0051, and all of them appeared more than one set of the movies.

Obi-Wan has by far the highest betweenness score, 1266, with C-3PO coming in at 1063.Anakin, Luke, Han, and Darth Vader round out the top six, each having a betweenness score higher than 500. Without these characters, the network would be much more inefficient.
One other aspect that is related to centrality is the notion of cut points. A cut point is a node that, when eliminated, would produce more components in the network. There are eight such characters: Obi-Wan, Wedge, General Hux, Darth Vader, Ki-Adi-Mundi, Yoda, Luke, and Jar Jar.

Obi-Wan and C-3PO seem to be the most prominent players in the Star Wars saga. They are the only characters that are in the top three of each of the centrality scores. They have the most interactions, are closest to all other characters, and they create more efficient networks. Obi-Wan is also a cut point, which gives even more importance to the character. 

## Network Visualized

Figure 1
![](/images/starwars.png)

Figure 1 shows the entire network. The nodes are colored according to affiliation. The “good guys” are shown with green nodes and include Jedi, the Rebel Alliance, the Resistance, the Republic, and the Naboo. The “bad guys” are shown in red nodes and include the Trade Federation, the Empire, Sith, and the First Order. All others are considered neutral and are shown in light blue.

The color of the edges in Figure 1 correspond to how the two nodes relate to each other. Green edges indicate that the two characters, for the most part, are allies. Red edges indicate that they are enemies. Gray edges indicate that they have a neutral relationship.

## Community Detection

Community detection started with looking at a character’s affiliation and species. There are 15 affiliations and 26 species among the 112 characters. The modularity score for affiliation is 0.225, which implies that affiliation does account for some of the clustering. The modularity score for species is 0.039, which suggests that species does not do a good job of explaining the clusters.

Several clustering algorithms were applied to the network with the results shown in Figure 2.

Figure 2
![](/images/community.png)

Most of the algorithms do a better job of explaining the communities with far fewer groups. Leading Eigenvector, Fast Greedy, Louvain, and Springlass had the highest modularity. Figure 3 shows the communities found by each of the four.

Figure 3
![](/images/commdet.png)

Of those, the Fast Greedy algorithm produced the fewest number of groups. A closer look at the groups reveals some insight into how the groups are connected. Figure 4 shows the affiliations that are in each group.

Figure 4
![](/images/fastgreedytable.png)

Group 1 is made up of affiliations that are seen in Episodes 1 through 3. Group 2 is made up of affiliations seen in Episodes 4 through 6. Group 4 is made up of just the Resistance, seen in Episode 7. Group 3 is the only group that is made up of affiliations that span trilogies, having some that are in Episodes 4 through 6 and Episode 7.

Figure 5
![](/images/FastGreedy.png)

You can see the groups more clearly in Figure 5. Group 1 is on top with orange nodes and contains characters from the Prequel Trilogy. Group 2 is to the left of that with green nodes and is the only group that spans trilogies, with charters from the Original Trilogy and from the Final Trilogy. Group 3 is to the right with light blue nodes and is made up of characters from the Original Trilogy. Finally, Group 4 is the small group on the left with yellow nodes, with just four characters from the Final Trilogy. 

## Network Modelling
### Null Model

The first model that was created was a NULL model that could be used to compare more sophisticated models to. Our NULL model used edges to produce a random model with the same number of edges. Looking at the density of the model, we see that it is indeed the same as the Star Wars network. Our baseline AIC is 3242. We will look for a decrease in the AIC by including more terms.

### Adding Features

Two of the major characteristics that we can look at are affiliation and species. Adding affiliation to the model gave us an AIC of 3074, a slight improvement over the baseline. Many of the affiliations produced significant results with p values below 0.01. Adding species did not improve the model by much and produced some NAs, which would interfere with analysis of the model fit.

The fact that the Fast Greedy community detection method seemed to point to the episodes as a possible factor, the episodes were added to the node attributes that were added to the model. Episodes 1, 3, 6, and 7 all were significant, so they were kept, and the rest were not included in the model. The AIC for this model is 2776.

Next, a dyadic predictor was added. Looking at the mixing matrices, affiliation looked like a better choice. Adding this predictor produced a significant positive influence and an AIC of 2486. This predictor will be kept.

Finally, dyad dependency was added. GWDegree, GWESP, and GWDSP were applied, but none of them improved the model.  
Thus, the final model and summary are shown in Appendix A.

The low p values show that a character appearing in Episodes 1,3,6, or 7 is a good predictor of who they will have relationships with. Some of the groups that a character can belong to are also good predictors, such as the First Order, Jedi, the Republic, the Resistance, Separatist, and Sith. 

### Model Fit

Appendix B shows the results of the Goodness of Fit test. This model did not do a good job with geodesic distance or edgewise shared partner. Twenty-two of the thirty-six parameters came up with a poor fit compared to the observed network.

The goodness of fit was better for degree and triad census. There were only four poor fits out of fifty-two parameters. 

This model really shined when it came to the model statistics. The p values for affiliation and episode ranged between 0.84 and 1.00, which means that the model was very accurate in creating relationships based on these parameters.

Figure 6 shows the original network and the simulated network. There does seem to be some similarities, but overall, this simulation does not seem to capture the clustering of the network accurately.

Figure 6
![](/images/simulation.png)

## Conclusion

George Lucas created a diverse universe that is rich with interactions. This analysis looked first at the central characters, then moved on to the relationships between the characters.

Most people would think that Luke Skywalker, or his father Anakin Skywalker, would be the central character in the Star Wars saga. This is a good assumption, as these are the focal characters in the story. However, Obi-Wan Kenobi and C-3PO were atop the different centrality measures that we looked at. Is it possible that this is the story of a Jedi Master and his faithful droid? Probably not, but these two play a central role in the story.

We looked at several factors that could influence relationships between characters. Of these, the character’s affiliation and appearing in Episodes 1,3,6, or 7 were the best predictors of relationships. Even with these predictors, though, the model did not perform as well as we may have hoped. 

## Appendix A

![](/images/codesnippet.png)

![](/images/summary.png)

## Appendix B
```
Goodness-of-fit for minimum geodesic distance 

     obs  min    mean  max MC p-value
1    452  400  450.35  502       1.00
2   2243 2358 2861.28 3287       0.00
3   2547 2222 2505.02 2878       0.74
4    810   55  269.50  551       0.00
5    145    0   10.29  103       0.00
6     19    0    0.21    8       0.00
Inf    0    0  119.35  438       0.62

Goodness-of-fit for edgewise shared partner 

      obs min   mean max MC p-value
esp0    9  85 105.65 134       0.00
esp1   35  82 107.13 132       0.00
esp2   50  55  79.97 114       0.00
esp3   62  31  52.23  73       0.20
esp4   44  17  33.10  56       0.24
esp5   64  12  21.31  33       0.00
esp6   46   6  14.14  31       0.00
esp7   32   3  10.73  21       0.00
esp8   25   1   7.06  16       0.00
esp9   28   0   5.07  13       0.00
esp10  12   0   3.83  11       0.00
esp11   6   0   2.86   8       0.14
esp12   4   0   2.00   5       0.34
esp13   9   0   1.69   5       0.00
esp14   6   0   1.33   6       0.02
esp15   2   0   0.75   3       0.40
esp16   3   0   0.67   3       0.10
esp17   4   0   0.37   3       0.00
esp18   5   0   0.21   2       0.00
esp19   1   0   0.09   2       0.16
esp20   0   0   0.11   2       1.00
esp21   1   0   0.02   1       0.04
esp22   1   0   0.01   1       0.02
esp23   0   0   0.02   1       1.00
esp24   1   0   0.00   0       0.00
esp25   1   0   0.00   0       0.00
esp29   1   0   0.00   0       0.00

Goodness-of-fit for degree 

   obs min  mean max MC p-value
0    0   0  1.08   4       0.62
1    8   1  3.49   8       0.04
2   13   3  7.00  12       0.00
3   13   4 10.13  18       0.30
4   20   3 12.66  21       0.08
5    8   6 13.10  22       0.10
6    7   7 12.88  21       0.10
7    5   3 10.58  18       0.08
8    7   2  8.26  15       0.76
9    3   1  6.39  12       0.30
10   5   0  4.87  11       1.00
11   2   0  3.98  10       0.54
12   1   0  2.53   7       0.58
13   1   0  1.95   9       0.86
14   2   0  1.41   4       0.82
15   0   0  1.17   3       0.46
16   2   0  0.88   3       0.42
17   3   0  0.68   3       0.04
18   0   0  0.56   3       1.00
19   1   0  0.69   4       1.00
20   0   0  0.61   2       1.00
21   0   0  0.54   3       1.00
22   0   0  0.52   3       1.00
23   2   0  0.30   3       0.06
24   1   0  0.30   2       0.54
25   1   0  0.32   3       0.54
26   1   0  0.25   2       0.44
27   2   0  0.23   3       0.06
28   0   0  0.48   2       1.00
29   0   0  0.39   2       1.00
30   0   0  0.39   2       1.00
31   0   0  0.45   2       1.00
32   0   0  0.40   3       1.00
33   0   0  0.33   2       1.00
34   1   0  0.38   2       0.66
35   0   0  0.32   2       1.00
36   1   0  0.21   2       0.40
37   1   0  0.27   2       0.50
38   0   0  0.19   2       1.00
39   0   0  0.17   2       1.00
40   0   0  0.13   1       1.00
41   0   0  0.13   1       1.00
42   1   0  0.12   2       0.22
43   0   0  0.06   1       1.00
44   0   0  0.09   1       1.00
45   0   0  0.07   1       1.00
46   0   0  0.05   1       1.00
48   0   0  0.01   1       1.00

Goodness-of-fit for triad census 

     obs    min      mean    max MC p-value
0 184413 179476 183962.83 188664       0.86
1  38154  34691  38741.23  42412       0.66
2   4493   3941   4850.55   5941       0.38
3    860    279    365.39    495       0.00

Goodness-of-fit for model statistics 

                                        obs min   mean max MC p-value
edges                                   452 400 450.35 502       1.00
nodefactor.affiliation.bounty hunter     10   4   9.83  16       1.00
nodefactor.affiliation.empire            55  39  54.03  79       0.84
nodefactor.affiliation.first order       26  14  26.12  40       1.00
nodefactor.affiliation.gungan            10   3  10.12  17       1.00
nodefactor.affiliation.jedi             146 125 145.10 166       0.92
nodefactor.affiliation.naboo             53  32  52.69  71       0.98
nodefactor.affiliation.none              75  53  74.55 107       0.94
nodefactor.affiliation.podracer           6   1   5.90  14       1.00
nodefactor.affiliation.republic         111  84 111.47 132       1.00
nodefactor.affiliation.resistance        89  62  87.38 115       0.92
nodefactor.affiliation.separatist        15   6  15.15  27       1.00
nodefactor.affiliation.sith              14   6  13.67  24       1.00
nodefactor.affiliation.smuggler          25  15  25.02  34       1.00
nodefactor.affiliation.trade federation  31  20  31.00  45       1.00
nodecov.ep1                             413 361 412.45 471       0.96
nodecov.ep3                             489 428 486.98 542       1.00
nodecov.ep6                             368 329 366.29 416       0.94
nodecov.ep7                             323 275 321.10 375       0.86
nodematch.affiliation                   164 132 164.09 193       1.00
```

## References

(n.d.). Retrieved from Star Wars: https://www.starwars.com/

(n.d.). Retrieved from Wookipedia: https://starwars.fandom.com/wiki/Main_Page

Abrams, J. (Producer), & Abrams, J. (Director). (2015). Star Wars: The Force Awakens [Motion Picture].

Gabasova, E. (2016). Star Wars social network. doi:10.5281/zenodo.1411479

Kurtz, G. (Producer), & Lucas, G. (Director). (1977). Star Wars: A New Hope [Motion Picture].

Kutz, G. (Producer), & Lucas, G. (Director). (1980). Star Wars: The Empire Strikes Back [Motion Picture].


Luke, D. A. (2015). A User's Guide to Network Analysis in R. Springer International Publishing.

McCallum, R. (Producer), & Lucas, G. (Director). (1983). Star Wars: Return of the Jedi [Motion Picture].

McCallum, R. (Producer), & Lucas, G. (Director). (1999). Star Wars: The Phantom Menace [Motion Picture].

McCallum, R. (Producer), & Lucas, G. (Director). (2002). Star Wars: Attack of the Clones [Motion Picture].

McCallum, R. (Producer), & Lucas, G. (Director). (2005). Star Wars: Revenge of the Sith [Motion Picture].



# scidb-dashboard
Dashboard for visualizing data-skew in SciDB arrays

The dashboard allows the end-user to visualize the distribution through a simple user-interface. See the demo below to get an idea of how a simple UI can help users debug data skew problems in SciDB. 

# Quick demo

## Step 1

Image below shows the distribution of a SciDB array that is resident on only one instance (!). All other instances have a count of zero. 
**PS**: No harm done here, this is probably a small array.

<img src="https://cloud.githubusercontent.com/assets/13973052/20936342/4732fb0e-bbb0-11e6-8e83-4e2cbc590dec.png" width="600" border="2">

## Step 2

Next, the user can select (via a drop-down) any array that is available on SciDB (script currently removes temporary arrays created by SciDB-R). 

<img src="https://cloud.githubusercontent.com/assets/13973052/20936350/4e64bae8-bbb0-11e6-867c-e6e611d257bb.png" width="600" border="2">

## Step 3

Let us look at an important array -- the genotype array for variant data from the 1000 genomes project

<img src="https://cloud.githubusercontent.com/assets/13973052/20936359/535c566e-bbb0-11e6-94c7-9f7f503ee3ae.png" width="600" border="2">

Note that the count is scaled to the minimum in this case. 

Looks like the data skew is 2x! We can do much better.

## 4

Now, the same data but arranged via a different schema. 

<img src="https://cloud.githubusercontent.com/assets/13973052/20936601/2fd295a4-bbb1-11e6-8ead-501cf6bb4a22.png" width="600" border="2">

This time, the data skew is just 1.01x. That is much better. 





# scidb-dashboard
Dashboard for visualizing data-skew in SciDB arrays

The dashboard allows the end-user to visualize the distribution through a simple user-interface. See the demo below to get an idea of how a simple UI can help users debug data skew problems in SciDB. 

# Quick demo

## Step 1

Image below shows the distribution of a SciDB array that is resident on only one instance (!). All other instances have a count of zero. 
**PS**: No harm done here, this is probably a small array.

<img src="https://cloud.githubusercontent.com/assets/13973052/20946265/0cc39fdc-bbd8-11e6-9dce-ac5b2a362c18.png" width="600" border="2">

## Step 2

Let us look at an important array -- the genotype array for variant data from the 1000 genomes project

<img src="https://cloud.githubusercontent.com/assets/13973052/20946277/18c5ef38-bbd8-11e6-8abd-28828db75612.png" width="600" border="2">

Note that the count is scaled to the minimum in this case. 

Looks like the data skew is 2x! We can do much better.

## Step 3

Now, the same data but arranged via a different schema. 

<img src="https://cloud.githubusercontent.com/assets/13973052/20946299/27f25a46-bbd8-11e6-8ff7-cd7f05ab363e.png" width="600" border="2">

This time, the data skew is much much better. 

## Step 4

We can also compare the two schema:

<img src="https://cloud.githubusercontent.com/assets/13973052/20946311/31a846ae-bbd8-11e6-8870-0c5ecd915c03.png" width="600" border="2">




# scidb-dashboard
Dashboard for visualizing data-skew in SciDB arrays

The dashboard allows the end-user to visualize the SciDB array distribution across instances through a simple user-interface. The dashboard also outputs the array-size in human readable format.

The say a picture is worth a thousand words, so here a few thousands words about the UI.

### 1

<img src="https://cloud.githubusercontent.com/assets/13973052/21442318/372a1a68-c86b-11e6-882d-6a664ae6f11c.png" width="600" border="2">

Image shows the distribution of a SciDB array that is resident on only one instance (!). All other instances have a count of zero. 
**PS**: No harm done here, this is probably a small array.

### 2

<img src="https://cloud.githubusercontent.com/assets/13973052/21442321/3b04be4a-c86b-11e6-92ee-fd571784720e.png" width="600" border="2">

This is an important array -- the genotype array for variant data from the 1000 genomes project (20 GB on disk). Seems to be pretty well distributed. 

### 3

<img src="https://cloud.githubusercontent.com/assets/13973052/21442327/413f39d4-c86b-11e6-9f98-b133cd8d5ab3.png" width="600" border="2">

Now comparing two arrays -- the second array is not that well distributed. Also note how I used the scaling option. 

# Installation

## R packages

```
sudo R --slave -e "install.packages('shiny')"
sudo R --slave -e "install.packages('shinyjs')"
```

## Caching (optional)

If you want to cache array statistics, install Redis as a service. 
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-redis

And install the R package `rredis`. 

```
sudo R --slave -e "install.packages('rredis')"
```

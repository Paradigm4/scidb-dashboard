rm(list=ls())
library(scidb)
scidbconnect()

library(rredis)
redisConnect()

source('~/p4scratch/scidb-dashboard/functions.R')

# arrayList = iquery("project(filter(list(), temporary=FALSE), name)", return=TRUE)$name

for (array in arrayList()){
  cat(sprintf("updating entry for %s\n", array))
  latest_version = max(iquery(sprintf("versions(%s)", array), return=TRUE)$version_id)
  latest_array_stats = iquery(sprintf("project(summarize(%s, 'per_instance=1'), count)", array), return=TRUE)
  
  redisSet(sprintf("scidb:%s", array), list(latest_version, latest_array_stats))
}
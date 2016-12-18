rm(list=ls())
library(scidb)
scidbconnect()

library(rredis)
redisConnect()

arrayList = iquery("project(filter(list(), temporary=FALSE), name)", return=TRUE)$name

for (array in arrayList){
  latest_version = max(iquery(sprintf("versions(%s)", array), return=TRUE)$VersionNo)
  latest_array_stats = iquery(sprintf("project(summarize(%s, 'per_instance=1'), count)", array), return=TRUE)
  
  redisSet(sprintf("scidb:%s", array), list(latest_version, latest_array_stats))
}
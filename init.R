rm(list=ls())
library(scidb)
scidbconnect()

library(rredis)
redisConnect()

source('functions.R')

# arrayList = iquery(db, "project(filter(list(), temporary=FALSE), name)", return=TRUE)$name

for (array in arrayList()){
  cat(sprintf("updating entry for %s\n", array))
  latest_version = max(iquery(db, sprintf("versions(%s)", array), return=TRUE)$version_id)
  latest_array_stats = iquery(db, sprintf("project(summarize(%s, 'per_instance=1'), count, bytes)", array), return=TRUE)
  
  redisSet(sprintf("scidb:%s", array), list(latest_version, latest_array_stats))
}
redisClose()
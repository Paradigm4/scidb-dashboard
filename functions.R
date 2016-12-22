arrayList <- function() {
  arrayList = iquery("project(filter(list(), temporary=FALSE), name)", return=TRUE)$name
  notR_arrays = !(grepl("R_array+", arrayList, perl=TRUE))
  arrayList[notR_arrays]
}

get_array_stats = function(array, useCache = TRUE) {
  if (useCache){
    query = sprintf("project(versions(%s), version_id)", array)
    dims = "VersionNo"
    attribs = "version_id"
    TYPES = "int64"
    NULLABILTY = FALSE
    
    # t1 = proc.time(); 
    key = sprintf("scidb:%s", array)
    latest_version_in_db = max(query_to_df(query, dims, attribs, TYPES, NULLABILTY)$version_id); 
    latest_cache = redisGet(key)
    latest_version_in_cache = latest_cache[[1]]
    if (latest_version_in_db == latest_version_in_cache) {
      latest_array_stats = latest_cache[[2]]
    } else {
      latest_array_stats = iquery(sprintf("project(summarize(%s, 'per_instance=1'), count, bytes)", array), return = TRUE)
      redisSet(sprintf(key, list(latest_version_in_db, latest_array_stats)))
    }
    # print(proc.time()-t1)
  } else {
    # t1 = proc.time(); 
    latest_array_stats = iquery(sprintf("project(summarize(%s, 'per_instance=1'), count, bytes)", array), return = TRUE); 
    # print(proc.time()-t1)
  }
  return(latest_array_stats[, c("inst", "count", "bytes")])
}
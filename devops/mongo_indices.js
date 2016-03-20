db.stations.ensureIndex({'_id.systemId':1})

db.stations.ensureIndex({'_id.systemId':1,'_id.date':1})

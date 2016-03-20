// Most recent station snap only return ID

db.station_snaps_summary_babs.find({},{_id:1}).sort({"_id.ts":-1}).limit(1).pretty()

// output all station snaps between TSs most recent first

db.station_snaps_summary_babs.find({
  "_id.ts": { $gte: ISODate("2015-11-07T00:00:00.000Z"), $lt: ISODate("2015-11-08T00:00:00.000Z") }
}, {_id : 1}).sort({"_id.ts":-1}).pretty()

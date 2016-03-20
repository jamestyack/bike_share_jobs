// GMT - day of snaps sorted by time

var snapsBabs = db.station_snaps_summary_babs.find({ "_id.ts": {
    $gte: ISODate("2015-10-28T00:00:00.000Z"),
    $lt: ISODate("2015-10-29T00:00:00.000Z") } }).sort({"_id.ts":1});


db.station_snaps_summary_babs.find({ '_id.ts':
   { '$gte': ISODate("2015-10-28T00:00:00.000Z"),
     '$lt': ISODate("2015-10-29T00:00:00.000Z") } }).sort({"_id.ts":1});



// EST - indego (Philly)

var snaps = db.station_snaps_summary_indego.find({ "_id.ts": {
      $gte: ISODate("2015-10-20T00:00:00.000−05:00"),
      $lt: ISODate("2015-10-21T00:00:00.000−05:00") } },{_id:1}).sort({"_id.ts":1});

while(snaps.hasNext()) {
  //printjson(snaps.next());
  snap = snaps.next()
  printjson(snap._id);
}

// PST - indego (Bay Area Bike Share)

var snaps = db.station_snaps_summary_babs.find({ "_id.ts": {
    $gte: ISODate("2015-11-09T00:00:00.00-08:00"),
    $lt: ISODate("2015-11-10T00:00:00.00-08:00") } },{_id:1}).sort({"_id.ts":1});

while(snaps.hasNext()) {
    //printjson(snaps.next());
    snap = snaps.next()
    printjson(snap._id);
}

var eddystoneBeacon = require('eddystone-beacon');
var url = 'http://vingtetun.org';

eddystoneBeacon.advertiseUrl(url);
console.log("Advertising", url);

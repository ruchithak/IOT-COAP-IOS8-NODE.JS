const coap  = require("coap") // or coap
//const req   = coap.request('coap://localhost/tempupdates/3')
//const req   = coap.request('coap://localhost/lightupdates/3')
//const req   = coap.request('coap://localhost/temperaturedatebetween/start=2015-10-01T11:07:51.941Z&end=2015-10-03T11:07:52.941Z')
//const req   = coap.request('coap://localhost/lightdatebetween/start=2015-10-05T11:07:51.941Z&end=2015-10-10T11:07:52.941Z')
//const req   = coap.request('coap://localhost/temperaturerange/low=110.000')
//const req  = coap.request('coap://localhost/lightrange/low=100')

//const req   = coap.request('coap://localhost/lightupdatesff/3')

const req   = coap.rquest({ observe: true})


req.on('response', function(res) {
    res.pipe(process.stdout)


})


//req2.on('response', function(res) {
//    res.pipe(process.stdout)
//})

req.end()

//req2.end()
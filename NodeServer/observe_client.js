const coap    = require("coap")  // or coap
    , req   = coap.request({
                observe: true
              })

req.on('response', function(res) {
  res.pipe(process.stdout)
})

req.end()

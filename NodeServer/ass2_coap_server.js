const coap    = require("coap") // or coap
    , server  = coap.createServer()


var fs = require("fs");


var temperaturecontent;
// First I want to read the file
fs.readFile("temperatureSensor.txt", "utf8", function read(err, data) {
    if (err) {
        throw err;
    }
    temperaturecontent = data;

    // Invoke the next step here however you like
    //console.log(content);   // Put all of the code here (not the best solution)
    //  processFile();          // Or put the next step in a function and invoke it
});


var lightsensorcontent;
// First I want to read the file
fs.readFile("lightSensor.txt", "utf8", function read(err, data) {
    if (err) {
        throw err;
    }
    lightsensorcontent = data;

    // Invoke the next step here however you like
    //console.log(content);   // Put all of the code here (not the best solution)
    //  processFile();          // Or put the next step in a function and invoke it
});






var timeoutHandle = null;

function startTimeout() {
    stopTimeout();
    timeoutHandle = setTimeout(updateStream, 2000);
}

function stopTimeout() {
    clearTimeout(timeoutHandle);
}

function updateStream(){
    fs.readFile("temperatureSensor.txt", "utf8", function read(err, data) {
        if (err) {
            throw err;
        }
        temperaturecontent = data;

        startTimeout(); // Make sure this line is always executed
    });
}

startTimeout();


var timeoutHandlelight = null;

function startTimeoutlight() {
    stopTimeoutlight();
    timeoutHandlelight = setTimeout(updateStreamlight, 2000);
}

function stopTimeoutlight() {
    clearTimeout(timeoutHandlelight);
}

function updateStreamlight(){
    fs.readFile("lightSensor.txt", "utf8", function read(err, data) {
        if (err) {
            throw err;
        }
        lightsensorcontent = data;

        startTimeoutlight(); // Make sure this line is always executed
    });
}

startTimeoutlight();






//function processFile() {
   // console.log(content);
//}

 server.on('request', function(req, res) {
        if (req.headers['Observe'] !== 0) {


            console.log(req.url)
            var str = temperaturecontent.split("\n")
            var temperatureObjectArray = new Array()



            for	(index = 0; index < str.length; index++) {
                var str1 = str[index].split("|")

                var obj = new Object();
                obj.time = str1[0];
                obj.temperature  = str1[1];
                temperatureObjectArray.push(obj)
            }

            var obj2 = new Object();


            var str = lightsensorcontent.split("\n")
            var lightObjectArray = new Array()



            for	(index = 0; index < str.length; index++) {
                var str1 = str[index].split("|")

                var obj = new Object();
                obj.time = str1[0];
                obj.value  = str1[1];
                lightObjectArray.push(obj)
            }

            var jsonresponse = new Object();


            if(req.url.split('/')[1] == "tempupdates" )
            {

                if(req.url.split('/')[2]>0)
                {
                    var slisedlightObject = temperatureObjectArray.slice(-req.url.split('/')[2]);
                    jsonresponse.size = slisedlightObject.length
                    jsonresponse.temperatureValues = slisedlightObject
                    var jsonString= JSON.stringify(jsonresponse);
                    res.end(jsonString)


                }

            }
            else if(req.url.split('/')[1] == "lightupdates" ) {

                if (req.url.split('/')[2] > 0) {
                    var slisedlightObject = lightObjectArray.slice(-req.url.split('/')[2]);

                    jsonresponse.size=slisedlightObject.length
                    jsonresponse.lightValues = slisedlightObject


                    var jsonString = JSON.stringify(jsonresponse);
                    res.end(jsonString)


                }
            }

            else if(req.url.split('/')[1] == "temperaturerange" )
            {

                var low  = req.url.split('/')[2].split('&')[0].split('=')[1];
                var temperatureObjectArraytemp = new Array()
                for (i = 0; i < temperatureObjectArray.length; i++) {

                    if(temperatureObjectArray[i].temperature> parseFloat(low)){
                        temperatureObjectArraytemp.push(temperatureObjectArray[i])

                    }

                }



                jsonresponse.size = temperatureObjectArraytemp.length
                jsonresponse.temperatureValues = temperatureObjectArraytemp
                var jsonString= JSON.stringify(jsonresponse);
                res.end(jsonString)



            }


            else if(req.url.split('/')[1] == "lightrange" )
            {

                var low  = req.url.split('/')[2].split('&')[0].split('=')[1];
                var lightObjectArraytemp = new Array()
                for (i = 0; i < lightObjectArray.length; i++) {

                    if(lightObjectArray[i].value> parseFloat(low)){

                        lightObjectArraytemp.push(lightObjectArray[i])

                    }

                }

                jsonresponse.size = lightObjectArraytemp.length
                jsonresponse.lightValues = lightObjectArraytemp
                var jsonString= JSON.stringify(jsonresponse);
                res.end(jsonString)



            }


            else if(req.url.split('/')[1] == "temperaturedatebetween" )
            {

                var start  = req.url.split('/')[2].split('&')[0].split('=')[1];
                var end  = req.url.split('/')[2].split('&')[1].split('=')[1];



                var startdate  = new Date(req.url.split('/')[2].split('&')[0].split('=')[1]);
                var enddate  = new Date(req.url.split('/')[2].split('&')[1].split('=')[1]);

                var temperatureObjectArraytemp = new Array()
                // var slisedlightObject = temperatureObjectArray.slice(0, req.url.split('/')[2])

                console.log(startdate);
                console.log(enddate);
                //

                for (i = 0; i < temperatureObjectArray.length; i++) {

                    if(new Date(temperatureObjectArray[i].time)> startdate && new Date(temperatureObjectArray[i].time) < enddate){
                        temperatureObjectArraytemp.push(temperatureObjectArray[i])

                    }

                }


                jsonresponse.size = temperatureObjectArraytemp.length
                jsonresponse.temperatureValues = temperatureObjectArraytemp
                var jsonString= JSON.stringify(jsonresponse);
                res.end(jsonString)

            }

            else if(req.url.split('/')[1] == "lightdatebetween" )
            {

                var start  = req.url.split('/')[2].split('&')[0].split('=')[1];
                var end  = req.url.split('/')[2].split('&')[1].split('=')[1];



                var startdate  = new Date(req.url.split('/')[2].split('&')[0].split('=')[1]);
                var enddate  = new Date(req.url.split('/')[2].split('&')[1].split('=')[1]);

                var lightObjectArraytemp = new Array()
                console.log(startdate);
                console.log(enddate);
                //

                for (i = 0; i < lightObjectArray.length; i++) {

                    //console.log("1="+temperatureObjectArray[i].time);

                    if(new Date(lightObjectArray[i].time)> startdate && new Date(lightObjectArray[i].time) < enddate){
                        lightObjectArraytemp.push(lightObjectArray[i])

                    }

                }

                jsonresponse.size = lightObjectArraytemp.length
                jsonresponse.lightValues = lightObjectArraytemp
                var jsonString= JSON.stringify(jsonresponse);
                res.end(jsonString)



            }
            jsonresponse.value = "error"
            var jsonString= JSON.stringify(jsonresponse);
            res.end(jsonString)







            return res.end(new Date().toISOString() + '\n')


        }

        var interval = setInterval(function() {



            var str = temperaturecontent.split("\n")
            var temperatureObjectArray = new Array()



            for	(index = 0; index < str.length; index++) {
                var str1 = str[index].split("|")

                var obj = new Object();
                obj.time = str1[0];
                obj.temperature  = str1[1];
                temperatureObjectArray.push(obj)
            }



            var str = lightsensorcontent.split("\n")
            var lightObjectArray = new Array()



            for	(index = 0; index < str.length; index++) {
                var str1 = str[index].split("|")

                var obj = new Object();
                obj.time = str1[0];
                obj.value  = str1[1];
                lightObjectArray.push(obj)
            }



            var obj = new Object();
            //obj.temperature = temperatureObjectArray[temperatureObjectArray.length-1];
            //obj.lightvalue  = lightObjectArray[lightObjectArray.length-1];

            obj.temperature = temperatureObjectArray[temperatureObjectArray.length-1].temperature;

            obj.lightvalue  = lightObjectArray[lightObjectArray.length-1].value;

            obj.timetemperature = temperatureObjectArray[temperatureObjectArray.length-1].time;
            obj.timelightvalue  = lightObjectArray[lightObjectArray.length-1].time;


            //res.write(new Date().toISOString() + '\n')

            var jsonString= JSON.stringify(obj);
            res.write(jsonString  + '\n')


           // res.write(new Date().toISOString() + '\n')







        }, 2000)

        res.on('finish', function(err) {
            clearInterval(interval)
        })














})

server.listen(function() {
  console.log('server started')
})




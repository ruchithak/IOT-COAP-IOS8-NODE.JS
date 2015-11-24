
//  Created by Richie on 4/10/2015.
//

import UIKit

class ObserveViewController: UIViewController {
    @IBOutlet weak var teperaturetextView: UITextView!
    @IBOutlet weak var lighttextView: UITextView!
    
    
    
    let separatorLine = "\n-----------------------------------------------\n"
    
    var coapClient: SCClient!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        coapClient = SCClient(delegate: self)
        //coapClient.cachingActive = true
        coapClient.sendToken = true
        coapClient.autoBlock1SZX = 2
        self.teperaturetextView.text = "hi"
        self.lighttextView.text = "hi"
        //coapClient.httpProxyingData = ("localhost", 5683)
        
        
        let m = SCMessage(code: SCCodeValue(classValue: 0, detailValue: 01)!, type: .Confirmable, payload: "test".dataUsingEncoding(NSUTF8StringEncoding))
        
//        var locationUrl = "lightupdates/" + self.lightN.text
        
       // m.addOption(SCOption.UriPath.rawValue, data: locationUrl.dataUsingEncoding(NSUTF8StringEncoding)!)
        m.addOption(SCOption.Observe.rawValue, data: NSData(bytes: [0], length: 1));

        
        coapClient.sendCoAPMessage(m, hostName: "localhost", port: 5683)
        
        
        
        //Default values, change if you want
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        coapClient = SCClient(delegate: self)
        //coapClient.cachingActive = true
        coapClient.sendToken = true
        coapClient.autoBlock1SZX = 2
        self.teperaturetextView.text = ""
        self.lighttextView.text = ""
        //coapClient.httpProxyingData = ("localhost", 5683)
        
        
        let m = SCMessage(code: SCCodeValue(classValue: 0, detailValue: 01)!, type: .Confirmable, payload: "test".dataUsingEncoding(NSUTF8StringEncoding))
        
        //        var locationUrl = "lightupdates/" + self.lightN.text
        
        // m.addOption(SCOption.UriPath.rawValue, data: locationUrl.dataUsingEncoding(NSUTF8StringEncoding)!)
        m.addOption(SCOption.Observe.rawValue, data: NSData(bytes: [0], length: 1));
        
        
        coapClient.sendCoAPMessage(m, hostName: "localhost", port: 5683)

    }
    
    
    @IBAction func onClickSendMessage(sender: AnyObject) {

        
    }
    
   
    
    
}








extension ObserveViewController: SCClientDelegate {
    func swiftCoapClient(client: SCClient, didReceiveMessage message: SCMessage) {
        var payloadstring = ""
        var jsonprintTemperature = ""
        var jsonprintLight = ""
        println("Hello")
        
        
        if let pay = message.payload {
            if let string = NSString(data: pay, encoding:NSUTF8StringEncoding) {
                payloadstring = String(string)
                println(payloadstring)
            }
        }
        
        
        
        
        let firstPartString = "\(payloadstring)"
        
        if  !message.type.shortString().isEqual("NON")  {
            
            //   var jsonStr = "{\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],}"
            var data = firstPartString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)
            var localError: NSError?
            var json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &localError)
            
           jsonprintTemperature = " "
            if let dict = json as? [String: AnyObject] {
                
                
                if let timetemperature = dict["timetemperature"] as? String {
                    
                    jsonprintTemperature = "\(timetemperature)" + " = "
                    
                }
                
                
                if let temperature = dict["temperature"] as? String {
                    
                    jsonprintTemperature += "\(temperature)" + " \n"
                    
                }
                
                
                
                if let timelightvalue = dict["timelightvalue"] as? String {
                    
                    jsonprintLight = "\(timelightvalue)" + " = "
                    
                }
                
                
                if let lightvalue = dict["lightvalue"] as? String {
                    
                    jsonprintLight += "\(lightvalue)" + " \n"
                    
                }
                
                

                
                
                
                
       
            }
            
            
            
            
            lighttextView.text =  jsonprintLight + lighttextView.text
            teperaturetextView.text =  jsonprintTemperature + teperaturetextView.text
            
            
        }
        
    }
    
    func swiftCoapClient(client: SCClient, didFailWithError error: NSError) {
        //textView.text = "Failed with Error \(error.localizedDescription)" + separatorLine + separatorLine + textView.text
    }
    
    func swiftCoapClient(client: SCClient, didSendMessage message: SCMessage, number: Int) {
        //        textView.text = "Message sent (\(number)) with type: \(message.type.shortString()) with id: \(message.messageId)\n" + separatorLine + separatorLine + textView.text
    }
}
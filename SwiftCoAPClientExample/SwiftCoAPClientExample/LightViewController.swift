//
//  LightViewController.swift
//  SwiftCoAPClientExample
//
//  Created by Richie on 4/10/2015.
//
//

import UIKit

class LightViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var lightmintext: UITextField!
    
    @IBOutlet weak var mindatetext: UITextField!
    
    @IBOutlet weak var maxdatetext: UITextField!
    
    //    @IBOutlet weak var hostTextField: UITextField!
    //    @IBOutlet weak var uriPathTextField: UITextField!
    //    @IBOutlet weak var portTextField: UITextField!
    
    @IBOutlet weak var lightN: UITextField!
    
    
    
    let separatorLine = "\n-----------------------------------------------\n"
    
    var coapClient: SCClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coapClient = SCClient(delegate: self)
        //coapClient.cachingActive = true
        coapClient.sendToken = true
        coapClient.autoBlock1SZX = 2
        self.textView.text = ""
        //coapClient.httpProxyingData = ("localhost", 5683)
        
        //Default values, change if you want
        
        
    }
    
    
    @IBAction func onClickSendMessage(sender: AnyObject) {
        
        
        self.textView.text = ""
        let m = SCMessage(code: SCCodeValue(classValue: 0, detailValue: 01)!, type: .Confirmable, payload: "test".dataUsingEncoding(NSUTF8StringEncoding))
        
        var locationUrl = "lightupdates/" + self.lightN.text
        
        m.addOption(SCOption.UriPath.rawValue, data: locationUrl.dataUsingEncoding(NSUTF8StringEncoding)!)
        coapClient.sendCoAPMessage(m, hostName: "localhost", port: 5683)
        
    }
    
    @IBAction func onClickLightMinimum(sender: AnyObject) {
        
        self.lightN.text = ""
        self.textView.text = ""
        let m = SCMessage(code: SCCodeValue(classValue: 0, detailValue: 01)!, type: .Confirmable, payload: "test".dataUsingEncoding(NSUTF8StringEncoding))
        
        var locationUrl = "lightrange/low=" + self.lightmintext.text
        
        m.addOption(SCOption.UriPath.rawValue, data: locationUrl.dataUsingEncoding(NSUTF8StringEncoding)!)
        coapClient.sendCoAPMessage(m, hostName: "localhost", port: 5683)
        
    }
    
    
    @IBAction func onClickLightTimeRange(sender: AnyObject) {
        
        self.lightN.text = ""
        self.textView.text = ""
        let m = SCMessage(code: SCCodeValue(classValue: 0, detailValue: 01)!, type: .Confirmable, payload: "test".dataUsingEncoding(NSUTF8StringEncoding))
        
        var locationUrl = "lightdatebetween/start=" + self.mindatetext.text + "Z&end=" + self.maxdatetext.text + "Z"
        
        m.addOption(SCOption.UriPath.rawValue, data: locationUrl.dataUsingEncoding(NSUTF8StringEncoding)!)
        coapClient.sendCoAPMessage(m, hostName: "localhost", port: 5683)
        
    }
    
    
    
    
    
    
    
    
    
}








extension LightViewController: SCClientDelegate {
    func swiftCoapClient(client: SCClient, didReceiveMessage message: SCMessage) {
        var payloadstring = ""
        var jsonprint = ""
        
        
        if let pay = message.payload {
            if let string = NSString(data: pay, encoding:NSUTF8StringEncoding) {
                payloadstring = String(string)
            }
        }
        
        
        
        
        let firstPartString = "\(payloadstring)"
        
        if  !message.type.shortString().isEqual("NON")  {
            
            //   var jsonStr = "{\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04d\"}],}"
            var data = firstPartString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)
            var localError: NSError?
            var json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &localError)
            
            if let dict = json as? [String: AnyObject] {
                
                if let size = dict["size"] as? Int {
                    
                  
                    var reqN = lightN.text.toInt()
                    
                    jsonprint = "Number Values Received : " + "\(size)" + " \n" + separatorLine
                    
                    if(size < reqN  && reqN != nil){
                    
                        let alert = UIAlertView()
                        alert.title = "Alert"
                        alert.message = "N exceed total rows"
                        alert.addButtonWithTitle("OK")
                        alert.show()
                    
                    }
                    
                    
                }
                
                if let lightjson = dict["lightValues"] as? [AnyObject] {
                    for dict2 in lightjson {
                        let time = dict2["time"]
                        let light = dict2["value"]
                        
                        var strtime : String!
                        var strtemperature : String!
                        
                        if let tempReceiver: AnyObject = time {
                            strtime = "\(tempReceiver)"
                        }
                        
                        if let temp2Receiver: AnyObject = light {
                            strtemperature = "\(temp2Receiver)"
                        }
                        
                        jsonprint += strtime  + " = " + strtemperature + "\n"
                        
                        
                    }
                }
            }
            
            
            
            
            
            textView.text = jsonprint + separatorLine + textView.text
            
            
        }
        
    }
    
    func swiftCoapClient(client: SCClient, didFailWithError error: NSError) {
        textView.text = "Failed with Error \(error.localizedDescription)" + separatorLine + separatorLine + textView.text
    }
    
    func swiftCoapClient(client: SCClient, didSendMessage message: SCMessage, number: Int) {
        //        textView.text = "Message sent (\(number)) with type: \(message.type.shortString()) with id: \(message.messageId)\n" + separatorLine + separatorLine + textView.text
    }
}
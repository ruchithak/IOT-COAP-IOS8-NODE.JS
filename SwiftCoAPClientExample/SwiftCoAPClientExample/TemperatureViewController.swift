//
//  TemperatureViewController.swift
//  SwiftCoAPClientExample
//
//  Created by Richie on 4/10/2015.
//  Copyright (c) 2015 Wojtek Kordylewski. All rights reserved.
//

import UIKit

class TemperatureViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tempmintext: UITextField!
    
    @IBOutlet weak var mindatetext: UITextField!
    
    @IBOutlet weak var maxdatetext: UITextField!
    
    //    @IBOutlet weak var hostTextField: UITextField!
    //    @IBOutlet weak var uriPathTextField: UITextField!
    //    @IBOutlet weak var portTextField: UITextField!
    
    @IBOutlet weak var temperatureN: UITextField!
    
    
    
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

        var locationUrl = "tempupdates/" + self.temperatureN.text
        
        m.addOption(SCOption.UriPath.rawValue, data: locationUrl.dataUsingEncoding(NSUTF8StringEncoding)!)
        coapClient.sendCoAPMessage(m, hostName: "localhost", port: 5683)
        
    }
    
    @IBAction func onClickTempMinimum(sender: AnyObject) {
        
        self.temperatureN.text = ""
        self.textView.text = ""
        let m = SCMessage(code: SCCodeValue(classValue: 0, detailValue: 01)!, type: .Confirmable, payload: "test".dataUsingEncoding(NSUTF8StringEncoding))
        
        var locationUrl = "temperaturerange/low=" + self.tempmintext.text
        
        m.addOption(SCOption.UriPath.rawValue, data: locationUrl.dataUsingEncoding(NSUTF8StringEncoding)!)
        coapClient.sendCoAPMessage(m, hostName: "localhost", port: 5683)
   
    }
    
    
    @IBAction func onClickTempTimeRange(sender: AnyObject) {
        
        self.temperatureN.text = ""
        self.textView.text = ""
        let m = SCMessage(code: SCCodeValue(classValue: 0, detailValue: 01)!, type: .Confirmable, payload: "test".dataUsingEncoding(NSUTF8StringEncoding))
        
        var locationUrl = "temperaturedatebetween/start=" + self.mindatetext.text + "Z&end=" + self.maxdatetext.text + "Z"
        
        m.addOption(SCOption.UriPath.rawValue, data: locationUrl.dataUsingEncoding(NSUTF8StringEncoding)!)
        coapClient.sendCoAPMessage(m, hostName: "localhost", port: 5683)
        
    }
    
    
    
    
    
    
    
    
    
}








extension TemperatureViewController: SCClientDelegate {
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
                    var reqN = temperatureN.text.toInt()
                    
                    jsonprint = "Number Values Received : " + "\(size)" + " \n" + separatorLine
                    
                    if(size < reqN && reqN != nil ){
                        
                        let alert = UIAlertView()
                        alert.title = "Alert"
                        alert.message = "N exceed total rows \(reqN)"
                        alert.addButtonWithTitle("OK")
                        alert.show()
                        
                    }
                    
                    
                }
                
        
                
                if let temperaturejson = dict["temperatureValues"] as? [AnyObject] {
                    for dict2 in temperaturejson {
                        let time = dict2["time"]
                        let temperature = dict2["temperature"]
                        
                        var strtime : String!
                        var strtemperature : String!
                        
                        if let tempReceiver: AnyObject = time {
                            strtime = "\(tempReceiver)"
                        }
                        
                        if let temp2Receiver: AnyObject = temperature {
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
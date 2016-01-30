//
//  GameDataController.swift
//  GregsBadDay
//
//  Created by Chris Weathers on 1/30/16.
//
//

import Foundation

class GameDataController: NSObject {
    var name: String?
    var room: String?
    var team: String?
    
    var level: Int?
    
    var session: NSURLSession?
    
    var timer: NSTimer?
    
    func postRequestForPlayerAction(playerAction:PlayerAction, completionHandler:()->Void) {
        postRequestForTarget(playerAction.target.rawValue, value:playerAction.value, completionHandler:completionHandler)
    }
    
    func postRequestForTarget(target:String, value:Int, completionHandler:()->Void) {
        let urlString = "https://voodoo.madsciencesoftware.com"
        let url = NSURL(string: urlString)!
        let session = NSURLSession.sharedSession()
        
        let body = ["target":target, "value":value]
        
        var bodyData: NSData?
        
        do {
            bodyData = try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
        }
        catch {
            
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            completionHandler()
        }
        task.resume()
    }
    
    func start() {
        if (timer == nil) {
            timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "tick", userInfo: nil, repeats: true)
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func tick() {
        print("tick")
    }
    
    
    // arms, legs, body, head
    
    // "target"
    // "value"
}

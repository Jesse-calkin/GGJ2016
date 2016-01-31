//
//  GameDataController.swift
//  GregsBadDay
//
//  Created by Chris Weathers on 1/30/16.
//
//

import Foundation

class GameDataController: NSObject {
    var roundResult: RoundResult?
    
    var session: NSURLSession?
    
    func postRequestForPlayerAction(playerAction:PlayerAction, completionHandler:(roundResult:RoundResult)->Void) {
        postRequestForTarget(playerAction.target.rawValue, value:playerAction.value, completionHandler:completionHandler)
    }
    
    func postRequestForTarget(target:String, value:Int, completionHandler:(roundResult:RoundResult)->Void) {
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
            do {
                let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options:[]) as! [String: AnyObject]
                let currentRound = dictionary["current_level"] as! Int
                let nextRound = dictionary["next_level"] as! Int
                let score = dictionary["body_score"] as! Int
                let roundResult = RoundResult(currentRound:currentRound, nextRound:nextRound, score:score)
                completionHandler(roundResult:roundResult)
            } catch {
                
            }
        }
        task.resume()
    }
    
}

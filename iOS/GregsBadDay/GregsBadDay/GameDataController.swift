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
                let object = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
                print(object)
                let roundResult = RoundResult(currentRound:1, nextRound:2, score:3)
                completionHandler(roundResult:roundResult)
            } catch {
                
            }
        }
        task.resume()
    }
    
}

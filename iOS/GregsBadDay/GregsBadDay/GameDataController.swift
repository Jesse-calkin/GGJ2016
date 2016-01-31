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
    
    func postRequestForPlayerAction(playerAction:PlayerAction, completionHandler:(roundResult:RoundResult)-> Void) {
        
        let request = requestForPlayerAction(playerAction)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            let roundResult = self.roundResultForData(data!)
            self.roundResult = roundResult
            completionHandler(roundResult: roundResult!)
        }
        task.resume()
    }
    
    func bodyDataForPlayerAction(playerAction:PlayerAction)-> NSData? {

        do {
            let bodyDictionary = bodyDictionaryForPlayerAction(playerAction)
            let bodyData = try NSJSONSerialization.dataWithJSONObject(bodyDictionary, options:[])
            return bodyData
        }
        catch {
            return nil
        }
    }
    
    func bodyDictionaryForPlayerAction(playerAction:PlayerAction)-> [String: AnyObject] {
    
        let bodyDictionary = ["bodyValue": playerAction.bodyValue,
                              "headValue": playerAction.headValue,
                              "legsValue": playerAction.legsValue,
                           "leftArmValue": playerAction.leftArmValue,
                          "rightArmValue": playerAction.rightArmValue]
        return bodyDictionary
    }
    
    func requestForPlayerAction(playerAction:PlayerAction)-> NSURLRequest {
        
        let request = NSMutableURLRequest()
        
        request.HTTPMethod = "POST"
        
        let urlString = "https://voodoo.madsciencesoftware.com"
        let url = NSURL(string: urlString)!
        request.URL = url
        
        let body = bodyDataForPlayerAction(playerAction)
        request.HTTPBody = body
        
        return request
    }
    
    func roundResultDictionaryForData(data:NSData)-> [String: AnyObject]? {
        do {
            let dictionary = try NSJSONSerialization.JSONObjectWithData(data, options:[]) as! [String: AnyObject]
            return dictionary
        }
        catch {
            return nil
        }
    }
    
    func roundResultForData(data:NSData)-> RoundResult? {
        
        if let dictionary = roundResultDictionaryForData(data) {
            
            let bodyValue:Int = dictionary["body_score"] as! Int
            let headValue:Int = dictionary["head_score"] as! Int
            let leftArmValue:Int = dictionary["arms_score"] as! Int
            let legsValue:Int = dictionary["legs_score"] as! Int
            let rightArmValue:Int = dictionary["arms_score"] as! Int
            
            let currentRound:Int = dictionary["current_level"] as! Int
            let nextRound:Int = dictionary["next_level"] as! Int
            
            let roundResult:RoundResult = RoundResult(
                bodyValue:bodyValue,
                headValue: headValue,
                leftArmValue: leftArmValue,
                legsValue: legsValue,
                rightArmValue: rightArmValue,
                currentRound: currentRound,
                nextRound: nextRound
            )
            return roundResult
        }
        else {
            return nil
        }
    }
    
}

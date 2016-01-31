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
        
        let bodyDictionary = ["arm_left": playerAction.leftArmValue,
                             "arm_right": playerAction.rightArmValue,
                                  "body": playerAction.bodyValue,
                                  "head": playerAction.headValue,
                              "leg_left": playerAction.leftLegValue,
                             "leg_right": playerAction.rightLegValue,
        ]
        return bodyDictionary
    }
    
    func requestForPlayerAction(playerAction:PlayerAction)-> NSURLRequest {
        
        let request = NSMutableURLRequest()
        
        request.HTTPMethod = "POST"
        request.timeoutInterval = 60.0
        
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
            
            var roundResult = RoundResult()
            
            roundResult.bodyValue = dictionary["body_score"] as! Int
            roundResult.headValue = dictionary["head_score"] as! Int
            roundResult.leftArmValue = dictionary["arm_left_score"] as! Int
            roundResult.leftLegValue = dictionary["leg_left_score"] as! Int
            roundResult.rightArmValue = dictionary["arm_right_score"] as! Int
            roundResult.rightLegValue = dictionary["leg_right_score"] as! Int
            
            roundResult.currentRound = dictionary["current_level"] as! Int
            roundResult.nextRound = dictionary["next_level"] as? Int
            
            return roundResult
        }
        else {
            return nil
        }
    }
    
}

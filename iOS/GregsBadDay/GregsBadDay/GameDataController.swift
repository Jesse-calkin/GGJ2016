//
//  GameDataController.swift
//  GregsBadDay
//
//  Created by Chris Weathers on 1/30/16.
//
//

import Foundation

class GameDataController: NSObject {
    var affinity:Affinity
    var roundResult: RoundResult?
    
    override init() {
        
        self.affinity = .Bad
        
        super.init()
    }
    
    func postRequestForPlayerAction(playerAction:PlayerAction, completionHandler:(roundResult:RoundResult?)-> Void) {
        
        let request = requestForPlayerAction(playerAction)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in

            if let data = data {
                let roundResult = self.roundResultForData(data)
                self.roundResult = roundResult
                completionHandler(roundResult: roundResult)
            }
            else {
                completionHandler(roundResult: nil)
            }
        }
        task.resume()
    }
    
    func bodyDataForPlayerAction(playerAction:PlayerAction)-> NSData {
        
        let bodyDictionary = bodyDictionaryForPlayerAction(playerAction)
        let bodyData = try! NSJSONSerialization.dataWithJSONObject(bodyDictionary, options:[])
        return bodyData
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
    
    func roundResultDictionaryForData(data:NSData)-> [String: AnyObject] {
        
        let dictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as! [String: AnyObject]
        return dictionary
    }
    
    func roundResultForData(data:NSData)-> RoundResult {
        
        var dictionary = roundResultDictionaryForData(data)
        
        var roundResult = RoundResult()
        
        roundResult.bodyValue = (dictionary["body_score"] as? Int) ?? 0
        roundResult.headValue = (dictionary["head_score"] as? Int) ?? 0
        roundResult.leftArmValue = (dictionary["arm_left_score"] as? Int) ?? 0
        roundResult.leftLegValue = (dictionary["leg_left_score"] as? Int) ?? 0
        roundResult.rightArmValue = (dictionary["arm_right_score"] as? Int) ?? 0
        roundResult.rightLegValue = (dictionary["leg_right_score"] as? Int) ?? 0
        
        roundResult.currentRound = (dictionary["current_level"] as? Int) ?? 0
        roundResult.nextRound = dictionary["next_level"] as? Int
            
        return roundResult
    }
    
}

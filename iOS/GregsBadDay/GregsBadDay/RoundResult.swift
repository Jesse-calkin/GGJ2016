//
//  RoundResult.swift
//  GregsBadDay
//
//  Created by Chris Weathers on 1/30/16.
//
//

import Foundation

struct RoundResult {
    var bodyValue: Int
    var headValue: Int
    var leftArmValue: Int
    var leftLegValue: Int
    var rightArmValue: Int
    var rightLegValue: Int
    
    var currentRound: Int
    var nextRound: Int?
    
    init () {
        bodyValue = 0
        headValue = 0
        leftArmValue = 0
        leftLegValue = 0
        rightArmValue = 0
        rightLegValue = 0
        
        currentRound = 0
        nextRound = nil
    }

    func grandTotal() -> Int {
        return bodyValue + headValue + leftArmValue + leftLegValue + rightArmValue + rightLegValue
    }

    func evilWins() -> Bool {
        return grandTotal() > 0
    }
}

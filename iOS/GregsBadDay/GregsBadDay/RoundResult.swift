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
    var legsValue: Int
    var rightArmValue: Int
    
    var currentRound: Int
    var nextRound: Int?
    
    init () {
        bodyValue = 0
        headValue = 0
        leftArmValue = 0
        legsValue = 0
        rightArmValue = 0
        
        currentRound = 0
        nextRound = nil
    }
}

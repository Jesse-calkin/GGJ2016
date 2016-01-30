//
//  PlayerAction.swift
//  GregsBadDay
//
//  Created by Chris Weathers on 1/30/16.
//
//

import Foundation

struct PlayerAction {
    enum Target: String {
        case Arms = "arms"
        case Body = "body"
        case Head = "head"
        case Legs = "legs"
    }
    
    var target: Target
    var value: Int
}

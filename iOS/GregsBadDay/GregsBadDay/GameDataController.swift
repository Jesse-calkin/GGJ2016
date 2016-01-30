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
    
    func update() {
        
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
}

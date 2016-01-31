//
//  AppDelegate.swift
//  GregsBadDay
//
//  Created by Nick Dobos on 1/29/16.
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var gameDataController: GameDataController
    
    override init() {
        gameDataController = GameDataController()
        
        super.init()
    }

}


//
//  GregsDayViewController.swift
//  GregsBadDay
//
//  Created by Nick Dobos on 1/30/16.
//
//

import UIKit
import SpriteKit

class GregsDayViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GregsDayScene(fileNamed:"GregsDayScene") {
            // Configure the view.
            let skView = self.view as! SKView
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }
}

//
//  GameViewController.swift
//  particleTest
//
//  Created by jesse calkin on 1/30/16.
//  Copyright (c) 2016 jesse calkin. All rights reserved.
//

import UIKit
import SpriteKit

class CardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = CardScene(fileNamed:"CardScene") {
            scene.cardDelegate = self
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        sharedGameSoundController().playSoundWithName("Latin Speak (ECHO)")
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

extension CardViewController: CardSceneDelegate {
    func didComplete() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

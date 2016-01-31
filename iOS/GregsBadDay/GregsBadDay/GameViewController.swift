//
//  GameViewController.swift
//  GregsBadDay
//
//  Created by Nick Dobos on 1/29/16.
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    var pins = [SCNNode]()
    var currentPinNumber = 0
    var initialPinPositions = [SCNVector3]()
    var initialPinRotations  = [SCNVector4]()
    
    var roundTimer = NSTimer()
    var playerAction = PlayerAction()
    let roundLength:NSTimeInterval = 20
    
    var isRoundActive = false
    var canPoke = false;
    var shouldStartNewRound = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setupRoundWithLength(roundLength)
    }
    
    func setupScene() {
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/VoodooDollScene.dae")!
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        // set the scene to the view
        scnView.scene = scene
        
        // configure the view
        scnView.backgroundColor = UIColor.blackColor()
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        scnView.addGestureRecognizer(tapGesture)
        
        for node in scene.rootNode.childNodes {
            if let name = node.name where name.hasPrefix("Pin") {
                pins.append(node)
                initialPinPositions.append(node.position)
                initialPinRotations.append(node.rotation)
            }
        }
    }
    
    func setupRoundWithLength(length: NSTimeInterval) {
        if (!isRoundActive && shouldStartNewRound) {
            isRoundActive = true
            currentPinNumber = 0
            
            roundTimer = NSTimer.scheduledTimerWithTimeInterval(length, target: self, selector: "roundOver", userInfo: nil, repeats: false)
            
            showCard()
        }
        else {
            canPoke = true
        }
    }
    
    func showCard() {
        if isRoundActive && currentPinNumber < 5 {
            self.performSegueWithIdentifier("PresentCardSegue", sender: self)
        }
    }
    
    func roundOver() {
        canPoke = false
        isRoundActive = false
        shouldStartNewRound = false
        
        if (self.presentedViewController != nil) {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        sharedGameDataController().postRequestForPlayerAction(playerAction, completionHandler: { (roundResult) -> Void in
            self.shouldStartNewRound = true
            self.playerAction = PlayerAction()
            self.animatePinsBack()
        })
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.locationInView(scnView)
        let hitResults = scnView.hitTest(p, options: nil)
        // check that we clicked on at least one object
        if hitResults.count > 0 && canPoke && currentPinNumber < 5 {
            // retrieved the first clicked object
            let result: AnyObject! = hitResults[0]
            
            if (result.node.name != "Pin") {
                canPoke = false
                
                for result in hitResults {
                    if result.node.name == "voodoo_torso" {
                        playerAction.bodyValue++
                    }
                    else if result.node.name == "voodoo_head" {
                        playerAction.headValue++
                    }
                    else if result.node.name == "voodoo_Rleg" {
                        playerAction.rightLegValue++
                    }
                    else if result.node.name == "voodoo_leftLeg" {
                        playerAction.leftLegValue++
                    }
                    else if result.node.name == "voodoo_leftarm" {
                        playerAction.leftArmValue++
                    }
                    else if result.node.name == "voodoo_rightarm" {
                        playerAction.rightArmValue++
                    }
                }
                
                let pin = pins[currentPinNumber]
                
                currentPinNumber++
                animatePinToCoordinates(pin, coordinates: result.worldCoordinates)
            }
        }
    }
    
    func animatePinToCoordinates(pin: SCNNode, coordinates: SCNVector3) {
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(1)
        SCNTransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        
        let x = Float(arc4random_uniform(40)) - 20
        let y = Float(arc4random_uniform(400)) + 1500
        let z = Float(arc4random_uniform(40)) - 20
        
        pin.position = SCNVector3(x: x, y: y, z: z)
        
        let originalRotation = pin.rotation
        
        let x2 = Float(arc4random_uniform(10)) - 5
        let y2 = Float(arc4random_uniform(10)) - 5
        let z2 = Float(arc4random_uniform(10)) - 5
        
        pin.rotation = SCNVector4(x2, y2, z2, pin.rotation.w)
        
        SCNTransaction.setCompletionBlock {
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(0.75)
            SCNTransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
            
            let x3 = Float(arc4random_uniform(1)) - originalRotation.x/2
            let y3 = Float(arc4random_uniform(1)) - originalRotation.y/2
            let z3 = Float(arc4random_uniform(1)) - originalRotation.z/2
            
            pin.rotation = SCNVector4(x3, y3, z3, pin.rotation.w)
            
            SCNTransaction.setCompletionBlock {
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.2)
                SCNTransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
                
                pin.position = coordinates
                
                SCNTransaction.setCompletionBlock({ () -> Void in
                    self.showCard()
                })
                
                SCNTransaction.commit()
            }
            
            SCNTransaction.commit()
        }
        
        SCNTransaction.commit()
    }
    
    func animatePinsBack() {
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(2)
        SCNTransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
        
        for pin in pins {
            let y = Float(arc4random_uniform(400)) + 200
            
            pin.position = SCNVector3(x: pin.position.x, y: y, z: pin.position.z)
        }
        
        SCNTransaction.setCompletionBlock {
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(1)
            SCNTransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
            
            for var i = 0; i < self.pins.count; i++ {
                let pin = self.pins[i];
                let originalPinPosition = self.initialPinPositions[i];
                let originalPinRotation = self.initialPinRotations[i];
                
                 pin.position =  SCNVector3(x: originalPinPosition.x, y: pin.position.y, z: originalPinPosition.z)
                pin.rotation = originalPinRotation
            }
            
            SCNTransaction.setCompletionBlock {
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(1)
                SCNTransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
                
                SCNTransaction.setCompletionBlock({ () -> Void in
                    self.setupRoundWithLength(self.roundLength)
                })
                
                for var i = 0; i < self.pins.count; i++ {
                    let pin = self.pins[i];
                    let originalPinPosition = self.initialPinPositions[i];
                    
                    pin.position =  originalPinPosition
                }
                
                SCNTransaction.commit()
            }
                
            SCNTransaction.commit()
        }
        
        SCNTransaction.commit()
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}

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

    var pinNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/VoodooTemplate.dae")!
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
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
            if node.name == "Pin" {
                pinNode = node
                
                break
            }
        }
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.locationInView(scnView)
        let hitResults = scnView.hitTest(p, options: nil)
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject! = hitResults[0]
            
            if (result.node.name != "Pin") {
                // Stabbing animation
                let pin = pinNode.copy() as! SCNNode
                scnView.scene?.rootNode.addChildNode(pin)
                
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(1.5)
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
                    SCNTransaction.setAnimationDuration(1)
                    SCNTransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
            
                    let x3 = Float(arc4random_uniform(1)) - originalRotation.x/2
                    let y3 = Float(arc4random_uniform(1)) - originalRotation.y/2
                    let z3 = Float(arc4random_uniform(1)) - originalRotation.z/2
                    
                    pin.rotation = SCNVector4(x3, y3, z3, pin.rotation.w)
                    
                    SCNTransaction.setCompletionBlock {
                        SCNTransaction.begin()
                        SCNTransaction.setAnimationDuration(0.2)
                        SCNTransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
                    
                        pin.position = result.worldCoordinates
                        
                        SCNTransaction.commit()
                    }
                    
                    SCNTransaction.commit()
                }
                
                SCNTransaction.commit()
            }
        }
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

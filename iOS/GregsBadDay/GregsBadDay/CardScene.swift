//
//  GameScene.swift
//  particleTest
//
//  Created by jesse calkin on 1/30/16.
//  Copyright (c) 2016 jesse calkin. All rights reserved.
//

import SpriteKit
import ObjectiveC

class CardScene: SKScene {

    var debugHitboxes = false
    var debugEmitters = true
    var complete = false {
        didSet {
            print("🍻 COMPLETE!")
            self.backgroundColor = UIColor.greenColor()
        }
    }

    var trail: SKEmitterNode?
    var card: SKSpriteNode?
    var hitboxes = [SKNode]()

    override func didMoveToView(view: SKView) {

        trail = childNodeWithName("Trail") as? SKEmitterNode

        self.enumerateChildNodesWithName("hitbox") { node, stop in
            if let node = node as? SKShapeNode {
                if !self.debugHitboxes {
                    node.fillColor = UIColor.clearColor()
                    node.strokeColor = UIColor.clearColor()
                }
            }
            self.hitboxes.append(node)
        }
        if debugHitboxes { print("\(hitboxes.count) hitboxes found") }
    }

    deinit {
        trail?.targetNode = nil
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        for touch in touches {
            let point = touch.locationInNode(self)

            checkForHit(point)
            updateTrail(point)
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard !complete else { return }

        for touch in touches {
            let point = touch.locationInNode(self)
            checkForHit(point)
            updateTrail(point)
        }

        checkProgress()
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        trail?.targetNode = self
    }

    func updateTrail(point: CGPoint) {//TODO: call these methods from the SCNscene VC
        guard containsPoint(point) else { return }
        
        if let trail = trail {
            trail.position = point
            if debugEmitters { print("Trail position updated: \(point)") }
        }
    }

    func checkForHit(point: CGPoint) {
        guard !complete && containsPoint(point) else { return }

        let node = nodeAtPoint(point)
        guard node.name == "hitbox" else { return }
        node.hitScored = true

        if debugHitboxes { print("✅ HIT ON NODE: \(self)") }
    }

    func checkProgress() {
        let completedHits = hitboxes.filter { $0.hitScored == true }

        if debugHitboxes { print("Progress: \(completedHits.count) hits out of \(hitboxes.count)") }

        if completedHits.count == hitboxes.count {
            complete = true
        }
    }
}

private var hitScoredAssociationKey: UInt8 = 0

extension SKNode {
    var hitScored: Bool! {
        get {
            return objc_getAssociatedObject(self, &hitScoredAssociationKey) as? Bool
        }
        set(newValue) {
            objc_setAssociatedObject(self, &hitScoredAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

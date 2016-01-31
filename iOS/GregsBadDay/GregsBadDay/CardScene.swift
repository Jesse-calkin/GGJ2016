//
//  GameScene.swift
//  particleTest
//
//  Created by jesse calkin on 1/30/16.
//  Copyright (c) 2016 jesse calkin. All rights reserved.
//

import SpriteKit
import ObjectiveC

protocol CardSceneDelegate {
    func didComplete()
}

class CardScene: SKScene {

    var cardDelegate: CardSceneDelegate?
    var debugHitboxes = false
    var complete = false {
        didSet {
            print("🍻 COMPLETE! 🎉")
            cardDelegate?.didComplete()
        }
    }

    var trail: SKEmitterNode?
    var card: SKSpriteNode?
    var hitboxes = [SKNode]()

    override func didMoveToView(view: SKView) {
        trail = SKEmitterNode(fileNamed: "Trail.sks")
        if let trail = trail {
            trail.name = "Trail"
            addChild(trail)
        }

        card = childNodeWithName("Card") as? SKSpriteNode

        self.enumerateChildNodesWithName("hitbox") { node, stop in
            if let node = node as? SKShapeNode {
                if !self.debugHitboxes {
                    node.fillColor = UIColor.clearColor()
                    node.strokeColor = UIColor.clearColor()
                }
            }
            self.hitboxes.append(node)
        }
        print("\(hitboxes.count) hitboxes found")
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
        for touch in touches {
            let point = touch.locationInNode(self)
            checkForHit(point)
            updateTrail(point)
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        trail?.removeFromParent()// This will freeze the particles
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        trail?.targetNode = self

        guard !complete else { return }

        checkProgress()
    }

    func updateTrail(point: CGPoint) {
        if let trail = trail {
            trail.position = point
        }
    }

    func checkForHit(point: CGPoint) {
        guard !complete else { return }

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

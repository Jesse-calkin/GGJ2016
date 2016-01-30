//
//  GregsDayScene.swift
//  GregsBadDay
//
//  Created by Nick Dobos on 1/30/16.
//
//

import SpriteKit

class GregsDayScene: SKScene {
    
    var walkingFrames = [SKTexture]()
    var greg = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        let walkCycle = SKTextureAtlas(named: "ShittyWalkCycle")
        
        for var i = 0; i < walkCycle.textureNames.count; i++ {
            let name = String(format: "ShittyWalkCycle_000%02d.png", i)
            let texture = walkCycle.textureNamed(name)
            walkingFrames.append(texture)
        }
        
        greg = SKSpriteNode(texture: walkingFrames[0])
        addChild(greg)
        greg.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        
        gregWalk()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
//        for touch in touches {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
//        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func gregWalk() {
        let xToMoveTo = greg.xScale > 0 ? 0 : self.frame.size.width
        
        let moveAction = SKAction.moveTo(CGPoint(x: xToMoveTo, y: self.frame.size.height/2), duration: 5)
        let doneAction = SKAction.runBlock { () -> Void in
            self.walkEnded()
        }
        
        let motionAction = SKAction.sequence([moveAction, doneAction])
        greg.runAction(motionAction, withKey: "moving")
        
        greg.runAction((SKAction.repeatActionForever(SKAction.animateWithTextures(walkingFrames, timePerFrame: 0.1, resize: false, restore: true))), withKey: "walking")
    }
    
    func walkEnded() {
        greg.removeAllActions()
        
        greg.xScale = greg.xScale * -1
        
        gregWalk()
    }
}

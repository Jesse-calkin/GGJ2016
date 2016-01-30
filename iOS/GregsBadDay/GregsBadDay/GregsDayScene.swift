//
//  GregsDayScene.swift
//  GregsBadDay
//
//  Created by Nick Dobos on 1/30/16.
//
//

import SpriteKit

enum GregWalkType {
    case Normal
    case Moonwalk
    
    case Count
    static let allValues = [Normal, Moonwalk, Count]
}

class GregsDayScene: SKScene {
    
    var greg = SKSpriteNode()

    var walkingFrames = [GregWalkType :[SKTexture]]()
    var defaultStandingFrame = SKTexture()
    
    var currentWalkType = GregWalkType.Normal
    var movingRight = true
    
    override func didMoveToView(view: SKView) {
        loadWalkCycle(.Normal)
        loadWalkCycle(.Moonwalk)
        
        // TODOAdd More walk cycles here
        
        
        defaultStandingFrame = walkingFrames[.Normal]![0]
        greg = SKSpriteNode(texture: defaultStandingFrame)
        
        addChild(greg)
        greg.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        
        gregWalkWithType(.Normal)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let indexOfNextEnum = GregWalkType.allValues.indexOf(currentWalkType)! + 1
        
        var newWalkType = GregWalkType.allValues[indexOfNextEnum]
        if newWalkType == .Count {
          newWalkType = .Normal
        }
        
        setNewWalkType(newWalkType)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func setNewWalkType(type: GregWalkType) {
        greg.removeAllActions()
        
        let wait = SKAction.waitForDuration(1)
        let flip = SKAction.scaleXTo(greg.xScale * -1, duration: 0.5)
        let flipBack = SKAction.scaleXTo(greg.xScale, duration: 0.25)
        let moveAgain = SKAction.runBlock { () -> Void in
            self.gregWalkWithType(type)
        }
        
        let sequence = SKAction.sequence([wait, flip, flipBack, moveAgain])
        
        greg.runAction(sequence, withKey: "new walk")
    }
    
    func gregWalkWithType(type : GregWalkType) {
        let xToMoveTo = movingRight ? self.frame.size.width : 0
        
        if (type == .Moonwalk) {
            greg.xScale = movingRight ? -fabs(greg.xScale) : fabs(greg.xScale);
        }
        
        let moveAction = SKAction.moveTo(CGPoint(x: xToMoveTo, y: self.frame.size.height/2), duration: 5)
        let doneAction = SKAction.runBlock { () -> Void in
            self.walkEnded(type)
        }
        
        let motionAction = SKAction.sequence([moveAction, doneAction])
        greg.runAction(motionAction, withKey: "moving")
        
        greg.runAction((SKAction.repeatActionForever(SKAction.animateWithTextures(walkingFrames[type]!, timePerFrame: 0.1, resize: false, restore: true))), withKey: "walking")
        
        currentWalkType = type
    }
    
    func walkEnded(type : GregWalkType) {
        greg.removeAllActions()
        
        movingRight = !movingRight
        
        gregWalkWithType(type)
    }
    
    func loadWalkCycle(type: GregWalkType) {
        var atlas = SKTextureAtlas()
        var imageName = ""
        
        switch (type) {
        case .Normal, .Moonwalk:
            atlas = SKTextureAtlas(named: "ShittyWalkCycle")
            imageName = "ShittyWalkCycle_000%02d.png"
            
            break
        default:
            return
        }
        
        var frames = [SKTexture]()
        
        for var i = 0; i < atlas.textureNames.count; i++ {
            let name = String(format: imageName, i)
            let texture = atlas.textureNamed(name)
            frames.append(texture)
        }
        
        walkingFrames[type] = frames
    }
}

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
    case Happy
    case Sad
    
    case Count
    
    case Zapp
    
    static let allValues = [Normal, Moonwalk, Happy, Sad, Count]
}

class GregsDayScene: SKScene {
    
    var greg = SKSpriteNode()

    var walkingFrames = [GregWalkType :[SKTexture]]()
    var defaultStandingFrame = SKTexture()
    let velocity = 80
    
    var currentWalkType = GregWalkType.Normal
    var movingRight = true
    
    override func didMoveToView(view: SKView) {
        loadWalkCycle(.Normal)
        loadWalkCycle(.Moonwalk)
        loadWalkCycle(.Happy)
        loadWalkCycle(.Sad)
        loadWalkCycle(.Zapp)
        
        defaultStandingFrame = walkingFrames[.Happy]![0]
        greg = SKSpriteNode(texture: defaultStandingFrame)
        
        addChild(greg)
        greg.setScale(0.66)
        greg.position = CGPoint(x: CGRectGetMidX(self.frame), y: 350)
        
        gregWalkWithType(.Happy)
        
        let background = SKSpriteNode(imageNamed: "kitchenbg")
        background.size = frame.size
        background.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        background.zPosition = -1
        self.addChild(background)

        startListeningForRoundResults()
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
    
        let zapp = SKAction.animateWithTextures(walkingFrames[.Zapp]!, timePerFrame: 0.1, resize: false, restore: true)
        let moveAgain = SKAction.runBlock { () -> Void in
            self.gregWalkWithType(type)
        }
        
        let sequence = SKAction.sequence([zapp, moveAgain])
        
        greg.runAction(sequence, withKey: "new walk")
        
        sharedGameSoundController().playSoundWithName("Electrical zap 4")
    }
    
    func gregWalkWithType(type : GregWalkType) {
        let xToMoveTo = movingRight ? self.frame.size.width - 10 : 10
        greg.xScale = type == .Moonwalk ? (movingRight ? -fabs(greg.xScale) : fabs(greg.xScale)) : (movingRight ? fabs(greg.xScale) : -fabs(greg.xScale));
        
        let distanceToMove = fabs(greg.position.x - xToMoveTo);
        let duration = NSTimeInterval(distanceToMove / CGFloat(velocity))
        
        let moveAction = SKAction.moveTo(CGPoint(x: xToMoveTo, y: greg.position.y), duration: duration)
        let doneAction = SKAction.runBlock { () -> Void in
            self.walkEnded(type)
        }
        
        sharedGameSoundController().playSoundWithName("Footsteps 1")
        
        let motionAction = SKAction.sequence([moveAction, doneAction])
        greg.runAction(motionAction, withKey: "moving")
        
        greg.runAction((SKAction.repeatActionForever(SKAction.animateWithTextures(walkingFrames[type]!, timePerFrame: 0.05, resize: false, restore: true))), withKey: "walking")
        
        currentWalkType = type
    }
    
    func walkEnded(type : GregWalkType) {
        greg.removeAllActions()

        let flip = SKAction.scaleXTo(greg.xScale * -1, duration: 0.5)
        let doneAction = SKAction.runBlock { () -> Void in
            self.greg.removeAllActions()
            
            self.movingRight = !self.movingRight
            self.gregWalkWithType(type)
        }
        
        let sequence = SKAction.sequence([flip, doneAction])
        greg.runAction(sequence, withKey: "flip")
    }
    
    func loadWalkCycle(type: GregWalkType) {
        var atlas = SKTextureAtlas()
        var imageName = ""
        
        switch (type) {
        case .Normal, .Moonwalk:
            atlas = SKTextureAtlas(named: "Rich_Regular")
            imageName = "RichRegular_000%02d.png"
            
            break
        case .Happy:
            atlas = SKTextureAtlas(named: "Rich_HappyWalk")
            imageName = "Rich_HappyWalk_000%02d.png"
            
            break
        case .Sad:
            atlas = SKTextureAtlas(named: "Rich_SadWalkCycle")
            imageName = "Rich_SadWalkCycle_000%02d.png"
            
            break
        case .Zapp:
            atlas = SKTextureAtlas(named: "Zapp")
            imageName = "Zapp_000%02d.png"
            
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
    
    //  Round results
    
    var isListeningForRoundResults:Bool = false
    
    func startListeningForRoundResults() {
        if !isListeningForRoundResults {
            isListeningForRoundResults = true
            
            listenForNextRoundResult()
        }
    }
    
    func stopListeningForRoundResults() {
        if isListeningForRoundResults {
            isListeningForRoundResults = false
            
            stopListeningForNextRoundResult()
        }
    }
    
    var isListeningForNextRoundResult:Bool = false
    
    func listenForNextRoundResult() {
        if !isListeningForNextRoundResult {
            isListeningForNextRoundResult = true
            
            sharedGameDataController().postRequestForPlayerAction(PlayerAction(), completionHandler: { (roundResult) -> Void in
                if self.isListeningForNextRoundResult {
                    if let roundResult = roundResult {
                        self.roundResultReceived(roundResult)
                    }
                }
                
                self.isListeningForNextRoundResult = false
                
                if self.isListeningForRoundResults {
                    self.listenForNextRoundResult()
                }
            })
        }
    }
    
    func stopListeningForNextRoundResult() {
        if isListeningForNextRoundResult {
            isListeningForNextRoundResult = false
        }
    }
    
    func roundResultReceived(roundResult:RoundResult) {
        if roundResult.evilWins() {
            print("👹 Evil WINS! 👹")
            setNewWalkType(.Sad)
            
            sharedGameSoundController().playSoundWithName("Rich Reaction (Walk it off)")
        } else {
            print("👼 Good WINS! 👼")
            setNewWalkType(.Happy)
            
            sharedGameSoundController().playSoundWithName("Rich Reaction (Hurumph)")
        }
    }
}

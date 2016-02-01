//
//  GameSoundController.swift
//  GregsBadDay
//
//  Created by Nick Dobos on 1/31/16.
//
//

import Foundation
import AVFoundation
import UIKit

func sharedGameSoundController()-> GameSoundController {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let soundController = appDelegate.gameSoundController
    return soundController
}

class GameSoundController  {
    var player = AVAudioPlayer()
    
    func playSoundWithName(name : String) {
        let pathForResource = NSBundle.mainBundle().pathForResource(name, ofType: "mp3")!
        let sound = NSURL(fileURLWithPath: pathForResource)
        
        do {
            player = try AVAudioPlayer(contentsOfURL: sound)
        } catch {
            abort()
        }
        
        player.prepareToPlay()
        player.play()
    }
}
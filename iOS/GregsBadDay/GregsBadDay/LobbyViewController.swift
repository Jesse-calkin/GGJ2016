//
//  LobbyViewController.swift
//  GregsBadDay
//
//  Created by Chris Weathers on 1/29/16.
//
//

import UIKit

class LobbyViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton?
    @IBOutlet weak var affinitySwitch: UISwitch?

    func affinity()-> Affinity {
        let affinity:Affinity = (affinitySwitch!.on ? .Good : .Bad)
        return affinity
    }
    
    override func viewWillDisappear(animated: Bool) {
        sharedGameDataController().affinity = affinity()
    }
    
}

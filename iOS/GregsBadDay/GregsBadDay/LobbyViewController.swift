//
//  LobbyViewController.swift
//  GregsBadDay
//
//  Created by Chris Weathers on 1/29/16.
//
//

import UIKit

class LobbyViewController: UIViewController {

    var affinity: Affinity? {
        didSet {
            guard let affinity = affinity else { return }
            sharedGameDataController().affinity = affinity
            print("Affinity: \(affinity)")
        }
    }

    @IBAction func chooseYourDestiny(sender: UIButton) {
        affinity = sender.tag == 0 ? .Bad : .Good
    }
}

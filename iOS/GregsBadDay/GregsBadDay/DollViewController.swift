//
//  DollViewController.swift
//  GregsBadDay
//
//  Created by Chris Weathers on 1/30/16.
//
//

import UIKit

class DollViewController: UIViewController {
    
    @IBOutlet var armsButton: UIButton?
    @IBOutlet var bodyButton: UIButton?
    @IBOutlet var headButton: UIButton?
    @IBOutlet var legsButton: UIButton?
    
    @IBOutlet var damageSlider: UISlider?
    
    @IBOutlet var sideSwitch: UISwitch?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func armsButtonTapped() {
        performActionOnTarget(PlayerAction.Target.Arms)
    }
    
    @IBAction func bodyButtonTapped() {
        performActionOnTarget(PlayerAction.Target.Body)
    }
    
    @IBAction func headButtonTapped() {
        performActionOnTarget(PlayerAction.Target.Head)
    }
    
    @IBAction func legsButtonTapped() {
        performActionOnTarget(PlayerAction.Target.Legs)
    }
    
    func performActionOnTarget(target:PlayerAction.Target) {
        
    }

}

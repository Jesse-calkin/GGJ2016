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
    
    @IBOutlet weak var nameTextField: UITextField?
    @IBOutlet weak var roomTextField: UITextField?
    @IBOutlet weak var teamTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startButtonTapped(startButton: UIButton) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ViewController.swift
//  ios-tip
//
//  Created by Andre Oriani on 1/12/16.
//  Copyright © 2016 Andre Oriani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipSegControl: UISegmentedControl!
    var tipController: TipController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tipController = TipController(amountEditor: amountField, tipLabel: tipLabel, totalLabel: totalLabel, tipSegControl: tipSegControl)
        tipController?.restoreState()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "saveState",
            name: UIApplicationWillResignActiveNotification,
            object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tipController?.restoreState()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        amountField.becomeFirstResponder()
    }
    
    func saveState() {
        tipController?.saveState()
    }

    @IBAction func onChange(sender: AnyObject) {
        tipController?.updateUI()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIApplicationWillResignActiveNotification,
            object: nil)
    }

}


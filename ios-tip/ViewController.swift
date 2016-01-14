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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tipController?.prepare()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onChange(sender: AnyObject) {
        tipController?.update()
    }

}


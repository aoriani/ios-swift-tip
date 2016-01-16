//
//  ViewController.swift
//  ios-tip
//
//  Created by Andre Oriani on 1/12/16.
//  Copyright © 2016 Andre Oriani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var container: UIView!
    @IBOutlet weak var resultContainer: UIView!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipSegControl: UISegmentedControl!
    var tipController: TipController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tipController = TipController(amountEditor: amountField,
            tipLabel: tipLabel,
            totalLabel: totalLabel,
            tipSegControl: tipSegControl)
        tipController?.restoreState()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "saveState",
            name: UIApplicationWillResignActiveNotification,
            object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self,
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

    @IBAction func onValueChange(sender: AnyObject) {
        tipController?.updateUI()
    }
    
    @IBAction func onGratuityChange(sender: AnyObject) {
        startAnimateGratuityChange()
    }
    
    func startAnimateGratuityChange() {
        resultContainer.alpha = 1
        UIView.animateWithDuration(0.25,
            delay: 0.0,
            options: .CurveEaseIn,
            animations: {
                self.resultContainer.alpha = 0
                self.resultContainer.center.x -= self.container.bounds.width
            },
            completion: {
                finished in self.tipController?.updateUI()
                self.finishAnimateGratuityChange()
            })
    }
    
    func finishAnimateGratuityChange() {
        self.resultContainer.center.x += 2 * self.container.bounds.width
        UIView.animateWithDuration(0.25,
            delay: 0.0,
            options: .CurveEaseOut,
            animations: {
                self.resultContainer.center.x -= self.container.bounds.width
                self.resultContainer.alpha = 1
            },
            completion: {
                finished in
            })
    }

}


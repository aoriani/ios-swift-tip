//
//  SettingsViewController.swift
//  ios-tip
//
//  Created by Andre Oriani on 1/14/16.
//  Copyright © 2016 Andre Oriani. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var defaultTipSegControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        TipController.setupTipSegControl(defaultTipSegControl)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        defaultTipSegControl.selectedSegmentIndex = TipController.restoreDefaulGratuity()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        TipController.saveDefaultGratuity(defaultTipSegControl.selectedSegmentIndex)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

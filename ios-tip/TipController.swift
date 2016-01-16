//
//  TipController.swift
//  ios-tip
//
//  Created by Andre Oriani on 1/13/16.
//  Copyright © 2016 Andre Oriani. All rights reserved.
//

import Foundation
import UIKit

/**
 * Controls all the logic of the application including: 
 *  - saving and restore state between restarts;
 *  - controlling settings;
 *  - doing the tip calculation.
 */
class TipController {
    
    struct Gratuity {
        var value: NSDecimalNumber
        var representation: String
    }
    
    static let gratuities = [Gratuity(value: NSDecimalNumber(string: "0.15"), representation: "15%"),
        Gratuity(value: NSDecimalNumber(string: "0.18"), representation: "18%"),
        Gratuity(value: NSDecimalNumber(string: "0.20"), representation: "20%")]
    
    //Keys for saving state
    static let gratuityUserDefaultsKey = "default_gratuity"
    static let ammountUserDefaultsKey = "default_amount"
    static let timestampUserDefaultsKey = "default_tmstp"
    static let tenMinutes = 10 * 60
    
    let decimalRoundUp = NSDecimalNumberHandler(roundingMode: NSRoundingMode.RoundUp,
        scale: 2,
        raiseOnExactness: false,
        raiseOnOverflow: false,
        raiseOnUnderflow: false,
        raiseOnDivideByZero: false)
    
    let currencyFormatter = NSNumberFormatter()
    
    //UI Components
    var tipLabel: UILabel
    var totalLabel: UILabel
    var amountEditor: UITextField
    var tipSegControl: UISegmentedControl
    
    init(amountEditor:UITextField, tipLabel: UILabel, totalLabel: UILabel, tipSegControl: UISegmentedControl) {
        self.amountEditor = amountEditor
        self.tipLabel = tipLabel
        self.totalLabel = totalLabel
        self.tipSegControl = tipSegControl
        
        currencyFormatter.numberStyle = .CurrencyStyle
    }
    
    static func setupTipSegControl(tipSegControl: UISegmentedControl) {
        tipSegControl.removeAllSegments()
        for i in 0..<TipController.gratuities.count {
            tipSegControl.insertSegmentWithTitle(TipController.gratuities[i].representation, atIndex: i, animated: false)
        }
    }
    
    static func saveDefaultGratuity(index: Int) {
        if index >= 0 && index < TipController.gratuities.count {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(index, forKey: TipController.gratuityUserDefaultsKey)
            defaults.synchronize()
        }
    }
    
    static func restoreDefaulGratuity() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(TipController.gratuityUserDefaultsKey)
    }
    
    func saveState() {
        let now = Int(NSDate().timeIntervalSince1970)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(now, forKey: TipController.timestampUserDefaultsKey)
        defaults.setObject(amountEditor.text, forKey: TipController.ammountUserDefaultsKey)
        defaults.synchronize()
    }
    
    func restoreState() {
        amountEditor.text = ""
        
        let now = Int(NSDate().timeIntervalSince1970)
        let defaults = NSUserDefaults.standardUserDefaults()
        let lastSaveTimestamp = defaults.integerForKey(TipController.timestampUserDefaultsKey)
        if (now - lastSaveTimestamp) < TipController.tenMinutes {
            if let ammount = defaults.stringForKey(TipController.ammountUserDefaultsKey){
                amountEditor.text = ammount
            }
        }
        TipController.setupTipSegControl(tipSegControl)
        tipSegControl.selectedSegmentIndex = TipController.restoreDefaulGratuity()
        updateUI()
    }
    
    func formatCurrency(num:NSDecimalNumber) -> String {
        return currencyFormatter.stringFromNumber(num)!
    }
    
    func calculateTip(amount:NSDecimalNumber, gratuity:NSDecimalNumber) -> (tip: NSDecimalNumber, total: NSDecimalNumber) {
        let tip = amount.decimalNumberByMultiplyingBy(gratuity, withBehavior: decimalRoundUp)
        let total = amount.decimalNumberByAdding(tip, withBehavior: decimalRoundUp)
        
        return (tip, total)
    }
    
    func updateUI() {
        var billAmount = NSDecimalNumber(string: amountEditor.text)
        billAmount = billAmount == NSDecimalNumber.notANumber() ? NSDecimalNumber.zero() : billAmount
        
        let currentGratuity = TipController.gratuities[tipSegControl.selectedSegmentIndex].value
        let tip = calculateTip(billAmount, gratuity: currentGratuity)
        
        tipLabel.text = formatCurrency(tip.tip)
        totalLabel.text = formatCurrency(tip.total)
    }
    
}

//
//  TipController.swift
//  ios-tip
//
//  Created by Andre Oriani on 1/13/16.
//  Copyright © 2016 Andre Oriani. All rights reserved.
//

import Foundation
import UIKit

class TipController {
    
    struct Gratuity {
        var value: NSDecimalNumber
        var representation: String
    }
    
    let gratuities = [Gratuity(value: NSDecimalNumber(string: "0.15"), representation: "15%"),
        Gratuity(value: NSDecimalNumber(string: "0.18"), representation: "18%"),
        Gratuity(value: NSDecimalNumber(string: "0.20"), representation: "20%")]
    
    let decimalRoundUp = NSDecimalNumberHandler(roundingMode: NSRoundingMode.RoundUp,
        scale: 2,
        raiseOnExactness: false,
        raiseOnOverflow: false,
        raiseOnUnderflow: false,
        raiseOnDivideByZero: false)
    
    let currencyFormatter = NSNumberFormatter()
    
    var tipLabel: UILabel
    var totalLabel: UILabel
    var amountEditor: UITextField
    var tipSegControl: UISegmentedControl
    
    init(amountEditor:UITextField, tipLabel: UILabel, totalLabel: UILabel, tipSegControl: UISegmentedControl) {
        self.amountEditor = amountEditor
        self.tipLabel = tipLabel
        self.totalLabel = totalLabel
        self.tipSegControl = tipSegControl
        
        currencyFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        currencyFormatter.minimumFractionDigits = 2
        currencyFormatter.maximumFractionDigits = 2
    }
    
    func prepare() {
        amountEditor.text = ""
        tipLabel.text = formatCurrency(NSDecimalNumber.zero())
        totalLabel.text = formatCurrency(NSDecimalNumber.zero())
        tipSegControl.removeAllSegments()
        for i in 0..<gratuities.count {
            tipSegControl.insertSegmentWithTitle(gratuities[i].representation, atIndex: i, animated: false)
        }
        tipSegControl.selectedSegmentIndex = 0
    }
    
    func formatCurrency(num:NSDecimalNumber) -> String {
        return currencyFormatter.stringFromNumber(num)!
    }
    
    func calculateTip(amount:NSDecimalNumber, gratuity:NSDecimalNumber) -> (tip: NSDecimalNumber, total: NSDecimalNumber) {
        let tip = amount.decimalNumberByMultiplyingBy(gratuity, withBehavior: decimalRoundUp)
        let total = amount.decimalNumberByAdding(tip, withBehavior: decimalRoundUp)
        
        return (tip, total)
    }
    
    func update() {
        var billAmount = NSDecimalNumber(string: amountEditor.text)
        billAmount = billAmount == NSDecimalNumber.notANumber() ? NSDecimalNumber.zero() : billAmount
        
        let currentGratuity = gratuities[tipSegControl.selectedSegmentIndex].value
        let tip = calculateTip(billAmount, gratuity: currentGratuity)
        
        tipLabel.text = formatCurrency(tip.tip)
        totalLabel.text = formatCurrency(tip.total)
    }
    
}

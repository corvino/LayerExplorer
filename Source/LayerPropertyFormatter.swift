//
//  LayerPropertyFormatter.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 3/24/15.
//  Copyright (c) 2015 Nathan Corvino. All rights reserved.
//

import Cocoa

@objc protocol LayerPropertyFormatterDelegate {
    func markDirty()
}

class LayerPropertyFormatter: NSNumberFormatter {

    @IBInspectable var allowsDecimal : Bool = false
    @IBOutlet weak var delegate : LayerPropertyFormatterDelegate?

    var dirty = false

    override func isPartialStringValid(partialStringPtr: AutoreleasingUnsafeMutablePointer<NSString?>, proposedSelectedRange: NSRangePointer, originalString: String, originalSelectedRange: NSRange, errorDescription: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {

        let digits = NSMutableCharacterSet.decimalDigitCharacterSet()
        let decimal = NSCharacterSet(charactersInString: ".")
        let minus = NSCharacterSet(charactersInString: "-")

        var valid = true
        var canHaveDecimal = allowsDecimal
        var canHaveNegative = true

        if let str = partialStringPtr.memory as? String {
            for char in str.unicodeScalars {
                if canHaveNegative {
                    canHaveNegative = false
                    if minus.longCharacterIsMember(char.value) {
                        continue
                    }
                }

                if canHaveDecimal && decimal.longCharacterIsMember(char.value) {
                    canHaveDecimal = false
                } else if !digits.longCharacterIsMember(char.value) {
                    valid = false;
                    break;
                }
            }
        }

        if (valid) {
            delegate?.markDirty()
        }

        return valid
    }
}

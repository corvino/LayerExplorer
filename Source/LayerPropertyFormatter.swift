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

class LayerPropertyFormatter: NumberFormatter {

    @IBInspectable var allowsDecimal : Bool = false
    @IBInspectable var maxDigits : Int = -1
    @IBOutlet weak var delegate : LayerPropertyFormatterDelegate?

    var dirty = false

    override func isPartialStringValid(_ partialStringPtr: AutoreleasingUnsafeMutablePointer<NSString>, proposedSelectedRange proposedSelRangePtr: NSRangePointer?, originalString origString: String, originalSelectedRange origSelRange: NSRange, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {

        var valid = true

        let str = partialStringPtr.pointee as String

        if 0 < maxDigits {
            var digits = maxDigits
            if str.hasPrefix("-") {
                digits += 1
            }
            if nil != str.range(of: ".") {
                digits += 1
            }
            if digits < str.characters.count {
                valid = false
            }
        }

        if (valid) {
            let digits = CharacterSet.decimalDigits
            let decimal = CharacterSet(charactersIn: ".")
            let minus = CharacterSet(charactersIn: "-")

            var canHaveDecimal = allowsDecimal
            var canHaveNegative = true


            for char in str.unicodeScalars {
                if canHaveNegative {
                    canHaveNegative = false
                    if minus.contains(UnicodeScalar(char.value)!) {
                        continue
                    }
                }

                if canHaveDecimal && decimal.contains(UnicodeScalar(char.value)!) {
                    canHaveDecimal = false
                } else if !digits.contains(char) {
                    valid = false;
                    break;
                }
            }

            if (valid) {
                delegate?.markDirty()
            }
        }

        return valid
    }
}

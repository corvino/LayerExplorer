//
//  ActionButtonViewController.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 3/24/15.
//  Copyright (c) 2015 Nathan Corvino. All rights reserved.
//

import Cocoa

class ActionButtonViewController: NSViewController {

    @IBAction func goClicked(sender: AnyObject) {

        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut))
        CATransaction.setAnimationDuration(0.8)
        NSNotificationCenter.defaultCenter().postNotificationName("AnimateChanges", object: sender)
        CATransaction.commit()

        NSNotificationCenter.defaultCenter().postNotificationName("ChangesAnimated", object: sender)
    }
}

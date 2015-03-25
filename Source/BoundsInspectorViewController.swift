//
//  BoundsInspectorViewController.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 3/24/15.
//  Copyright (c) 2015 Nathan Corvino. All rights reserved.
//

import Cocoa

class BoundsInspectorViewController: InspectorPaneViewController {

    @IBOutlet weak var xTextField: NSTextField!
    @IBOutlet weak var yTextField: NSTextField!
    @IBOutlet weak var widthTextField: NSTextField!
    @IBOutlet weak var heightTextField: NSTextField!

    override func changesAnimated(notification: NSNotification) {
        super.animateChanges(notification)

        if let bounds = self.layerView?.layer!.bounds {
            self.xTextField.stringValue = "\(bounds.origin.x)"
            self.yTextField.stringValue = "\(bounds.origin.y)"
            self.widthTextField.stringValue = "\(bounds.size.width)"
            self.heightTextField.stringValue = "\(bounds.size.height)"
        }
    }

    override func animateChanges(notification: NSNotification) {
        super.animateChanges(notification)

        if dirty {
            if let layer = layerView?.layer {
                let frame = CGRect(origin: CGPoint(x: self.xTextField.doubleValue, y: self.yTextField.doubleValue), size: CGSize(width: self.widthTextField.doubleValue, height: self.heightTextField.doubleValue))
                layer.bounds = frame
                dirty = false
            }
        }
    }
}

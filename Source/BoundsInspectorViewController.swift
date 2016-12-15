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

    override func awakeFromNib() {
        let fields = [xTextField!, yTextField!, widthTextField!, heightTextField!]
        wireFormatters(fields: fields)
    }

    override func changesAnimated(_ notification: Notification) {
        super.animateChanges(notification)

        if let bounds = layerVisualization?.bounds {
            self.xTextField.stringValue = "\(bounds.origin.x)"
            self.yTextField.stringValue = "\(bounds.origin.y)"
            self.widthTextField.stringValue = "\(bounds.size.width)"
            self.heightTextField.stringValue = "\(bounds.size.height)"
        }
    }

    override func animateChanges(_ notification: Notification) {
        super.animateChanges(notification)

        if dirty {
            layerVisualization?.bounds = CGRect(origin: CGPoint(x: self.xTextField.doubleValue, y: self.yTextField.doubleValue), size: CGSize(width: self.widthTextField.doubleValue, height: self.heightTextField.doubleValue))
            dirty = false
        }
    }
}

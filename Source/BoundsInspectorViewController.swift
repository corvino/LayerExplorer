//
//  BoundsInspectorViewController.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 3/24/15.
//  Copyright (c) 2015 Nathan Corvino. All rights reserved.
//

import Cocoa

class BoundsInspectorViewController: NSViewController, LayerPropertyFormatterDelegate {

    var layerView : LayerView?
    var dirty : Bool = false

    @IBOutlet weak var xTextField: NSTextField!
    @IBOutlet weak var yTextField: NSTextField!
    @IBOutlet weak var widthTextField: NSTextField!
    @IBOutlet weak var heightTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "layerSelected:", name: "LayerSelected", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "animateChanges:", name: "AnimateChanges", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changesAnimated:", name: "ChangesAnimated", object: nil)
    }

    func markDirty() {
        dirty = true
    }

    func layerSelected(notification: NSNotification) {
        layerView = notification.userInfo!["Layer"] as! LayerView?

        changesAnimated(notification)
    }

    func changesAnimated(notification: NSNotification) {
        if let bounds = self.layerView?.layer!.bounds {
            self.xTextField.stringValue = "\(bounds.origin.x)"
            self.yTextField.stringValue = "\(bounds.origin.y)"
            self.widthTextField.stringValue = "\(bounds.size.width)"
            self.heightTextField.stringValue = "\(bounds.size.height)"
        }
    }

    func animateChanges(notification: NSNotification) {
        if dirty {
            if let layer = layerView?.layer {
                let frame = CGRect(origin: CGPoint(x: self.xTextField.doubleValue, y: self.yTextField.doubleValue), size: CGSize(width: self.widthTextField.doubleValue, height: self.heightTextField.doubleValue))
                layer.bounds = frame
                dirty = false
            }
        }
    }
}

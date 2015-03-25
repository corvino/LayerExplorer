//
//  FrameInspectorViewController.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 3/24/15.
//  Copyright (c) 2015 Nathan Corvino. All rights reserved.
//

import Cocoa

class FrameInspectorViewController: NSViewController, LayerPropertyFormatterDelegate  {

    var layerView : LayerView?
    var dirty : Bool = false

    @IBOutlet weak var xTextField: NSTextField!
    @IBOutlet weak var yTextField: NSTextField!
    @IBOutlet weak var widthTextField: NSTextField!
    @IBOutlet weak var heightTextField: NSTextField!

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

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
        if let frame = layerView?.layer!.frame {
            self.xTextField.stringValue = "\(frame.origin.x)"
            self.yTextField.stringValue = "\(frame.origin.y)"
            self.widthTextField.stringValue = "\(frame.size.width)"
            self.heightTextField.stringValue = "\(frame.size.height)"
        }
    }

    func animateChanges(notification: NSNotification) {
        if dirty {
            if let layer = layerView?.layer {
                let frame = CGRect(origin: CGPoint(x: self.xTextField.doubleValue, y: self.yTextField.doubleValue), size: CGSize(width: self.widthTextField.doubleValue, height: self.heightTextField.doubleValue))
                layer.frame = frame
                dirty = false
            }
        }
    }
}

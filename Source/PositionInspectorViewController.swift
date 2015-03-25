//
//  PositionInspectorViewController.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 3/25/15.
//  Copyright (c) 2015 Nathan Corvino. All rights reserved.
//

import Cocoa

class PositionInspectorViewController: NSViewController, LayerPropertyFormatterDelegate {

    var layerView : LayerView?
    var dirty : Bool = false

    @IBOutlet weak var positionXTextField: NSTextField!
    @IBOutlet weak var positionYTextField: NSTextField!
    @IBOutlet weak var anchorPointXTextField: NSTextField!
    @IBOutlet weak var anchorPointYTextField: NSTextField!

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
        if let layer = layerView?.layer! {
            self.positionXTextField.stringValue = "\(layer.position.x)"
            self.positionYTextField.stringValue = "\(layer.position.y)"
            self.anchorPointXTextField.stringValue = "\(layer.anchorPoint.x)"
            self.anchorPointYTextField.stringValue = "\(layer.anchorPoint.y)"
        }
    }

    func animateChanges(notification: NSNotification) {
        if dirty {
            if let layer = layerView?.layer {
                let position = CGPoint(x: positionXTextField.doubleValue, y: positionYTextField.doubleValue)
                let anchorPoint = CGPoint(x: anchorPointXTextField.doubleValue, y: anchorPointYTextField.doubleValue)

                layer.position = position
                layer.anchorPoint = anchorPoint

                dirty = false
            }
        }
    }
}

//
//  PositionInspectorViewController.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 3/25/15.
//  Copyright (c) 2015 Nathan Corvino. All rights reserved.
//

import Cocoa

class PositionInspectorViewController: InspectorPaneViewController {

    @IBOutlet weak var positionXTextField: NSTextField!
    @IBOutlet weak var positionYTextField: NSTextField!
    @IBOutlet weak var anchorPointXTextField: NSTextField!
    @IBOutlet weak var anchorPointYTextField: NSTextField!

    override func changesAnimated(notification: NSNotification) {
        super.animateChanges(notification)

        if let layer = layerView?.layer! {
            self.positionXTextField.stringValue = "\(layer.position.x)"
            self.positionYTextField.stringValue = "\(layer.position.y)"
            self.anchorPointXTextField.stringValue = "\(layer.anchorPoint.x)"
            self.anchorPointYTextField.stringValue = "\(layer.anchorPoint.y)"
        }
    }

    override func animateChanges(notification: NSNotification) {
        super.animateChanges(notification)

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

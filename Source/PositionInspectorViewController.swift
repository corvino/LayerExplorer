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

        if let position = layerView?.position, let anchorPoint = layerView?.anchorPoint {
            self.positionXTextField.stringValue = "\(position.x)"
            self.positionYTextField.stringValue = "\(position.y)"
            self.anchorPointXTextField.stringValue = "\(anchorPoint.x)"
            self.anchorPointYTextField.stringValue = "\(anchorPoint.y)"
        }
    }

    override func animateChanges(notification: NSNotification) {
        super.animateChanges(notification)

        if dirty {
            if nil != layerView {
                layerView?.position = CGPoint(x: positionXTextField.doubleValue, y: positionYTextField.doubleValue)
                layerView?.anchorPoint = CGPoint(x: anchorPointXTextField.doubleValue, y: anchorPointYTextField.doubleValue)

                dirty = false
            }
        }
    }
}

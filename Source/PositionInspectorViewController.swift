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
    @IBOutlet weak var anchorPointZTextField: NSTextField!

    override func awakeFromNib() {
        let fields = [positionXTextField!, positionYTextField!, anchorPointXTextField!, anchorPointYTextField!, anchorPointZTextField!]
        wireFormatters(fields: fields)
    }

    override func changesAnimated(_ notification: Notification) {
        super.animateChanges(notification)

        if let position = layerVisualization?.position, let anchorPoint = layerVisualization?.anchorPoint, let anchorPointZ = layerVisualization?.anchorPointZ {
            self.positionXTextField.stringValue = "\(position.x)"
            self.positionYTextField.stringValue = "\(position.y)"
            self.anchorPointXTextField.stringValue = "\(anchorPoint.x)"
            self.anchorPointYTextField.stringValue = "\(anchorPoint.y)"
            self.anchorPointZTextField.stringValue = "\(anchorPointZ)"
        }
    }

    override func animateChanges(_ notification: Notification) {
        super.animateChanges(notification)

        if dirty && nil != layerVisualization {
            layerVisualization!.position = CGPoint(x: positionXTextField.doubleValue, y: positionYTextField.doubleValue)
            layerVisualization!.anchorPoint = CGPoint(x: anchorPointXTextField.doubleValue, y: anchorPointYTextField.doubleValue)
            layerVisualization!.anchorPointZ = CGFloat(anchorPointZTextField.doubleValue)

            dirty = false
        }
    }
}

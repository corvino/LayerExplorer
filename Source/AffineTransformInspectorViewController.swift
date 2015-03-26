//
//  AffineTransformInspectorViewController.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 3/25/15.
//  Copyright (c) 2015 Nathan Corvino. All rights reserved.
//

import Cocoa

class AffineTransformInspectorViewController: InspectorPaneViewController {

    var transform = CGAffineTransformIdentity

    @IBOutlet weak var aTextField: NSTextField!
    @IBOutlet weak var bTextField: NSTextField!
    @IBOutlet weak var cTextField: NSTextField!
    @IBOutlet weak var dTextField: NSTextField!
    @IBOutlet weak var txTextField: NSTextField!
    @IBOutlet weak var tyTextField: NSTextField!

    @IBOutlet weak var rotationTextField: NSTextField!
    @IBOutlet weak var rotateNewCheckBox: NSButton!

    @IBOutlet weak var sxTextField: NSTextField!
    @IBOutlet weak var syTextField: NSTextField!
    @IBOutlet weak var scaleNewCheckbox: NSButton!

    @IBOutlet weak var translateTxTextField: NSTextField!
    @IBOutlet weak var translateTyTextField: NSTextField!
    @IBOutlet weak var translateNewCheckbox: NSButton!

    @IBOutlet weak var concatATextField: NSTextField!
    @IBOutlet weak var concatBTextField: NSTextField!
    @IBOutlet weak var concatCTextField: NSTextField!
    @IBOutlet weak var concatDTextField: NSTextField!
    @IBOutlet weak var concatTxTextField: NSTextField!
    @IBOutlet weak var concatTyTextField: NSTextField!

    override func changesAnimated(notification: NSNotification) {
        super.animateChanges(notification)

        if let layer = layerView?.layer! {
            transform = layer.affineTransform()

            readFieldsFromTranform()
        }
    }

    override func animateChanges(notification: NSNotification) {
        super.animateChanges(notification)

        if dirty {
            if let layer = layerView?.layer {
                readTransformFromFields()
                layer.setAffineTransform(transform)
                dirty = false
            }
        }
    }

    func readTransformFromFields() {
        transform.a = CGFloat(aTextField.doubleValue)
        transform.b = CGFloat(bTextField.doubleValue)
        transform.c = CGFloat(cTextField.doubleValue)
        transform.d = CGFloat(dTextField.doubleValue)
        transform.tx = CGFloat(txTextField.doubleValue)
        transform.ty = CGFloat(tyTextField.doubleValue)
    }

    func readFieldsFromTranform() {
        aTextField.doubleValue = Double(transform.a)
        bTextField.doubleValue = Double(transform.b)
        cTextField.doubleValue = Double(transform.c)
        dTextField.doubleValue = Double(transform.d)
        txTextField.doubleValue = Double(transform.tx)
        tyTextField.doubleValue = Double(transform.ty)
    }

    @IBAction func rotateClicked(sender: AnyObject) {
        let rotation = CGFloat(degreesToRadians(rotationTextField.doubleValue))

        if NSOnState == rotateNewCheckBox.state {
            transform = CGAffineTransformMakeRotation(rotation)
        } else {
            transform = CGAffineTransformRotate(transform, rotation)
        }

        readFieldsFromTranform()
        dirty = true
    }

    @IBAction func scaleClicked(sender: AnyObject) {
        let sx = CGFloat(sxTextField.doubleValue)
        let sy = CGFloat(syTextField.doubleValue)

        if NSOnState == scaleNewCheckbox.state {
            transform = CGAffineTransformMakeScale(sx, sy)
        } else {
            transform = CGAffineTransformScale(transform, sx, sy)
        }

        readFieldsFromTranform()
        dirty = true
    }

    @IBAction func translateClicked(sender: AnyObject) {
        let tx = CGFloat(translateTxTextField.doubleValue)
        let ty = CGFloat(translateTyTextField.doubleValue)

        if NSOnState == translateNewCheckbox.state {
            transform = CGAffineTransformMakeTranslation(tx, ty)
        } else {
            transform = CGAffineTransformTranslate(transform, tx, ty)
        }

        readFieldsFromTranform()
        dirty = true
    }


    @IBAction func concatClicked(sender: AnyObject) {
        let concatTransform = CGAffineTransform(a: CGFloat(concatATextField.doubleValue), b: CGFloat(concatBTextField.doubleValue), c: CGFloat(concatCTextField.doubleValue), d: CGFloat(concatDTextField.doubleValue), tx: CGFloat(concatTxTextField.doubleValue), ty: CGFloat(concatTyTextField.doubleValue))
        transform = CGAffineTransformConcat(transform, concatTransform)

        readFieldsFromTranform()
        dirty = true
    }
}

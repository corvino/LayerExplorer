//
//  AffineTransformInspectorViewController.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 3/25/15.
//  Copyright (c) 2015 Nathan Corvino. All rights reserved.
//

import Cocoa

class AffineTransformInspectorViewController: InspectorPaneViewController {

    var transform = CGAffineTransform.identity

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

    override func awakeFromNib() {
        let fields = [aTextField!, bTextField!, cTextField!, dTextField!, txTextField!, tyTextField!,
                      rotationTextField!, sxTextField!, syTextField!, translateTxTextField!, translateTyTextField!,
                      concatATextField!, concatBTextField!, concatCTextField!, concatDTextField!,
                      concatTxTextField!, concatTyTextField!]
        wireFormatters(fields: fields)
    }

    override func changesAnimated(_ notification: Notification) {
        super.animateChanges(notification)

        if let newTransform = layerVisualization?.affineTransform {
            transform = newTransform
            readFieldsFromTranform()
        }
    }

    override func animateChanges(_ notification: Notification) {
        super.animateChanges(notification)

        if dirty {
            if nil != layerVisualization {
                readTransformFromFields()
                layerVisualization!.affineTransform = transform
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

    @IBAction func rotateClicked(_ sender: AnyObject) {
        let rotation = CGFloat(degreesToRadians(rotationTextField.doubleValue))

        if NSOnState == rotateNewCheckBox.state {
            transform = CGAffineTransform(rotationAngle: rotation)
        } else {
            transform = transform.rotated(by: rotation)
        }

        readFieldsFromTranform()
        dirty = true
    }

    @IBAction func scaleClicked(_ sender: AnyObject) {
        let sx = CGFloat(sxTextField.doubleValue)
        let sy = CGFloat(syTextField.doubleValue)

        if NSOnState == scaleNewCheckbox.state {
            transform = CGAffineTransform(scaleX: sx, y: sy)
        } else {
            transform = transform.scaledBy(x: sx, y: sy)
        }

        readFieldsFromTranform()
        dirty = true
    }

    @IBAction func translateClicked(_ sender: AnyObject) {
        let tx = CGFloat(translateTxTextField.doubleValue)
        let ty = CGFloat(translateTyTextField.doubleValue)

        if NSOnState == translateNewCheckbox.state {
            transform = CGAffineTransform(translationX: tx, y: ty)
        } else {
            transform = transform.translatedBy(x: tx, y: ty)
        }

        readFieldsFromTranform()
        dirty = true
    }


    @IBAction func concatClicked(_ sender: AnyObject) {
        let concatTransform = CGAffineTransform(a: CGFloat(concatATextField.doubleValue), b: CGFloat(concatBTextField.doubleValue), c: CGFloat(concatCTextField.doubleValue), d: CGFloat(concatDTextField.doubleValue), tx: CGFloat(concatTxTextField.doubleValue), ty: CGFloat(concatTyTextField.doubleValue))
        transform = transform.concatenating(concatTransform)

        readFieldsFromTranform()
        dirty = true
    }
}

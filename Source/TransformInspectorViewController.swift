//
//  TransformInspectorViewController.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 3/26/15.
//  Copyright (c) 2015 Nathan Corvino. All rights reserved.
//

import Cocoa

class TransformInspectorViewController: InspectorPaneViewController {

    var transform = CATransform3DIdentity

    @IBOutlet weak var m11TextField: NSTextField!
    @IBOutlet weak var m12TextField: NSTextField!
    @IBOutlet weak var m13TextField: NSTextField!
    @IBOutlet weak var m14TextField: NSTextField!
    @IBOutlet weak var m21TextField: NSTextField!
    @IBOutlet weak var m22TextField: NSTextField!
    @IBOutlet weak var m23TextField: NSTextField!
    @IBOutlet weak var m24TextField: NSTextField!
    @IBOutlet weak var m31TextField: NSTextField!
    @IBOutlet weak var m32TextField: NSTextField!
    @IBOutlet weak var m33TextField: NSTextField!
    @IBOutlet weak var m34TextField: NSTextField!
    @IBOutlet weak var m41TextField: NSTextField!
    @IBOutlet weak var m42TextField: NSTextField!
    @IBOutlet weak var m43TextField: NSTextField!
    @IBOutlet weak var m44TextField: NSTextField!

    @IBOutlet weak var scaleNewCheckbox: NSButton!
    @IBOutlet weak var sxTextField: NSTextField!
    @IBOutlet weak var syTextField: NSTextField!
    @IBOutlet weak var szTextField: NSTextField!

    @IBOutlet weak var rotateNewCheckbox: NSButton!
    @IBOutlet weak var angleTextField: NSTextField!
    @IBOutlet weak var xTextField: NSTextField!
    @IBOutlet weak var yTextField: NSTextField!
    @IBOutlet weak var zTextField: NSTextField!

    @IBOutlet weak var concatM11TextField: NSTextField!
    @IBOutlet weak var concatM12TextField: NSTextField!
    @IBOutlet weak var concatM13TextField: NSTextField!
    @IBOutlet weak var concatM14TextField: NSTextField!
    @IBOutlet weak var concatM21TextField: NSTextField!
    @IBOutlet weak var concatM22TextField: NSTextField!
    @IBOutlet weak var concatM23TextField: NSTextField!
    @IBOutlet weak var concatM24TextField: NSTextField!
    @IBOutlet weak var concatM31TextField: NSTextField!
    @IBOutlet weak var concatM32TextField: NSTextField!
    @IBOutlet weak var concatM33TextField: NSTextField!
    @IBOutlet weak var concatM34TextField: NSTextField!
    @IBOutlet weak var concatM41TextField: NSTextField!
    @IBOutlet weak var concatM42TextField: NSTextField!
    @IBOutlet weak var concatM43TextField: NSTextField!
    @IBOutlet weak var concatM44TextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        readConcatFromIdentity()
    }

    override func changesAnimated(_ notification: Notification) {
        super.animateChanges(notification)

        if nil != layerVisualization {
            transform = layerVisualization!.transform
            readFieldsFromTranform()
        }
    }

    override func animateChanges(_ notification: Notification) {
        super.animateChanges(notification)

        if dirty && nil != layerVisualization {
            readTransformFromFields()
            layerVisualization!.transform = transform
            dirty = false
        }
    }

    func readTransformFromFields() {
        transform.m11 = CGFloat(m11TextField.doubleValue)
        transform.m12 = CGFloat(m12TextField.doubleValue)
        transform.m13 = CGFloat(m13TextField.doubleValue)
        transform.m14 = CGFloat(m14TextField.doubleValue)
        transform.m21 = CGFloat(m21TextField.doubleValue)
        transform.m22 = CGFloat(m22TextField.doubleValue)
        transform.m23 = CGFloat(m23TextField.doubleValue)
        transform.m24 = CGFloat(m24TextField.doubleValue)
        transform.m31 = CGFloat(m31TextField.doubleValue)
        transform.m32 = CGFloat(m32TextField.doubleValue)
        transform.m33 = CGFloat(m33TextField.doubleValue)
        transform.m34 = CGFloat(m34TextField.doubleValue)
        transform.m41 = CGFloat(m41TextField.doubleValue)
        transform.m42 = CGFloat(m42TextField.doubleValue)
        transform.m43 = CGFloat(m43TextField.doubleValue)
        transform.m44 = CGFloat(m44TextField.doubleValue)
    }

    func readFieldsFromTranform() {
        m11TextField.doubleValue = Double(transform.m11)
        m12TextField.doubleValue = Double(transform.m12)
        m13TextField.doubleValue = Double(transform.m13)
        m14TextField.doubleValue = Double(transform.m14)
        m21TextField.doubleValue = Double(transform.m21)
        m22TextField.doubleValue = Double(transform.m22)
        m23TextField.doubleValue = Double(transform.m23)
        m24TextField.doubleValue = Double(transform.m24)
        m31TextField.doubleValue = Double(transform.m31)
        m32TextField.doubleValue = Double(transform.m32)
        m33TextField.doubleValue = Double(transform.m33)
        m34TextField.doubleValue = Double(transform.m34)
        m41TextField.doubleValue = Double(transform.m41)
        m42TextField.doubleValue = Double(transform.m42)
        m43TextField.doubleValue = Double(transform.m43)
        m44TextField.doubleValue = Double(transform.m44)
    }

    func readConcatFromIdentity() {
        let identity = CATransform3DIdentity

        concatM11TextField.doubleValue = Double(identity.m11)
        concatM12TextField.doubleValue = Double(identity.m12)
        concatM13TextField.doubleValue = Double(identity.m13)
        concatM14TextField.doubleValue = Double(identity.m14)
        concatM21TextField.doubleValue = Double(identity.m21)
        concatM22TextField.doubleValue = Double(identity.m22)
        concatM23TextField.doubleValue = Double(identity.m23)
        concatM24TextField.doubleValue = Double(identity.m24)
        concatM31TextField.doubleValue = Double(identity.m31)
        concatM32TextField.doubleValue = Double(identity.m32)
        concatM33TextField.doubleValue = Double(identity.m33)
        concatM34TextField.doubleValue = Double(identity.m34)
        concatM41TextField.doubleValue = Double(identity.m41)
        concatM42TextField.doubleValue = Double(identity.m42)
        concatM43TextField.doubleValue = Double(identity.m43)
        concatM44TextField.doubleValue = Double(identity.m44)
    }

    @IBAction func invertClicked(_ sender: AnyObject) {
        transform = CATransform3DInvert(transform)

        readFieldsFromTranform()
        dirty = true
    }

    @IBAction func scaleClicked(_ sender: AnyObject) {
        let sx = CGFloat(sxTextField.doubleValue)
        let sy = CGFloat(syTextField.doubleValue)
        let sz = CGFloat(szTextField.doubleValue)

        if NSOnState == scaleNewCheckbox.state {
            transform = CATransform3DMakeScale(sx, sy, sz)
        } else {
            transform = CATransform3DScale(transform, sx, sy, sz)
        }

        readFieldsFromTranform()
        dirty = true
    }

    @IBAction func rotateClicked(_ sender: AnyObject) {
        let angle = CGFloat(degreesToRadians(angleTextField.doubleValue))
        let x = CGFloat(xTextField.doubleValue)
        let y = CGFloat(xTextField.doubleValue)
        let z = CGFloat(xTextField.doubleValue)

        if NSOnState == rotateNewCheckbox.state {
            transform = CATransform3DMakeRotation(angle, x, y, z)
        } else {
            transform = CATransform3DRotate(transform, angle, x, y, z)
        }

        readFieldsFromTranform()
        dirty = true
    }

    @IBAction func concatClicked(_ sender: AnyObject) {
        let m11 = CGFloat(concatM11TextField.doubleValue)
        let m12 = CGFloat(concatM12TextField.doubleValue)
        let m13 = CGFloat(concatM13TextField.doubleValue)
        let m14 = CGFloat(concatM14TextField.doubleValue)
        let m21 = CGFloat(concatM21TextField.doubleValue)
        let m22 = CGFloat(concatM22TextField.doubleValue)
        let m23 = CGFloat(concatM23TextField.doubleValue)
        let m24 = CGFloat(concatM24TextField.doubleValue)
        let m31 = CGFloat(concatM31TextField.doubleValue)
        let m32 = CGFloat(concatM32TextField.doubleValue)
        let m33 = CGFloat(concatM33TextField.doubleValue)
        let m34 = CGFloat(concatM34TextField.doubleValue)
        let m41 = CGFloat(concatM41TextField.doubleValue)
        let m42 = CGFloat(concatM42TextField.doubleValue)
        let m43 = CGFloat(concatM43TextField.doubleValue)
        let m44 = CGFloat(concatM44TextField.doubleValue)
        let concatTransform = CATransform3D(
            m11: m11, m12: m12, m13: m13, m14: m14,
            m21: m21, m22: m22, m23: m23, m24: m24,
            m31: m31, m32: m32, m33: m33, m34: m34,
            m41: m41, m42: m42, m43: m43, m44: m44)

        transform = CATransform3DConcat(transform, concatTransform)

        readFieldsFromTranform()
        dirty = true
    }

    @IBAction func identityClicked(_ sender: AnyObject) {
        readConcatFromIdentity()
    }
}

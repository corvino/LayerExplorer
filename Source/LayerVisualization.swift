//
//  LayerView.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 3/17/15.
//  Copyright (c) 2015 Nathan Corvino. All rights reserved.
//

import Cocoa

class BoundsTiledLayerDelegate : NSObject, CALayerDelegate {
    let hashColors = [NSColor.green, NSColor.black, NSColor.yellow, NSColor.orange, NSColor.cyan, NSColor.magenta, NSColor.purple, NSColor.brown]
    let hashSpacing = 100
    let hashFactor = 100
    let hashRadius : CGFloat = 8.0
    let hashWidth : CGFloat = 2.0
    let fontSize : CGFloat = 17.0

    func colorForHash(_ hash : CGPoint) -> NSColor {
        return hashColors[((Int(hash.x) + 2 * Int(hash.y)) / hashSpacing) % hashColors.count]
    }

    func draw(_ layer: CALayer, in context: CGContext) {
        let box = context.boundingBoxOfClipPath
        let startX = (Int(box.origin.x) / hashSpacing) * hashSpacing
        let startY = (Int(box.origin.y) / hashSpacing) * hashSpacing

        // We know this font is there, so "cheat" and use crash operator.
        let font = NSFont(name: "Helvetica", size: fontSize)!

        context.textMatrix = CGAffineTransform(scaleX: 1, y: 1)
        context.setLineWidth(hashWidth)

        var x = startX
        while CGFloat(x) < box.origin.x + box.size.width {
            var y = startY
            while CGFloat(y) < box.origin.y + box.size.height {
                let hash = CGPoint(x: x, y: y)
                let color = colorForHash(hash)
                let points = [ CGPoint(x: hash.x - hashRadius, y: hash.y), CGPoint(x: hash.x + hashRadius, y: hash.y),
                               CGPoint(x: hash.x, y: hash.y - hashRadius), CGPoint(x: hash.x, y: hash.y + hashRadius)]
                context.setStrokeColor(color.cgColor)
                context.setFillColor(color.cgColor)
                context.strokeLineSegments(between: points)

                let textAttributes = [ NSFontAttributeName : font, NSForegroundColorAttributeName : color ]

                let xDisplay = (x + Int(layer.frame.origin.x)) /  hashFactor
                let yDisplay = (y + Int(layer.frame.origin.y)) / hashFactor
                let xyText = NSAttributedString(string: "(\(xDisplay),\(yDisplay))", attributes: textAttributes)

                context.saveGState()
                context.textPosition = CGPoint(x: hash.x + 7, y: hash.y + 7)
                CTLineDraw(CTLineCreateWithAttributedString(xyText), context)
                context.restoreGState()
                y += hashSpacing
            }
            x += hashSpacing
        }
    }
}

class LayerVisualization {

    fileprivate let frameShape = CALayer()
    fileprivate let anchorDot = CAShapeLayer()
    fileprivate let modelLayer = CALayer()
    fileprivate let tiledDelegate = BoundsTiledLayerDelegate()

    var frame : CGRect {
        get { return modelLayer.frame }
        set(newFrame) {
            modelLayer.frame = newFrame
            updateVisualizations()
        }
    }

    var bounds: CGRect {
        get { return modelLayer.bounds }
        set(newFrame) {
            modelLayer.bounds = newFrame
            updateVisualizations()
        }
    }

    var position : CGPoint {
        get { return modelLayer.position }
        set(newPosition) {
            modelLayer.position = newPosition
            updateVisualizations()
        }
    }

    var anchorPoint : CGPoint {
        get { return modelLayer.anchorPoint }
        set(newAnchorPoint) {
            modelLayer.anchorPoint = newAnchorPoint
            updateVisualizations()
        }
    }

    var anchorPointZ : CGFloat {
        get { return modelLayer.anchorPointZ }
        set(newAnchorPointZ) {
            modelLayer.anchorPointZ = newAnchorPointZ
            updateVisualizations()
        }
    }

    var affineTransform : CGAffineTransform {
        get { return modelLayer.affineTransform() }
        set(newAffineTransform) {
            modelLayer.setAffineTransform(newAffineTransform)
            updateVisualizations()
        }
    }

    var transform : CATransform3D {
        get { return modelLayer.transform }
        set(newTransform) {
            modelLayer.transform = newTransform
            updateVisualizations()
        }
    }

    init() {
        let tiledLayer = CATiledLayer()
        tiledLayer.frame = CGRect(origin: CGPoint(x: -5000, y:-5000), size: CGSize(width: 10000, height: 10000))
        tiledLayer.delegate = tiledDelegate

        modelLayer.addSublayer(tiledLayer)

        modelLayer.masksToBounds = true
        modelLayer.backgroundColor = NSColor.white.cgColor

        anchorDot.zPosition = CGFloat.greatestFiniteMagnitude
        anchorDot.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 15, height: 15))
        anchorDot.path = CGPath(ellipseIn: anchorDot.frame, transform: nil)

        frameShape.borderWidth = 3
        frameShape.borderColor = NSColor.blue.cgColor
    }

    func addToLayer(_ layer: CALayer) {
        let contentsScale = layer.contentsScale

        modelLayer.contentsScale = contentsScale
        frameShape.contentsScale = contentsScale
        anchorDot.contentsScale = contentsScale

        layer.addSublayer(modelLayer)
        layer.addSublayer(frameShape)
        layer.addSublayer(anchorDot)
        updateVisualizations()
    }

    func updateVisualizations() {
        frameShape.frame = modelLayer.frame
        if let _ = modelLayer.superlayer {
            var newPosition = CGPoint(x: anchorPoint.x * bounds.width + bounds.origin.x, y: anchorPoint.y * bounds.height + bounds.origin.y)
            newPosition = (modelLayer.superlayer?.convert(newPosition, from: modelLayer))!
            anchorDot.position = newPosition
        }
    }
}

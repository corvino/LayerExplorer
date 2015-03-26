//
//  LayerView.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 3/17/15.
//  Copyright (c) 2015 Nathan Corvino. All rights reserved.
//

import Cocoa

class BoundsTiledLayerDelegate : NSObject {
    let hashColors = [NSColor.greenColor(), NSColor.blackColor(), NSColor.yellowColor(), NSColor.orangeColor(), NSColor.cyanColor(), NSColor.magentaColor(), NSColor.purpleColor(), NSColor.brownColor()]
    let hashSpacing = 100
    let hashFactor = 100
    let hashRadius : CGFloat = 8.0
    let hashWidth : CGFloat = 2.0
    let fontSize : CGFloat = 17.0

    func colorForHash(hash : CGPoint) -> NSColor {
        return hashColors[((Int(hash.x) + 2 * Int(hash.y)) / hashSpacing) % hashColors.count]
    }

    override func drawLayer(layer : CALayer, inContext context: CGContextRef) {
        let box = CGContextGetClipBoundingBox(context)
        let startX = (Int(box.origin.x) / hashSpacing) * hashSpacing
        let startY = (Int(box.origin.y) / hashSpacing) * hashSpacing

        CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1, 1))
        CGContextSetLineWidth(context, hashWidth)

        for var x = startX; CGFloat(x) < box.origin.x + box.size.width; x += hashSpacing {
            for var y = startY; CGFloat(y) < box.origin.y + box.size.height; y += hashSpacing {
                let hash = CGPoint(x: x, y: y)
                let color = colorForHash(hash)
                let points = [ CGPoint(x: hash.x - hashRadius, y: hash.y), CGPoint(x: hash.x + hashRadius, y: hash.y),
                               CGPoint(x: hash.x, y: hash.y - hashRadius), CGPoint(x: hash.x, y: hash.y + hashRadius)]
                CGContextSetStrokeColorWithColor(context, color.CGColor)
                CGContextSetFillColorWithColor(context, color.CGColor)
                CGContextStrokeLineSegments(context, points, 4)

                if let font = NSFont(name: "Helvetica", size: fontSize) {
                    let attributes = [ NSFontAttributeName : font, NSForegroundColorAttributeName : NSColor.blackColor() ]
                    let xText = NSAttributedString(string: "(\(x / hashFactor)", attributes: attributes)
                    let yText = NSAttributedString(string: " \(y / hashFactor))", attributes: attributes)
                    let xyText = NSAttributedString(string: "(\(x / hashFactor),\(y / hashFactor))", attributes: attributes)

                    CGContextSaveGState(context)
                    CGContextSetTextPosition(context, hash.x + 7, hash.y + 7)
                    CTLineDraw(CTLineCreateWithAttributedString(xyText), context)
                    CGContextRestoreGState(context)
                }
            }
        }
    }
}

class LayerVisualization {

    private let frameShape = CAShapeLayer()
    private let modelLayer = CALayer()
    private let tiledDelegate = BoundsTiledLayerDelegate()

    var frame : CGRect {
        get { return modelLayer.frame }
        set(newFrame) {
            modelLayer.frame = newFrame
            updateFrameShape()
        }
    }

    var bounds: CGRect {
        get { return modelLayer.bounds }
        set(newFrame) {
            modelLayer.bounds = newFrame
            updateFrameShape()
        }
    }

    var position : CGPoint {
        get { return modelLayer.position }
        set(newPosition) {
            modelLayer.position = newPosition
            updateFrameShape()
        }
    }

    var anchorPoint : CGPoint {
        get { return modelLayer.anchorPoint }
        set(newAnchorPoint) {
            modelLayer.anchorPoint = newAnchorPoint
            updateFrameShape()
        }
    }

    var affineTransform : CGAffineTransform {
        get { return modelLayer.affineTransform() }
        set(newAffineTransform) {
            modelLayer.setAffineTransform(newAffineTransform)
            updateFrameShape()
        }
    }

    var transform : CATransform3D {
        get { return modelLayer.transform }
        set(newTransform) {
            modelLayer.transform = newTransform
            updateFrameShape()
        }
    }

    init() {
        let tiledLayer = CATiledLayer()
        tiledLayer.frame = CGRect(origin: CGPoint(x: 0, y:0), size: CGSize(width: 1000, height: 1000))
        tiledLayer.delegate = tiledDelegate

        modelLayer.addSublayer(tiledLayer)
        modelLayer.addSublayer(frameShape)

        modelLayer.masksToBounds = true
        modelLayer.backgroundColor = NSColor.whiteColor().CGColor

        frameShape.fillColor = nil
        frameShape.strokeColor = NSColor.blueColor().CGColor
        frameShape.lineWidth = 3
    }

    func addToLayer(layer: CALayer) {
        layer.addSublayer(modelLayer)
        layer.addSublayer(frameShape)
    }

    func updateFrameShape() {
        frameShape.frame = modelLayer.frame
        frameShape.path = CGPathCreateWithRect(CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: modelLayer.frame.width, height: modelLayer.frame.height)), nil)
    }
}

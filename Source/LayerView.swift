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
    let hashSpacing = 50
    let hashSize : CGFloat = 3.0

    func colorForHash(hash : CGPoint) -> NSColor {
        return hashColors[((Int(hash.x) + 2 * Int(hash.y)) / hashSpacing) % hashColors.count]
    }

    override func drawLayer(layer : CALayer, inContext context: CGContextRef) {
        let box = CGContextGetClipBoundingBox(context)
        let startX = (Int(box.origin.x) / hashSpacing) * hashSpacing
        let startY = (Int(box.origin.y) / hashSpacing) * hashSpacing

        CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1, 1))

        for var x = startX; CGFloat(x) < box.origin.x + box.size.width; x += hashSpacing {
            for var y = startY; CGFloat(y) < box.origin.y + box.size.height; y += hashSpacing {
                let hash = CGPoint(x: x, y: y)
                let color = colorForHash(hash)
                let points = [ CGPoint(x: hash.x - hashSize, y: hash.y), CGPoint(x: hash.x + hashSize, y: hash.y),
                               CGPoint(x: hash.x, y: hash.y - hashSize), CGPoint(x: hash.x, y: hash.y + hashSize)]
                CGContextSetStrokeColorWithColor(context, color.CGColor)
                CGContextSetFillColorWithColor(context, color.CGColor)
                CGContextStrokeLineSegments(context, points, 4)

                if let font = NSFont(name: "Helvetica", size: 10.0) {
                    let attributes = [ NSFontAttributeName : font, NSForegroundColorAttributeName : NSColor.blackColor() ]
                    let xText = NSAttributedString(string: "(\(x)", attributes: attributes)
                    let yText = NSAttributedString(string: " \(y))", attributes: attributes)

                    CGContextSaveGState(context)
                    CGContextSetTextPosition(context, hash.x + 2, hash.y - 8)
                    CTLineDraw(CTLineCreateWithAttributedString(xText), context)
                    CGContextRestoreGState(context)

                    CGContextSaveGState(context)
                    CGContextSetTextPosition(context, hash.x + 2, hash.y - 19)
                    CTLineDraw(CTLineCreateWithAttributedString(yText), context)
                    CGContextRestoreGState(context)

                    CGContextFlush(context)
                }
            }
        }
    }
}

class LayerView: NSView {

    let tiledDelegate = BoundsTiledLayerDelegate()
    let tiledLayer = CATiledLayer()

    override init(frame frameRect: NSRect) {
        super.init(frame:frameRect)
        doInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        doInit()
    }

    func doInit() {
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.lightGrayColor().CGColor

        tiledLayer.delegate = self.tiledDelegate
        tiledLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 1000, height: 1000))

        self.layer?.addSublayer(tiledLayer)
        tiledLayer.setNeedsDisplay()
    }
}

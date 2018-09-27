//
//  TiledImageView.swift
//  ImageTiling
//
//  Created by Nate Chandler on 2/27/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

@IBDesignable
class TiledImageView: NSView {
    
    @IBInspectable var image: NSImage?
    let columnCount = 5
    let rowCount = 5
    
    // MARK: - Drawing
    
    func frameForImageAtLogicalX(logicalX: Int, y logicalY: Int) -> CGRect {
        let spacing = 10
        let width = 100
        let height = 100
        let x = (spacing + width) * logicalX
        let y = (spacing + height) * logicalY
        return CGRect(x: x, y: y, width: width, height: height)
    }

    override func draw(_ dirtyRect: NSRect) {
        if let image = image {
            for x in 0..<columnCount {
                for y in 0..<rowCount {
                    let frame = frameForImageAtLogicalX(logicalX: x, y: y)
                    image.draw(in: frame)
                }
            }
        }
    }
    
    override var intrinsicContentSize: NSSize {
        let furthestFrame = frameForImageAtLogicalX(logicalX: columnCount-1, y: rowCount-1)
        return NSSize(width: furthestFrame.maxX, height: furthestFrame.maxY)
    }
    
}

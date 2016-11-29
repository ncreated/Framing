//
//  Frame.swift
//  Framing
//
//  Created by Maciek Grzybowski on 29.11.2016.
//  Copyright © 2016 ncreated. All rights reserved.
//

import Foundation


public struct Frame {
    public let x: CGFloat
    public let y: CGFloat
    public let width: CGFloat
    public let height: CGFloat
    
    public var minX: CGFloat { return x }
    public var maxX: CGFloat { return x + width }
    public var minY: CGFloat { return y }
    public var maxY: CGFloat { return y + height }

    
    // MARK: Initializers
    
    public init(x: CGFloat = 0, y: CGFloat = 0, width: CGFloat = 0, height: CGFloat = 0) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
    
    public init(ofSize size: CGSize) {
        self.init(width: size.width, height: size.height)
    }
}


extension Frame: Equatable {
    public static func ==(lhs: Frame, rhs: Frame) -> Bool {
        return lhs.x == rhs.x &&
               lhs.y == rhs.y &&
               lhs.width == rhs.width &&
               lhs.height == rhs.height
    }
}

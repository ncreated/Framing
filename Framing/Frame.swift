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
    
    public init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
}

//
//  Frame.swift
//  Framing
//
//  Created by Maciek Grzybowski on 29.11.2016.
//  Copyright © 2016 ncreated. All rights reserved.
//

import Foundation


/// Operations that can proceed condition
protocol ConditionProceedingOperations {
    func inset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Frame
    func offsetBy(x: CGFloat, y: CGFloat) -> Frame
}


public struct Frame: ConditionProceedingOperations {
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
    
    public init(rect: CGRect) {
        self.init(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: rect.height)
    }
    
    // MARK: Inset
    
    public func inset(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Frame {
        return Frame(x: x + left, y: y + top, width: width - left - right, height: height - top - bottom)
    }

    // MARK: Offset
    
    public func offsetBy(x: CGFloat = 0, y: CGFloat = 0) -> Frame {
        return Frame(x: self.x + x, y: self.y + y, width: width, height: height)
    }

    // MARK: Relative position
    
    public enum HorizontalAlignment {
        case left
        case right
        case center
    }
    
    public enum VerticalAlignment {
        case top
        case bottom
        case middle
    }
    
    public enum InsideAlignment {
        case topLeft
        case topCenter
        case topRight
        case middleLeft
        case middleCenter
        case middleRight
        case bottomLeft
        case bottomCenter
        case bottomRight
        
        fileprivate var horizontal: HorizontalAlignment {
            switch self {
            case .topLeft:       return .left
            case .topCenter:     return .center
            case .topRight:      return .right
            case .middleLeft:    return .left
            case .middleCenter:  return .center
            case .middleRight:   return .right
            case .bottomLeft:    return .left
            case .bottomCenter:  return .center
            case .bottomRight:   return .right
            }
        }
        
        fileprivate var vertical: VerticalAlignment {
            switch self {
            case .topLeft:       return .top
            case .topCenter:     return .top
            case .topRight:      return .top
            case .middleLeft:    return .middle
            case .middleCenter:  return .middle
            case .middleRight:   return .middle
            case .bottomLeft:    return .bottom
            case .bottomCenter:  return .bottom
            case .bottomRight:   return .bottom
            }
        }
    }
    
    public struct RelativePosition {
        public struct Below {
            let frame: Frame
            let size: CGSize
            
            /// Sets horizontal alignment of this frame, relatively to given `frame`
            public func align(to alignment: HorizontalAlignment) -> Frame {
                switch alignment {
                case .left:
                    return Frame(x: frame.minX, y: frame.maxY, width: size.width, height: size.height)
                case .right:
                    return Frame(x: frame.maxX - size.width, y: frame.maxY, width: size.width, height: size.height)
                case .center:
                    return Frame(x: frame.minX + (frame.width - size.width) * 0.5,
                                 y: frame.maxY,
                                 width: size.width,
                                 height: size.height)
                }
            }
        }
        
        public struct Above {
            let frame: Frame
            let size: CGSize
            
            /// Sets horizontal alignment of this frame, relatively to given `frame`
            public func align(to alignment: HorizontalAlignment) -> Frame {
                switch alignment {
                case .left:
                    return Frame(x: frame.minX, y: frame.minY - size.height, width: size.width, height: size.height)
                case .right:
                    return Frame(x: frame.maxX - size.width, y: frame.minY - size.height, width: size.width, height: size.height)
                case .center:
                    return Frame(x: frame.minX + (frame.width - size.width) * 0.5,
                                 y: frame.minY - size.height,
                                 width: size.width,
                                 height: size.height)
                }
            }
        }
        
        public struct Left {
            let frame: Frame
            let size: CGSize
            
            /// Sets vertical alignment of this frame, relatively to given `frame`
            public func align(to alignment: VerticalAlignment) -> Frame {
                switch alignment {
                case .top:
                    return Frame(x: frame.minX - size.width, y: frame.minY, width: size.width, height: size.height)
                case .bottom:
                    return Frame(x: frame.minX - size.width, y: frame.maxY - size.height, width: size.width, height: size.height)
                case .middle:
                    return Frame(x: frame.minX - size.width,
                                 y: frame.minY + (frame.height - size.height) * 0.5,
                                 width: size.width,
                                 height: size.height)
                }
            }
        }
        
        public struct Right {
            let frame: Frame
            let size: CGSize
            
            /// Sets vertical alignment of this frame, relatively to given `frame`
            public func align(to alignment: VerticalAlignment) -> Frame {
                switch alignment {
                case .top:
                    return Frame(x: frame.maxX, y: frame.minY, width: size.width, height: size.height)
                case .bottom:
                    return Frame(x: frame.maxX, y: frame.maxY - size.height, width: size.width, height: size.height)
                case .middle:
                    return Frame(x: frame.maxX,
                                 y: frame.minY + (frame.height - size.height) * 0.5,
                                 width: size.width,
                                 height: size.height)
                }
            }
        }
        
        public struct Inside {
            let frame: Frame
            let size: CGSize
         
            /// Sets vertical & horizontal alignment of this frame, relatively to given `frame`
            public func align(to alignment: InsideAlignment) -> Frame {
                let x: CGFloat = {
                    switch alignment.horizontal {
                    case .left:     return frame.minX
                    case .right:    return frame.maxX - size.width
                    case .center:   return frame.minX + (frame.width - size.width) * 0.5
                    }
                }()
                
                let y: CGFloat = {
                    switch alignment.vertical {
                    case .top:      return frame.minY
                    case .bottom:   return frame.maxY - size.height
                    case .middle:   return frame.minY + (frame.height - size.height) * 0.5
                    }
                }()
                
                return Frame(x: x, y: y, width: size.width, height: size.height)
            }
        }
    }
    
    /// Positions this frame below given `frame`.
    /// **Note:** Must be followed by `align(to alignment: HorizontalAlignment)` to produce a `Frame`.
    public func putBelow(_ frame: Frame) -> RelativePosition.Below {
        return RelativePosition.Below(frame: frame, size: size)
    }
    
    /// Positions this frame above given `frame`.
    /// **Note:** Must be followed by `align(to alignment: HorizontalAlignment)` to produce a `Frame`.
    public func putAbove(_ frame: Frame) -> RelativePosition.Above {
        return RelativePosition.Above(frame: frame, size: size)
    }
    
    /// Positions this frame on the left side of given `frame`.
    /// **Note:** Must be followed by `align(to alignment: VerticalAlignment)` to produce a `Frame`.
    public func putOnLeft(of frame: Frame) -> RelativePosition.Left {
        return RelativePosition.Left(frame: frame, size: size)
    }
    
    /// Positions this frame on the right side of given `frame`.
    /// **Note:** Must be followed by `align(to alignment: VerticalAlignment)` to produce a `Frame`.
    public func putOnRight(of frame: Frame) -> RelativePosition.Right {
        return RelativePosition.Right(frame: frame, size: size)
    }
    
    /// Positions this frame inside given `frame`.
    /// **Note:** Must be followed by `align(to alignment: InsideAlignment)` to produce a `Frame`.
    public func putInside(_ frame: Frame) -> RelativePosition.Inside {
        return RelativePosition.Inside(frame: frame, size: size)
    }
    
    // MARK: Division
    
    public struct Division {
        public struct Horizontal {
            let frame: Frame
            let columns: Int
            
            /// Returns frame of column with given index.
            public func take(index: Int) -> Frame {
                let dividedSize = frame.width / CGFloat(columns)
                return Frame(x: frame.x + CGFloat(index) * dividedSize,
                             y: frame.y,
                             width: dividedSize,
                             height: frame.height)
            }
        }
        
        public struct Vertical {
            let frame: Frame
            let rows: Int
            
            /// Returns frame of row with given index.
            public func take(index: Int) -> Frame {
                let dividedSize = frame.height / CGFloat(rows)
                return Frame(x: frame.x,
                             y: frame.y + CGFloat(index) * dividedSize,
                             width: frame.width,
                             height: dividedSize)
            }
        }
    }
    
    /// Divides this frame into equal columns.
    /// **Note:** Must be followed by `take(index: Int)` to produce column's `Frame`.
    public func divideIntoEqual(columns: Int) -> Division.Horizontal {
        return Division.Horizontal(frame: self, columns: columns)
    }
    
    /// Divides this frame into equal rows.
    /// **Note:** Must be followed by `take(index: Int)` to produce rows' `Frame`.
    public func divideIntoEqual(rows: Int) -> Division.Vertical {
        return Division.Vertical(frame: self, rows: rows)
    }
    
    // MARK: Conditions
    
    public struct ConditionProceedingFrame: ConditionProceedingOperations {
        let frameBeforeCondition: Frame
        let conditionResult: Bool
        
        public func inset(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Frame {
            if conditionResult {
                return frameBeforeCondition.inset(top: top, left: left, bottom: bottom, right: right)
            } else {
                return frameBeforeCondition
            }
        }
        
        public func offsetBy(x: CGFloat = 0, y: CGFloat = 0) -> Frame {
            if conditionResult {
                return frameBeforeCondition.offsetBy(x: x, y: y)
            } else {
                return frameBeforeCondition
            }
        }
    }
    
    public func `if`(_ condition: Bool) -> ConditionProceedingFrame {
        return ConditionProceedingFrame(frameBeforeCondition: self, conditionResult: condition)
    }

    // MARK: CGGeometry conversion
    
    public var rect: CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    public var size: CGSize {
        return CGSize(width: width, height: height)
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

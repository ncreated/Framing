import Foundation
import CoreGraphics

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
    
    public init(rect: CGRect) {
        self.init(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: rect.height)
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
        
        internal var horizontal: HorizontalAlignment {
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
        
        internal var vertical: VerticalAlignment {
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
    
    // MARK: Private
    
    private struct RelativePosition {
        struct Below {
            let frame: Frame
            let size: CGSize
            
            /// Sets horizontal alignment of this frame, relatively to given `frame`
            func align(to alignment: HorizontalAlignment) -> Frame {
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
        
        struct Above {
            let frame: Frame
            let size: CGSize
            
            /// Sets horizontal alignment of this frame, relatively to given `frame`
            func align(to alignment: HorizontalAlignment) -> Frame {
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
        
        struct Left {
            let frame: Frame
            let size: CGSize
            
            /// Sets vertical alignment of this frame, relatively to given `frame`
            func align(to alignment: VerticalAlignment) -> Frame {
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
        
        struct Right {
            let frame: Frame
            let size: CGSize
            
            /// Sets vertical alignment of this frame, relatively to given `frame`
            func align(to alignment: VerticalAlignment) -> Frame {
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
        
        struct Inside {
            let frame: Frame
            let size: CGSize
         
            /// Sets vertical & horizontal alignment of this frame, relatively to given `frame`
            func align(to alignment: InsideAlignment) -> Frame {
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
    
    private struct Division {
        struct Horizontal {
            let frame: Frame
            let columns: Int
            
            /// Returns frame of column with given index.
            func take(index: Int) -> Frame {
                let dividedSize = frame.width / CGFloat(columns)
                return Frame(x: frame.x + CGFloat(index) * dividedSize,
                             y: frame.y,
                             width: dividedSize,
                             height: frame.height)
            }
        }
        
        struct Vertical {
            let frame: Frame
            let rows: Int
            
            /// Returns frame of row with given index.
            func take(index: Int) -> Frame {
                let dividedSize = frame.height / CGFloat(rows)
                return Frame(x: frame.x,
                             y: frame.y + CGFloat(index) * dividedSize,
                             width: frame.width,
                             height: dividedSize)
            }
        }
    }
    
    // MARK: Inset
    
    public func inset(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Frame {
        return Frame(x: x + left, y: y + top, width: width - left - right, height: height - top - bottom)
    }
    
    // MARK: Offset
    
    public func offsetBy(x: CGFloat = 0, y: CGFloat = 0) -> Frame {
        return Frame(x: self.x + x, y: self.y + y, width: width, height: height)
    }
    
    // MARK: Relative Position
    
    public func putBelow(_ frame: Frame, alignTo alignment: HorizontalAlignment = .center) -> Frame {
        return RelativePosition.Below(frame: frame, size: size).align(to: alignment)
    }
    
    public func putAbove(_ frame: Frame, alignTo alignment: HorizontalAlignment = .center) -> Frame {
        return RelativePosition.Above(frame: frame, size: size).align(to: alignment)
    }
    
    public func putOnLeft(of frame: Frame, alignTo alignment: VerticalAlignment = .middle) -> Frame {
        return RelativePosition.Left(frame: frame, size: size).align(to: alignment)
    }
    
    public func putOnRight(of frame: Frame, alignTo alignment: VerticalAlignment = .middle) -> Frame {
        return RelativePosition.Right(frame: frame, size: size).align(to: alignment)
    }
    
    public func putInside(_ frame: Frame, alignTo alignment: InsideAlignment = .middleCenter) -> Frame {
        return RelativePosition.Inside(frame: frame, size: size).align(to: alignment)
    }
    
    // MARK: Division
    
    public func divideIntoEqual(columns: Int, take index: Int) -> Frame {
        return Division.Horizontal(frame: self, columns: columns).take(index: index)
    }

    public func divideIntoEqual(rows: Int, take index: Int) -> Frame {
        return Division.Vertical(frame: self, rows: rows).take(index: index)
    }
    
    // MARK: Conditional Operations

    public func `if`(_ condition: Bool, then transform: (Frame) -> Frame) -> Frame {
        return `if`(condition: condition, then: transform, else: nil)
    }
    
    public func `if`(condition: Bool, then transform: (Frame) -> Frame, else alternativeTransform: ((Frame) -> Frame)? = nil) -> Frame {
        if condition {
            return transform(self)
        } else if let alternativeTransform = alternativeTransform {
            return alternativeTransform(self)
        } else {
            return self
        }
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

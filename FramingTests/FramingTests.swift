//
//  FramingTests.swift
//  FramingTests
//
//  Created by Maciek Grzybowski on 29.11.2016.
//  Copyright © 2016 ncreated. All rights reserved.
//

import XCTest
import Framing

class FramingTests: XCTestCase {
    
    func testInitialization() {
        let frame = Frame(x: 10, y: 10, width: 100, height: 100)
        
        XCTAssertEqual(frame.x, 10)
        XCTAssertEqual(frame.y, 10)
        XCTAssertEqual(frame.width, 100)
        XCTAssertEqual(frame.height, 100)
        
        XCTAssertEqual(frame.minX, 10)
        XCTAssertEqual(frame.minY, 10)
        XCTAssertEqual(frame.maxX, 110)
        XCTAssertEqual(frame.maxY, 110)
        
        let fromRect = Frame(rect: CGRect(x: 10, y: 10, width: 100, height: 100))
        XCTAssertEqual(frame, fromRect)
    }
    
    func testInsetting() {
        let frame = Frame(width: 100, height: 100)
        let modified = frame.inset(top: 5, left: 10, bottom: 20, right: 30)
        
        XCTAssertEqual(modified, Frame(x: 10, y: 5, width: 60, height: 75))
    }
    
    func testOffsetting() {
        let frame = Frame(width: 100, height: 100)
        let modified = frame.offsetBy(x: 10, y: 20)
        
        XCTAssertEqual(modified, Frame(x: 10, y: 20, width: 100, height: 100))
    }
    
    func testPositioningAbove() {
        let base = Frame(width: 100, height: 100)
        let frame = Frame(width: 50, height: 50)
        
        let left = frame.putAbove(base).align(to: .left)
        XCTAssertEqual(left, Frame(x: 0, y: -50, width: 50, height: 50))
        
        let right = frame.putAbove(base).align(to: .right)
        XCTAssertEqual(right, Frame(x: 50, y: -50, width: 50, height: 50))
        
        let center = frame.putAbove(base).align(to: .center)
        XCTAssertEqual(center, Frame(x: 25, y: -50, width: 50, height: 50))
    }
    
    func testPositioningBelow() {
        let base = Frame(width: 100, height: 100)
        let frame = Frame(width: 50, height: 50)
        
        let left = frame.putBelow(base).align(to: .left)
        XCTAssertEqual(left, Frame(x: 0, y: 100, width: 50, height: 50))
        
        let right = frame.putBelow(base).align(to: .right)
        XCTAssertEqual(right, Frame(x: 50, y: 100, width: 50, height: 50))
        
        let center = frame.putBelow(base).align(to: .center)
        XCTAssertEqual(center, Frame(x: 25, y: 100, width: 50, height: 50))
    }
    
    func testPositioningOnLeft() {
        let base = Frame(width: 100, height: 100)
        let frame = Frame(width: 50, height: 50)
        
        let top = frame.putOnLeft(of: base).align(to: .top)
        XCTAssertEqual(top, Frame(x: -50, y: 0, width: 50, height: 50))
        
        let bottom = frame.putOnLeft(of: base).align(to: .bottom)
        XCTAssertEqual(bottom, Frame(x: -50, y: 50, width: 50, height: 50))
        
        let middle = frame.putOnLeft(of: base).align(to: .middle)
        XCTAssertEqual(middle, Frame(x: -50, y: 25, width: 50, height: 50))
    }
    
    func testPositioningOnRight() {
        let base = Frame(width: 100, height: 100)
        let frame = Frame(width: 50, height: 50)
        
        let top = frame.putOnRight(of: base).align(to: .top)
        XCTAssertEqual(top, Frame(x: 100, y: 0, width: 50, height: 50))
        
        let bottom = frame.putOnRight(of: base).align(to: .bottom)
        XCTAssertEqual(bottom, Frame(x: 100, y: 50, width: 50, height: 50))
        
        let middle = frame.putOnRight(of: base).align(to: .middle)
        XCTAssertEqual(middle, Frame(x: 100, y: 25, width: 50, height: 50))
    }
    
    func testDistributingIntoEqualRows() {
        let frame = Frame(x: 100, y: 100, width: 120, height: 120)
        
        let row0 = frame.divideIntoEqual(rows: 3).take(index: 0)
        XCTAssertEqual(row0, Frame(x: 100, y: 100, width: 120, height: 40))
        
        let row1 = frame.divideIntoEqual(rows: 3).take(index: 1)
        XCTAssertEqual(row1, Frame(x: 100, y: 140, width: 120, height: 40))
        
        let row2 = frame.divideIntoEqual(rows: 3).take(index: 2)
        XCTAssertEqual(row2, Frame(x: 100, y: 180, width: 120, height: 40))
    }
    
    func testDistributingIntoEqualColumns() {
        let frame = Frame(x: 100, y: 100, width: 120, height: 120)
        
        let column0 = frame.divideIntoEqual(columns: 3).take(index: 0)
        XCTAssertEqual(column0, Frame(x: 100, y: 100, width: 40, height: 120))
        
        let column1 = frame.divideIntoEqual(columns: 3).take(index: 1)
        XCTAssertEqual(column1, Frame(x: 140, y: 100, width: 40, height: 120))
        
        let column2 = frame.divideIntoEqual(columns: 3).take(index: 2)
        XCTAssertEqual(column2, Frame(x: 180, y: 100, width: 40, height: 120))
    }
}

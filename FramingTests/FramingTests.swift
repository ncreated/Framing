//
//  FramingTests.swift
//  FramingTests
//
//  Created by Maciek Grzybowski on 29.11.2016.
//  Copyright © 2016 ncreated. All rights reserved.
//

import XCTest
@testable import Framing

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
    }
    
    func testInsetting() {
        let frame = Frame(width: 100, height: 100)
        let modified = frame.inset(top: 5, left: 10, bottom: 20, right: 30)
        
        XCTAssertEqual(modified, Frame(x: 10, y: 5, width: 60, height: 75))
    }
    
}

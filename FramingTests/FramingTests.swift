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
    }
    
}

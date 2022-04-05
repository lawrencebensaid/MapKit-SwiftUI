//
//  MapContextTests.swift
//  MKSUIAdapterTests
//
//  Created by Lawrence Bensaid on 4/5/22.
//

import XCTest
@testable import MKSUIAdapter

final class MapContextTests: XCTestCase {
    
    func testStartRoute() {
        
        let c = MapContext(latitude: 1, longitude: 2)
        
        c.onStartRoute { transportType, source, destination in
            XCTAssertEqual(transportType, .walking)
            XCTAssertEqual(source.longitude, 1)
            XCTAssertEqual(source.latitude, 1)
            XCTAssertEqual(destination.longitude, 2)
            XCTAssertEqual(destination.latitude, 1)
        }
        c.startRoute(.walking,
                     from: .init(latitude: 1, longitude: 1),
                     to: .init(latitude: 1, longitude: 2)
        )
        
    }
    
}

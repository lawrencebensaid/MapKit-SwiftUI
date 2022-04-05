//
//  MKSUIExtensionsTests.swift
//  MapKitSwiftUITests
//
//  Created by Lawrence Bensaid on 4/5/22.
//

import XCTest
import CoreLocation
@testable import MKSUIExtensions

final class MKSUIExtensionsTests: XCTestCase {
    
    func testEquatability_CLLocationCoordinate2D_1() {
        
        let lo = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        let ro = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        
        XCTAssert(lo == ro)
        
    }
    
    func testEquatability_CLLocationCoordinate2D_2() {
        
        let lo = CLLocationCoordinate2D(latitude: 4, longitude: 5)
        let ro = CLLocationCoordinate2D(latitude: 4, longitude: 2)
        
        XCTAssertFalse(lo == ro)
        
    }
    
}

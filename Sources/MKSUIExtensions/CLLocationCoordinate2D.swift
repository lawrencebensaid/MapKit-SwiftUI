//
//  CLLocationCoordinate2D.swift
//  MKSUIExtensions
//
//  Created by Lawrence Bensaid on 4/5/22.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
}

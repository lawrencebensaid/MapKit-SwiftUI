//
//  MapDirections.swift
//  MapKitSwiftUI
//
//  Created by Lawrence Bensaid on 4/5/22.
//

import MapKit
import MKSUIExtensions

public struct MapDirections: Equatable {
    
    public static func == (lhs: MapDirections, rhs: MapDirections) -> Bool {
        lhs.transportType == rhs.transportType && lhs.source == rhs.source && lhs.destination == rhs.destination
    }
    
    public let transportType: MKDirectionsTransportType
    public let source: CLLocationCoordinate2D
    public let destination: CLLocationCoordinate2D
    
    public init(_ transportType: MKDirectionsTransportType, from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        self.transportType = transportType
        self.source = source
        self.destination = destination
    }
    
}

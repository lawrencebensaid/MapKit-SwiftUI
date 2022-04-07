//
//  MapContext.swift
//  MKSUIAdapter
//
//  Created by Lawrence Bensaid on 4/5/22.
//

import MapKit
import MKSUIExtensions

public class MapContext {
    
    public let origin: CLLocationCoordinate2D

#if os(iOS)
    public var overlayColor: CGColor = UIColor.systemBlue.cgColor
#endif
#if os(macOS)
    public var overlayColor: CGColor = NSColor.systemBlue.cgColor
#endif
    
    public var overlayWidth: Float = 8
    
    private var didStart: ((MKDirectionsTransportType, CLLocationCoordinate2D, CLLocationCoordinate2D) -> ())?
    private var didStop: (() -> ())?
    
    public init(latitude: Double, longitude: Double) {
        origin = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public func onStartRoute(_ didStart: ((MKDirectionsTransportType, CLLocationCoordinate2D, CLLocationCoordinate2D) -> ())? = nil) {
        self.didStart = didStart
    }
    
    public func onStopRoute(_ didStop: (() -> ())? = nil) {
        self.didStop = didStop
    }
    
    public func startRoute(_ transportType: MKDirectionsTransportType, from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        didStart?(transportType, source, destination)
    }
    
    public func stopRoute() {
        didStop?()
    }
    
}

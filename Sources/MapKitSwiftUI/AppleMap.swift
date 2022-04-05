//
//  AppleMap.swift
//  MapKitSwiftUI
//
//  Created by Lawrence Bensaid on 4/4/22.
//

import MapKit
import SwiftUI
import Combine
import MKSUIAdapter

public struct AppleMap<V: Identifiable, A: AppleMapAnnotation>: View {
    
    @State private var animated = true
    @State private var map = MKMapView()
    @State private var context: MapContext
    @Binding private var directions: MapDirections?
    
    private let annotations: [V]
    
    private var iterate: ((V) -> A)?
    
    public init(lat latitude: Double, long longitude: Double, directions: Binding<MapDirections?>? = nil, annotations: [V], content: ((V) -> A)?) {
        _context = State(initialValue: MapContext(latitude: latitude, longitude: longitude))
        iterate = content
        self.annotations = annotations
        if let directions = directions {
            _directions = directions
        } else {
            _directions = Binding<MapDirections?> { return nil } set: { _ in }
        }
    }
    
    public init(lat latitude: Double, long longitude: Double, directions: Binding<MapDirections?>? = nil) {
        self.init(lat: latitude, long: longitude, directions: directions, annotations: [], content: nil)
    }
    
    public var body: some View {
        if #available(iOS 14.0, *) {
            MapViewAdapter(context, map: map, animated: animated)
                .onAppear(perform: fetchModels)
                .onChange(of: directions, perform: change)
        } else {
            MapViewAdapter(context, map: map, animated: animated)
                .onAppear(perform: fetchModels)
                .onReceive(Just(directions)) { change($0) }
        }
    }
    
    private func fetchModels() {
        for item in annotations {
            guard let model = iterate?(item) else { continue }
            map.addAnnotation(model.annotation)
        }
    }
    
    private func change(_ directions: MapDirections?) {
        if let directions = directions {
            context.startRoute(directions.transportType, from: directions.destination, to: directions.source)
        } else {
            context.stopRoute()
        }
    }
    
    // MARK: - SwiftUI Modifiers
    
    public func pointsOfInterest(_ filter: MKPointOfInterestFilter?) -> AppleMap {
        map.pointOfInterestFilter = filter ?? .excludingAll
        return self
    }
    
    public func pointsOfInterest(include points: [MKPointOfInterestCategory]) -> AppleMap {
        map.pointOfInterestFilter = MKPointOfInterestFilter(including: points)
        return self
    }
    
    public func pointsOfInterest(exclude points: [MKPointOfInterestCategory]) -> AppleMap {
        map.pointOfInterestFilter = MKPointOfInterestFilter(excluding: points)
        return self
    }
    
    /// Sets a camera boundry a specified `distance` from the origin point.
    public func boundary(distance: Float) -> AppleMap {
        return self.boundary(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(context.origin.latitude), longitude: CLLocationDegrees(context.origin.longitude)), latitudinalMeters: CLLocationDistance(distance), longitudinalMeters: CLLocationDistance(distance)))
    }
    
    /// Sets a camera boundry a specified `distance` from specified coordinate `lat` `long`.
    public func boundary(lat latitude: Float, long longitude: Float, distance: Float) -> AppleMap {
        return self.boundary(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)), latitudinalMeters: CLLocationDistance(distance), longitudinalMeters: CLLocationDistance(distance)))
    }
    
    /// Sets a camera boundry at the specified `coordinateRegion`.
    public func boundary(_ coordinateRegion: MKCoordinateRegion) -> AppleMap {
        map.setCameraBoundary(.init(coordinateRegion: coordinateRegion), animated: animated)
        return self
    }
    
    /// Sets a camera boundry at the specified `mapRect`.
    public func boundary(_ mapRect: MKMapRect) -> AppleMap {
        map.setCameraBoundary(.init(mapRect: mapRect), animated: animated)
        return self
    }
    
    public func zoomBoundry(_ range: Range<Float>) -> AppleMap {
        map.setCameraZoomRange(.init(minCenterCoordinateDistance: CLLocationDistance(range.lowerBound), maxCenterCoordinateDistance: CLLocationDistance(range.upperBound)), animated: animated)
        return self
    }
    
    public func zoomBoundry(_ constraint: Float) -> AppleMap {
        map.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: CLLocationDistance(constraint), maxCenterCoordinateDistance: CLLocationDistance(constraint))
        return self
    }
    
    /// Sets the color (and width) of the directions overlay stroke while a navigation session is active
    public func directionOverlay(color: UIColor, width: Float? = nil) -> AppleMap {
        context.overlayColor = color.cgColor
        if let width = width {
            context.overlayWidth = width
        }
        return self
    }
    
    /// Sets the width of the directions overlay stroke while a navigation session is active
    public func directionOverlay(width: Float) -> AppleMap {
        context.overlayWidth = width
        return self
    }
    
    /// Sets the type of map
    public func mapType(_ type: MKMapType) -> AppleMap {
        map.mapType = type
        return self
    }
    
    public func userTracking(_ mode: MKUserTrackingMode) -> AppleMap {
        map.setUserTrackingMode(mode, animated: animated)
        return self
    }
    
    /// Enables red & yellow lines on the map, indicating there is traffic present on the marked street
    public func displayTraffic(_ showTraffic: Bool = true) -> AppleMap {
        map.showsTraffic = showTraffic
        return self
    }
    
    public func displayUser(_ showLocation: Bool = true) -> AppleMap {
        map.showsUserLocation = showLocation
        return self
    }
    
    /// Enables / Disabled animations in movement of map and camera zoom / pan.
    public func animationsDisabled(_ isDisabled: Bool = true) -> AppleMap {
        animated = !isDisabled
        return self
    }
    
    public func pitchDisabled(_ isDisabled: Bool = true) -> AppleMap {
        map.isPitchEnabled = !isDisabled
        return self
    }
    
    public func zoomDisabled(_ isDisabled: Bool = true) -> AppleMap {
        map.isZoomEnabled = !isDisabled
        return self
    }
    
    public func rotationDisabled(_ isDisabled: Bool = true) -> AppleMap {
        map.isRotateEnabled = !isDisabled
        return self
    }
    
    public func scrollDisabled(_ isDisabled: Bool = true) -> AppleMap {
        map.isScrollEnabled = !isDisabled
        return self
    }
    
    public func displayBuildings(_ showBuildings: Bool = true) -> AppleMap {
        map.showsBuildings = showBuildings
        return self
    }
    
    public func displayCompass(_ showCompass: Bool = true) -> AppleMap {
        map.showsCompass = showCompass
        return self
    }
    
    @available(macOS 11, *)
    public func displayZoomControls(_ showZoomControls: Bool = true) -> AppleMap {
#if os(macOS)
        map.showsZoomControls = showZoomControls
#endif
        return self
    }
    
    public func displayScale(_ showScale: Bool = true) -> AppleMap {
        map.showsScale = showScale
        return self
    }
    
    @available(macOS 11, *)
    public func displayPitchControl(_ showPitchControl: Bool = true) -> AppleMap {
#if os(macOS)
        map.showsPitchControl = showPitchControl
#endif
        return self
    }
    
}

//
//  MapKit_SwiftUI.swift
//
//
//  Created by Lawrence Bensaid on 4/4/22.
//

import SwiftUI
import MapKit

#if os(macOS)
typealias UIView = NSView
typealias UIViewController = NSViewController
typealias UIViewControllerRepresentable = NSViewControllerRepresentable
typealias UIViewControllerRepresentableContext = NSViewControllerRepresentableContext
#endif

struct AppleMap: View {
    
    @State private var animated = true
    @State private var map = MKMapView()
    @State private var context: MapContext
    @Binding private var directions: MapDirections?
    
    init(lat latitude: Double, long longitude: Double, directions: Binding<MapDirections?>? = nil) {
        context = MapContext(latitude: latitude, longitude: longitude)
        if let directions = directions {
            _directions = directions
        } else {
            _directions = Binding<MapDirections?> { return nil } set: { _ in }
        }
    }
    
    var body: some View {
        MapViewAdapter(context, map: map, animated: animated)
            .onChange(of: directions) { directions in
                if let directions = directions {
                    context.startRoute(directions.transportType, from: directions.destination, to: directions.source)
                } else {
                    context.stopRoute()
                }
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

struct MapViewAdapter: UIViewControllerRepresentable {
    
    private let map: MKMapView
    private let context: MapContext
    private var animated: Bool
    
    init(_ context: MapContext, map: MKMapView, animated: Bool) {
        self.context = context
        self.map = map
        self.animated = animated
        
        let cameraCoordinate = CLLocationCoordinate2D(latitude: context.origin.latitude - 0.01, longitude: context.origin.longitude - 0.01)
        let mapCamera = MKMapCamera(lookingAtCenter: context.origin, fromEyeCoordinate: cameraCoordinate, eyeAltitude: 1000)
        
        map.setCamera(mapCamera, animated: animated)
    }
    
#if os(macOS)
    func makeNSViewController(context: NSViewControllerRepresentableContext<MapViewAdapter>) -> MapViewController {
        return MapViewController(self.context, map: map, animated: animated)
    }
    
    func updateNSViewController(_ uiViewController: MapViewController, context: NSViewControllerRepresentableContext<MapViewAdapter>) {
        
    }
#else
    func makeUIViewController(context: UIViewControllerRepresentableContext<MapViewAdapter>) -> MapViewController {
        return MapViewController(self.context, map: map, animated: animated)
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: UIViewControllerRepresentableContext<MapViewAdapter>) {
        
    }
#endif
    
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    private let context: MapContext
    private let map: MKMapView
    private let animated: Bool
    
    private var routeOverlay: MKOverlay?
    
    init(_ context: MapContext, map: MKMapView, animated: Bool = true) {
        self.context = context
        self.map = map
        self.map.translatesAutoresizingMaskIntoConstraints = false
        self.animated = animated
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.addSubview(map)
        
        map.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        map.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        map.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        map.delegate = self
        
        context.onStopRoute {
            if let overlay = self.routeOverlay {
                self.map.removeOverlay(overlay)
            }
        }
        
        context.onStartRoute { transportType, source, destination in
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
            request.transportType = transportType
            
            let directions = MKDirections(request: request)
            
            directions.calculate { response, error in
                
                guard let response = response else {
                    if let error = error {
                        print("Error: \(error)")
                    }
                    
                    return
                }
                
                let route = response.routes[0]
                self.routeOverlay = route.polyline
                if let overlay = self.routeOverlay {
                    self.map.addOverlay(overlay, level: .aboveRoads)
                }
                
                let rect = route.polyline.boundingMapRect.insetBy(dx: -250, dy: -250)
                self.map.setRegion(MKCoordinateRegion(rect), animated: self.animated)
            }
            
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(cgColor: context.overlayColor)
        renderer.lineWidth = CGFloat(context.overlayWidth)
        return renderer
    }
    
}

class MapContext {
    
    public let origin: CLLocationCoordinate2D
    
    public var overlayColor: CGColor = UIColor.systemBlue.cgColor
    public var overlayWidth: Float = 8
    
    private var didStart: ((MKDirectionsTransportType, CLLocationCoordinate2D, CLLocationCoordinate2D) -> ())?
    private var didStop: (() -> ())?
    
    init(latitude: Double, longitude: Double) {
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

struct MapDirections: Equatable {
    
    static func == (lhs: MapDirections, rhs: MapDirections) -> Bool {
        lhs.transportType == rhs.transportType && lhs.source == rhs.source && lhs.destination == rhs.destination
    }
    
    public let transportType: MKDirectionsTransportType
    public let source: CLLocationCoordinate2D
    public let destination: CLLocationCoordinate2D
    
    init(_ transportType: MKDirectionsTransportType, from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        self.transportType = transportType
        self.source = source
        self.destination = destination
    }
    
}

extension CLLocationCoordinate2D: Equatable {
    
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
}

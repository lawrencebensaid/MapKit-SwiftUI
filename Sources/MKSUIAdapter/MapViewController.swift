//
//  MapViewController.swift
//  MKSUIAdapter
//
//  Created by Lawrence Bensaid on 4/5/22.
//

import MapKit

public class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
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
        map.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        view = UIView()
        view.addSubview(map)
        
        map.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: "PinAnnotation")
        map.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "MarkerAnnotation")
        
        map.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        map.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        map.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
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
    
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(cgColor: context.overlayColor)
        renderer.lineWidth = CGFloat(context.overlayWidth)
        return renderer
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomAnnotation else { return nil }
        switch annotation.variant {
        case .pin:
            guard let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "PinAnnotation") as? MKPinAnnotationView else { return nil }
            return annotation.apply(pinView)
        case .marker:
            guard let markerView = mapView.dequeueReusableAnnotationView(withIdentifier: "MarkerAnnotation") as? MKMarkerAnnotationView else { return nil }
            return annotation.apply(markerView)
        }
    }
    
}

#if os(macOS)
typealias UIView = NSView
typealias UIViewController = NSViewController
typealias UIViewControllerRepresentable = NSViewControllerRepresentable
typealias UIViewControllerRepresentableContext = NSViewControllerRepresentableContext
#endif

extension MKMarkerAnnotationView {
    
    func setGlyph(_ image: UIImage) {
        glyphImage = image
    }
    
    func setGlyph(systemName: String) {
        glyphImage = UIImage(systemName: systemName)
    }
    
}

public class CustomAnnotation: MKPointAnnotation {
    
    public enum Variant { case pin, marker }
    
    public let variant: Variant
    
    public var markerTintColor: UIColor?
    public var displayPriority: MKFeatureDisplayPriority?
    public var titleVisibility: MKFeatureVisibility?
    public var glyphImage: UIImage?
    
    public init(_ variant: Variant) {
        self.variant = variant
    }
    
    public func apply(_ annotationView: MKMarkerAnnotationView) -> MKAnnotationView {
        annotationView.annotation = self
        annotationView.markerTintColor = markerTintColor
        if let displayPriority = displayPriority {
            annotationView.displayPriority = displayPriority
        }
        if let titleVisibility = titleVisibility {
            annotationView.titleVisibility = titleVisibility
        }
        annotationView.glyphImage = glyphImage
        return annotationView
    }
    
    public func apply(_ annotationView: MKPinAnnotationView) -> MKAnnotationView {
        annotationView.annotation = self
        annotationView.pinTintColor = markerTintColor
        if let displayPriority = displayPriority {
            annotationView.displayPriority = displayPriority
        }
        return annotationView
    }
    
}

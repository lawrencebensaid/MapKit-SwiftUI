//
//  MapViewAdapter.swift
//  MKSUIAdapter
//
//  Created by Lawrence Bensaid on 4/5/22.
//

import MapKit
import SwiftUI
import MKSUIExtensions

public struct MapViewAdapter: UIViewControllerRepresentable {
    
    private let map: MKMapView
    private let context: MapContext
    private var animated: Bool
    
    public init(_ context: MapContext, map: MKMapView, animated: Bool) {
        self.context = context
        self.map = map
        self.animated = animated
        
        let cameraCoordinate = CLLocationCoordinate2D(latitude: context.origin.latitude - 0.01, longitude: context.origin.longitude - 0.01)
        let mapCamera = MKMapCamera(lookingAtCenter: context.origin, fromEyeCoordinate: cameraCoordinate, eyeAltitude: 1000)
        
        map.setCamera(mapCamera, animated: animated)
    }
    
#if os(macOS)
    public func makeNSViewController(context: NSViewControllerRepresentableContext<MapViewAdapter>) -> MapViewController {
        return MapViewController(self.context, map: map, animated: animated)
    }
    
    public func updateNSViewController(_ uiViewController: MapViewController, context: NSViewControllerRepresentableContext<MapViewAdapter>) {
        
    }
#else
    public func makeUIViewController(context: UIViewControllerRepresentableContext<MapViewAdapter>) -> MapViewController {
        return MapViewController(self.context, map: map, animated: animated)
    }
    
    public func updateUIViewController(_ uiViewController: MapViewController, context: UIViewControllerRepresentableContext<MapViewAdapter>) {
        
    }
#endif
    
}

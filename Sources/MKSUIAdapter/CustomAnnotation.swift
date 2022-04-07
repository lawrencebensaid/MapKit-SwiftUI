//
//  CustomAnnotation.swift
//  MKSUIAdapter
//
//  Created by Lawrence Bensaid on 4/5/22.
//

import MapKit
import MKSUIExtensions

public class CustomAnnotation: MKPointAnnotation {
    
    public enum Variant { case pin, marker }
    
    public let variant: Variant
    public var action: (() -> ())?
    
#if os(iOS)
    public var tintColor: UIColor?
    public var displayPriority: MKFeatureDisplayPriority?
    public var titleVisibility: MKFeatureVisibility?
    public var subtitleVisibility: MKFeatureVisibility?
    public var glyphImage: UIImage?
#endif
    
#if os(macOS)
    public var tintColor: NSColor?
    public var displayPriority: MKFeatureDisplayPriority?
    public var glyphImage: NSImage?
#endif
    
    public init(_ variant: Variant) {
        self.variant = variant
    }
    
    @available(iOS 13, macOS 11.0, *)
    public func apply(_ annotationView: MKMarkerAnnotationView) -> MKAnnotationView {
        annotationView.annotation = self
        annotationView.markerTintColor = tintColor
        if let displayPriority = displayPriority {
            annotationView.displayPriority = displayPriority
        }
#if os(iOS)
        if let titleVisibility = titleVisibility {
            annotationView.titleVisibility = titleVisibility
        }
        if let subtitleVisibility = subtitleVisibility {
            annotationView.subtitleVisibility = subtitleVisibility
        }
#endif
        annotationView.glyphImage = glyphImage
        return annotationView
    }
    
    public func apply(_ annotationView: MKPinAnnotationView) -> MKAnnotationView {
        annotationView.annotation = self
        annotationView.pinTintColor = tintColor
        if let displayPriority = displayPriority {
            annotationView.displayPriority = displayPriority
        }
        return annotationView
    }
    
}

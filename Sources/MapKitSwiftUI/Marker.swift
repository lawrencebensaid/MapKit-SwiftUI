//
//  Marker.swift
//  MapKitSwiftUI
//
//  Created by Lawrence Bensaid on 4/5/22.
//

import MapKit
import MKSUIAdapter
import MKSUIExtensions

@available(iOS 13, macOS 11, *)
public class Marker: AppleMapAnnotation {
    
    public let annotation = CustomAnnotation(.marker)
    
    public required init(lat latitude: Double, long longitude: Double) {
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // MARK: - Modifiers
    
    public func title(_ title: String) -> Marker {
        annotation.title = title
        return self
    }
    
    public func title(_ title: String, subtitle: String?) -> Marker {
        annotation.title = title
        annotation.subtitle = subtitle
        return self
    }
    
#if os(iOS)
    public func color(_ color: UIColor) -> Marker {
        annotation.tintColor = color
        return self
    }
#endif
    
#if os(macOS)
    public func color(_ color: NSColor) -> Marker {
        annotation.tintColor = color
        return self
    }
#endif
    
    public func displayPriority(_ displayPriority: MKFeatureDisplayPriority) -> Marker {
        annotation.displayPriority = displayPriority
        return self
    }
    
#if os(iOS)
    public func titleVisibility(_ titleVisibility: MKFeatureVisibility) -> Marker {
        annotation.titleVisibility = titleVisibility
        return self
    }
    
    public func subtitleVisibility(_ subtitleVisibility: MKFeatureVisibility) -> Marker {
        annotation.subtitleVisibility = subtitleVisibility
        return self
    }
    
    public func glyphImage(systemName: String) -> Marker {
        annotation.glyphImage = UIImage(systemName: systemName)
        return self
    }
#endif
    
#if os(macOS)
    public func glyphImage(systemName: String) -> Marker {
        annotation.glyphImage = NSImage(systemSymbolName: systemName, accessibilityDescription: systemName)
        return self
    }
#endif
    
    public func onTap(perform action: @escaping (() -> ())) -> Marker {
        annotation.action = action
        return self
    }
    
}

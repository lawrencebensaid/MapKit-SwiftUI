//
//  Pin.swift
//  MapKitSwiftUI
//
//  Created by Lawrence Bensaid on 4/5/22.
//

import MapKit
import MKSUIAdapter

public class Pin: AppleMapAnnotation {
    
    public let annotation = CustomAnnotation(.pin)
    
    public required init(lat latitude: Double, long longitude: Double) {
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public func title(_ title: String) -> Pin {
        annotation.title = title
        return self
    }
    
    public func color(_ color: UIColor) -> Pin {
        annotation.tintColor = color
        return self
    }
    
    public func displayPriority(_ displayPriority: MKFeatureDisplayPriority) -> Pin {
        annotation.displayPriority = displayPriority
        return self
    }
    
    public func onTap(perform action: @escaping (() -> ())) -> Pin {
        annotation.action = action
        return self
    }
    
}

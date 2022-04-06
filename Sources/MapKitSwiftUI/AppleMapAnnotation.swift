//
//  AppleMapAnnotation.swift
//  MapKitSwiftUI
//
//  Created by Lawrence Bensaid on 4/5/22.
//

import MapKit
import MKSUIAdapter

public protocol AppleMapAnnotation {
    
    associatedtype ConcreteType
    
    var annotation: CustomAnnotation { get }
    
    init(lat latitude: Double, long longitude: Double)
    
    func title(_ title: String) -> ConcreteType
    
#if os(iOS)
    func color(_ color: UIColor) -> ConcreteType
#endif
    
#if os(macOS)
    func color(_ color: NSColor) -> ConcreteType
#endif
    
    func displayPriority(_ displayPriority: MKFeatureDisplayPriority) -> ConcreteType
    
    func onTap(perform action: @escaping (() -> ())) -> ConcreteType
    
}

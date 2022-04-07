//
//  MKMarkerAnnotationView.swift
//  MKSUIExtensions
//
//  Created by Lawrence Bensaid on 4/7/22.
//

import MapKit

@available(iOS 13, macOS 11, *)
extension MKMarkerAnnotationView {
    
    func setGlyph(_ image: UIImage) {
        glyphImage = image
    }
    
    func setGlyph(systemName: String) {
        glyphImage = UIImage(systemName: systemName)
    }
    
}

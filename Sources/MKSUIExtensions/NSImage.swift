//
//  NSImage.swift
//  MKSUIExtensions
//
//  Created by Lawrence Bensaid on 4/7/22.
//

#if os(macOS)
import AppKit

extension NSImage {
    
    @available(macOS 11, *)
    public convenience init?(systemName: String, accessibilityDescription: String? = nil) {
        self.init(systemSymbolName: systemName, accessibilityDescription: accessibilityDescription)
    }
    
}
#endif

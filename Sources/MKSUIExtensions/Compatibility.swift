//
//  Compatibility.swift
//  MKSUIExtensions
//
//  Created by Lawrence Bensaid on 4/7/22.
//

import SwiftUI

#if os(macOS)

// AppKit
public typealias UIColor = NSColor
public typealias UIImage = NSImage
public typealias UIView = NSView
public typealias UIViewController = NSViewController

// SwiftUI
public typealias UIViewControllerRepresentable = NSViewControllerRepresentable
public typealias UIViewControllerRepresentableContext = NSViewControllerRepresentableContext

#endif

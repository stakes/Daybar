//
//  NSImage+Oval.swift
//  Daybar
//
//  Created by Jay Stakelon on 8/22/20.
//  Copyright © 2020 Jay Stakelon. All rights reserved.
//

import Foundation
import AppKit

extension NSImage {

    /// Copies this image to a new one with a circular mask.
    func oval() -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()

        NSGraphicsContext.current?.imageInterpolation = .high
        let frame = NSRect(origin: .zero, size: size)
        NSBezierPath(ovalIn: frame).addClip()
        draw(at: .zero, from: frame, operation: .sourceOver, fraction: 1)

        image.unlockFocus()
        return image
    }
}

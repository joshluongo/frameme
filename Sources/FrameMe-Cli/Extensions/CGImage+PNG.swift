//
//  CGImage+PNG.swift
//  FrameMe
//
//  Created by Josh Luongo on 13/12/2022.
//

import Foundation
import CoreImage
import ImageIO
import CoreGraphics

public extension CGImage {

    /// Write this CGImage as a PNG file.
    ///
    /// - Parameter destinationURL: Destination file.
    /// - Returns: Did the write work?
    @discardableResult func writeAsPng(_ destinationURL: URL) -> Bool {
        guard let destination = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypePNG, 1, nil) else { return false }
        CGImageDestinationAddImage(destination, self, nil)
        return CGImageDestinationFinalize(destination)
    }

}

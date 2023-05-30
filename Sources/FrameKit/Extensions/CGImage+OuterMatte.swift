//
//  CGImage+OuterMatte.swift
//  FrameKit
//
//  Created by Josh Luongo on 13/12/2022.
//

import Foundation
import CoreGraphics

extension CGImage {

    /// Create an outer matte of the current CGImage.
    ///
    /// - Returns: The image matte or nil.
    public func createOuterMatte() -> CGImage? {
        // Start a context
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let context = CGContext(
            data: nil,
            width: Int(width),
            height: Int(height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: bitmapInfo.rawValue
        )

        if let cfData = dataProvider?.data, let pointer = CFDataGetBytePtr(cfData) {
            // Loop over the Y axis.
            for y in 0..<height {
                var minX: Int?
                var maxX: Int?

                // Loop over the X axis.
                for x in 0..<width {
                    // Get pixel data.
                    let pixelAddress = x * 4 + y * width * 4

                    // Get the address for the pixel then get the 4th byte for the alpha.
                    if pointer.advanced(by: pixelAddress + 3).pointee == UInt8.max {
                        // Not a transparent pixel.

                        // Check the min value first and set if is nil.
                        if minX == nil {
                            minX = x
                        }

                        // This is now the new max!
                        maxX = x
                    }
                }

                // Find the current (y) pos in the graphics context
                let drawCurrY = CGFloat(height) - CGFloat(y)

                // Draw a black background.
                context?.setFillColor(gray: 0.0, alpha: 1.0)
                context?.addRect(CGRect(origin: CGPoint(x: 0, y: drawCurrY), size: CGSize(width: width, height: 1)))
                context?.fillPath()

                // Create a line?
                if let minX = minX, let maxX = maxX {
                    // Draw the white line.
                    context?.setFillColor(gray: 1.0, alpha: 1.0)
                    // Explain:
                    // Starting Point is the minX.
                    // For the width you need to remove the offset of minX value to get the width for the line.
                    context?.addRect(CGRect(origin: CGPoint(x: CGFloat(minX), y: drawCurrY), size: CGSize(width: CGFloat(maxX - minX), height: 1)))
                    context?.fillPath()
                }
            }
        }

        return context?.makeImage()
    }

}

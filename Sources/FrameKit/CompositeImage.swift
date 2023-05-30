//
//  CompositeImage.swift
//  FrameKit
//
//  Created by Josh Luongo on 13/12/2022.
//

import Foundation
import CoreImage
import ImageIO
import CoreGraphics

public class CompositeImage {

    /// Don't do content box finding for screenshot positioning.
    public var skipContentBox = false

    /// Don't clip the screenshot to the device frame.
    public var noClip = false

    public init(skipContentBox: Bool = false, noClip: Bool = false) {
        self.skipContentBox = skipContentBox
        self.noClip = noClip
    }

    /// Create a composite image from a frame and a screenshot.
    ///
    /// - Parameters:
    ///   - frame: Device Frame
    ///   - screenshot: Screenshot
    /// - Returns: Composited Result
    public func create(frame: CGImage, screenshot: CGImage) -> CGImage? {
        // Start a context
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: frame.width, height: frame.height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

        // Should we try and find the screenshot position data?
        let screenshotPosition = skipContentBox ? nil : frame.findContentBox(ref: CGPoint(x: frame.width / 2, y: frame.height / 2))

        // Draw screenshot
        if noClip {
            // Don't use the clipping tool.
            context?.draw(screenshot, in: screenshotPosition ?? CGRect(origin: CGPoint(x: ((frame.width - screenshot.width) / 2), y: ((frame.height - screenshot.height) / 2)), size: CGSize(width: screenshot.width, height: screenshot.height)))
        } else {
            // Clip the screenshot
            context?.draw(self.clipImage(mask: frame, image: screenshot, frame: screenshotPosition)!, in: CGRect(origin: CGPoint.zero, size: CGSize(width: frame.width, height: frame.height)))
        }

        // Draw the device frame.
        context?.draw(frame, in: CGRect(origin: CGPoint.zero, size: CGSize(width: frame.width, height: frame.height)))

        return context?.makeImage()
    }

    /// Clip an image to a mask.
    ///
    /// - Parameters:
    ///   - mask: The mask.
    ///   - image: The image.
    ///   - frame: The frame to use for the screenshot.
    /// - Returns: Clipped image.
    private func clipImage(mask: CGImage, image: CGImage, frame: CGRect? = nil) -> CGImage? {
        // Start a context
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: mask.width, height: mask.height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

        // Create the outer matte.
        if let mask = mask.createOuterMatte() {
            // Apply the matte
            context?.clip(to: CGRect(x: 0, y: 0, width: mask.width, height: mask.height), mask: mask)
        }

        // Draw screenshot.
        context?.draw(image, in: frame ?? CGRect(origin: CGPoint(x: ((mask.width - image.width) / 2), y: ((mask.height - image.height) / 2)), size: CGSize(width: image.width, height: image.height)))

        return context?.makeImage()
    }

}

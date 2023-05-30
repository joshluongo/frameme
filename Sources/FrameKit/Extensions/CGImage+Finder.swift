//
//  CGImage+Finder.swift
//  FrameKit
//
//  Created by Josh Luongo on 14/12/2022.
//

import Foundation
import CoreImage

extension CGImage {

    /// Find a content box from a reference point.
    ///
    /// - Parameter ref: Reference Point
    /// - Returns: CGRect of the position of the content box.
    public func findContentBox(ref: CGPoint) -> CGRect? {
        if let cfData = dataProvider?.data, let pointer = CFDataGetBytePtr(cfData) {
            // Find the preliminary points
            let prelim = XYPosHolder(
                minY: self.findYEdge(pointer: pointer, x: Int(ref.x), startingY: Int(ref.y), negative: true),
                maxY: self.findYEdge(pointer: pointer, x: Int(ref.x), startingY: Int(ref.y), negative: false),
                minX: self.findXEdge(pointer: pointer, y: Int(ref.y), startingX: Int(ref.x), negative: true),
                maxX: self.findXEdge(pointer: pointer, y: Int(ref.y), startingX: Int(ref.x), negative: false)
            )

            // Check for a nil.
            if prelim.minX == nil || prelim.maxX == nil || prelim.minY == nil || prelim.maxY == nil {
                return nil
            }

            // Holder for final values.
            var finalPos = XYPosHolder(minY: prelim.minY, maxY: prelim.maxY, minX: prelim.minX, maxX: prelim.maxX)

            // Find the Min/Max Y by searching the X Axis.
            for x in prelim.minX!..<prelim.maxX! {
                // Check each direction
                guard let yMin = self.findYEdge(pointer: pointer, x: x, startingY: Int(ref.y), negative: true) else {
                    continue
                }
                guard let yMax = self.findYEdge(pointer: pointer, x: x, startingY: Int(ref.y), negative: false) else {
                    continue
                }

                // Update?
                if yMin < finalPos.minY! {
                    // New "north"
                    finalPos.minY = yMin
                }

                // Update?
                if yMax > finalPos.maxY! {
                    // New "south"
                    finalPos.maxY = yMax
                }
            }

            // Find the Min/Max X by searching the Y Axis.
            for y in prelim.minY!..<prelim.maxY! {
                // Check each direction
                guard let xMin = self.findXEdge(pointer: pointer, y: y, startingX: Int(ref.x), negative: true) else {
                    continue
                }
                guard let xMax = self.findXEdge(pointer: pointer, y: y, startingX: Int(ref.x), negative: false) else {
                    continue
                }

                // Update?
                if xMin < finalPos.minX! {
                    // New "west"
                    finalPos.minX = xMin
                }

                // Update?
                if xMax > finalPos.maxX! {
                    // New "east"
                    finalPos.maxX = xMax
                }
            }

            // Create the output CGRect
            let x = finalPos.minX!

            // Negative one as the size is zero based.
            let boxWidth = finalPos.maxX! - finalPos.minX! - 1
            let boxHeight = finalPos.maxY! - finalPos.minY! - 1

            // Flip the Y axis to compensate for macOS being LLO
            let y = height - (finalPos.minY! + boxHeight)

            return CGRect(x: x, y: y, width: boxWidth, height: boxHeight)
        }

        return nil
    }

    /// Find the X edge in a positive direction.
    ///
    /// - Parameters:
    ///   - pointer: Data Pointer
    ///   - y: The Y position
    ///   - xPos: Starting X position
    ///   - negative: Should we flip the direction?
    /// - Returns: The X position of the edge.
    fileprivate func findXEdge(pointer: UnsafePointer<UInt8>, y: Int, startingX xPos: Int, negative: Bool) -> Int? {
        // Create the range for the loop.
        var loopRange = Array(negative ? 0..<xPos : xPos..<width)

        // Flip?
        if negative {
            loopRange = loopRange.reversed()
        }

        for x in loopRange {
            // Get pixel data.
            let pixelAddress = x * 4 + y * width * 4

            // Get the address for the pixel then get the 4th byte for the alpha.
            if pointer.advanced(by: pixelAddress + 3).pointee == UInt8.max {
                // Not a transparent pixel.

                // Found an edge
                return x + 1
            }
        }

        return nil
    }

    /// Find the Y edge in a positive direction.
    ///
    /// - Parameters:
    ///   - pointer: Data Pointer
    ///   - X: The X position
    ///   - yPos: Starting Y position
    ///   - negative: Should we flip the direction?
    /// - Returns: The Y position of the edge.
    fileprivate func findYEdge(pointer: UnsafePointer<UInt8>, x: Int, startingY yPos: Int, negative: Bool) -> Int? {
        // Create the range for the loop.
        var loopRange = Array(negative ? 0..<yPos : yPos..<height)

        // Flip?
        if negative {
            loopRange = loopRange.reversed()
        }

        for y in loopRange {
            // Get pixel data.
            let pixelAddress = x * 4 + y * width * 4

            // Get the address for the pixel then get the 4th byte for the alpha.
            if pointer.advanced(by: pixelAddress + 3).pointee == UInt8.max {
                // Not a transparent pixel.

                // Found an edge
                return y + 1
            }
        }

        return nil
    }

}

struct XYPosHolder {

    var minY: Int?

    var maxY: Int?

    var minX: Int?

    var maxX: Int?

}

//
//  ContentBoxTests.swift
//  FrameMeTests
//
//  Created by Josh Luongo on 13/12/2022.
//

import XCTest
import FrameKit

final class ContentBoxTests: XCTestCase {

    /// Test "file_a".
    func testFileA() throws {
        // Load the test image.
        guard let imagePath = Bundle.module.path(forResource: "Resources/test_a", ofType: "png") else {
            XCTAssertTrue(false, "Failed to find image!")
            return
        }

        guard let image = CGImage.loadImage(filename: imagePath) else {
            XCTAssertTrue(false, "Failed to load image!")
            return
        }

        // Query the content box size.
        let size = image.findContentBox(ref: CGPoint(x: image.width / 2, y: image.height / 2))

        XCTAssertEqual(CGRect(x: 10.0, y: 10.0, width: 80.0, height: 80.0), size)
    }

    /// Test "file_b".
    func testFileB() throws {
        // Load the test image.
        guard let imagePath = Bundle.module.path(forResource: "Resources/test_b", ofType: "png") else {
            XCTAssertTrue(false, "Failed to find image!")
            return
        }

        guard let image = CGImage.loadImage(filename: imagePath) else {
            XCTAssertTrue(false, "Failed to load image!")
            return
        }

        // Query the content box size.
        let size = image.findContentBox(ref: CGPoint(x: image.width / 2, y: image.height / 2))

        XCTAssertEqual(CGRect(x: 10.0, y: 10.0, width: 80.0, height: 80.0), size)
    }

}

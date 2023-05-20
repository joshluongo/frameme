//
//  GenericError.swift
//  FrameMe
//
//  Created by Josh Luongo on 16/12/2022.
//

import Foundation

enum GenericError: Error {
    case failedToLoadFrame
    case failedToLoadImage(String)
    case failedToScanFolder
}

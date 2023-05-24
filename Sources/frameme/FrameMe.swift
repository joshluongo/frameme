//
//  FrameMe.swift
//  FrameMe
//
//  Created by Josh Luongo on 13/12/2022.
//

import Foundation
import CoreImage
import ArgumentParser
import ObjectiveC

@main
struct FrameMe: ParsableCommand {

    /// Command configuration.
    static var configuration = CommandConfiguration(
        commandName: "frameme",
        abstract: "Quickly frame screenshots.",
        version: "1.0.2"
    )

    @Flag(help: "Don't try and find the content box, just overlay the frame on the screenshot.")
    var skipContentBox = false

    @Flag(help: "Don't clip the screenshot to the frame.")
    var noClip = false

    @Flag(help: "Force framing of file/s. By default files ending with '_framed' are skipped.")
    var force = false

    @Option(help: "The output folder. By default framed screenshots are placed in the their original folder.")
    var output: String?

    @Argument(help: "The frame to use.", completion: .file())
    var frame: String

    @Argument(help: "The screenshots to process.")
    var screenshot: [String]

    /// The meat and potatoes.
    mutating func run() throws {
        do {
            // Load the frame.
            guard let frameImage = CGImage.loadImage(filename: frame) else {
                throw GenericError.failedToLoadFrame
            }

            // Load the composite class.
            let compTool = CompositeImage()
            compTool.noClip = noClip
            compTool.skipContentBox = skipContentBox

            // Parse files
            let filesToProcess = parseInputFiles()

            // Parse the output folder if any
            let outputFolder = try parseOutputFolder()

            for file in filesToProcess {
                guard let screenshot = CGImage.loadImage(url: file) else {
                    throw GenericError.failedToLoadImage(file.path)
                }

                Logger.general("> Processing <\(file.path)>")

                // Check if this file is framed screenshot.
                if file.deletingPathExtension().lastPathComponent.hasSuffix("_framed") {
                    if !force {
                        Logger.warning("! Looks like this file is a framed screenshot <\(file.path)>, skipping...")
                        continue
                    }
                }

                // Get the filename.
                let outputFilename = "\(file.deletingPathExtension().lastPathComponent)_framed.png"

                // Create the output URL.
                var outputUrl = outputFolder ?? file.deletingLastPathComponent()
                outputUrl.appendPathComponent(outputFilename)

                // Make it!
                let outputFile = compTool.create(frame: frameImage, screenshot: screenshot)
                if outputFile?.writeAsPng(outputUrl) ?? false {
                    // Worked!
                    Logger.success("> Saved to <\(outputUrl.path)>")
                } else {
                    // Error
                    Logger.error("! Error processing <\(file.path)>")
                }
            }
        } catch let error {
            if let err = error as? GenericError {
                switch err {
                case .failedToLoadFrame:
                    Logger.error("ERROR: Failed to load the frame.")
                case .failedToScanFolder:
                    Logger.error("ERROR: The output specified does not exist or is not a directory.")
                case .failedToLoadImage(let path):
                    Logger.error("ERROR: Failed to load screenshot at <\(path)>")
                }
            } else {
                Logger.error("ERROR: \(error.localizedDescription)")
            }

            throw ExitCode.failure
        }
    }

    /// Parse the input files.
    ///
    /// - Returns: The inputs
    fileprivate func parseInputFiles() -> [URL] {
        return screenshot.map { entry in
            URL(fileURLWithPath: entry)
        }
    }

    /// Parse the output folder.
    ///
    /// - Returns: Output folder URL
    fileprivate func parseOutputFolder() throws -> URL? {
        guard let output = output else {
            return nil
        }

        // Try and parse the URL.
        let parsedUrl = URL(fileURLWithPath: output)

        if !((try parsedUrl.resourceValues(forKeys: [.isDirectoryKey])).isDirectory ?? false) {
            throw GenericError.failedToScanFolder
        }

        return parsedUrl
    }

}

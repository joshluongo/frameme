//
//  String+ANSI.swift
//  
//
//  Created by Josh Luongo on 19/5/2023.
//

import Foundation

private struct Colours {
    static let reset = "\u{001B}[0;0m"
    static let red = "\u{001B}[0;31m"
    static let green = "\u{001B}[0;32m"

    static let redBold = "\u{001B}[1;31m"
    static let greenBold = "\u{001B}[1;32m"
}

extension String {

    /// Convert this to a red ansi string
    var ansiRed: String {
        return Colours.red + self + Colours.reset
    }

    /// Convert this to a green ansi string
    var ansiGreen: String {
        return Colours.green + self + Colours.reset
    }

    /// Convert this to a red bold ansi string
    var ansiBoldRed: String {
        return Colours.redBold + self + Colours.reset
    }

    /// Convert this to a green bold ansi string
    var ansiBoldGreen: String {
        return Colours.greenBold + self + Colours.reset
    }

}

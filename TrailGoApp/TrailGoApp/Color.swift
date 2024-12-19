//
//  Color.swift
//  TrailGoApp
//
//  Created by stud on 10/12/2024.
//


import SwiftUI

extension Color {
    // Initialize a Color from a hex string
    init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        
        // Ensure it's a valid hex string
        var hexInt: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&hexInt)
        
        let red = Double((hexInt & 0xFF0000) >> 16) / 255.0
        let green = Double((hexInt & 0x00FF00) >> 8) / 255.0
        let blue = Double(hexInt & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

//
//  Trail.swift
//  TrailGoApp
//
//  Created by stud on 17/12/2024.
//

import SwiftUI
import Foundation

// Data Model for Trail
struct Trail: Identifiable,Hashable, Codable {
    let id = UUID()
    let name: [String: String]
    let imageName: String
    let startingCity: String
    let endingCity: String
    let startCoordinate: Coordinates // coordinates of start and end
    let endCoordinate: Coordinates
    let colorHex: String
    let distance: Int
    let elevation: Int
    let description: [String: String]
    let isHike: Bool
    let isBike: Bool
    let photos: [String]
    
    
    struct Coordinates: Hashable, Codable {
            var latitude: Double
            var longitude: Double
    }
}


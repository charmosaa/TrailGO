//
//  Trail.swift
//  TrailGoApp
//
//  Created by stud on 17/12/2024.
//

import SwiftUI

// Data Model for Trail
struct Trail: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let distance: String
    let description: String
}

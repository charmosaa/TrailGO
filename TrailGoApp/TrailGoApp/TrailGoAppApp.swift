//
//  TrailGoAppApp.swift
//  TrailGoApp
//
//  Created by stud on 29/10/2024.
//

import SwiftUI
import Firebase

@main
struct TrailGoAppApp: App {
    init() {
            FirebaseApp.configure()
        }
    var body: some Scene {
        WindowGroup {
            FirstPage()
        }                            
    }
}

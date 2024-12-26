//
//  GalleryView.swift
//  TrailGoApp
//
//  Created by Martyna Lopianiak on 26/12/2024.
//

import SwiftUI

struct GalleryView: View {
    let photos: [String]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(photos, id: \.self) { photo in
                    Image(photo)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipped()
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

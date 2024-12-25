//
//  TrailDetailView.swift
//  TrailGoApp
//
//  Created by stud on 17/12/2024.
//

import SwiftUI


struct TrailDetailView: View {
    let trail: Trail
    @ObservedObject var languageManager: LanguageManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Trail Title and Language Toggle
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(trail.name[languageManager.selectedLanguage] ?? trail.name["en"]!)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            HStack {
                                Text("Trudność:")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                ForEach(0..<5) { _ in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(Color(hex: "#108932"))
                                }
                            }
                            
                            HStack {
                                Text("Ocena:")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                ForEach(0..<5) { _ in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(Color(hex: "#108932"))
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Image Carousel (placeholder for images)
                    ZStack {
                        Image(trail.imageName) // Replace with real image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                        HStack {
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    .cornerRadius(10)
                    .padding(.horizontal)
                    Rectangle()
                        .fill(Color(hex: trail.colorHex))
                        .frame(height: 15)
                        .cornerRadius(3)
                    
                    VStack {
                        // Route Info
                        HStack(spacing: 16) {
                            HStack {
                                HStack {
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color(hex: "#108932"))
                                    Text(trail.startingCity)
                                        .font(.subheadline)
                                }
                                Spacer()
                                HStack {
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(.gray)
                                    Text(trail.endingCity)
                                        .font(.subheadline)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        
                        Text("\(trail.distance)km")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack {
                            HStack {
                                Image(systemName: "arrow.up.right")
                                    .foregroundColor(Color(hex: "#108932"))
                                Text("\(trail.elevation) m")
                                    .font(.subheadline)
                            }
                            Spacer()
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(Color(hex: "#108932"))
                                Text("20 dni 5h") // You can replace this with dynamic data later
                                    .font(.subheadline)
                            }
                        }
                        .padding(.horizontal)
                    }
                    Divider()
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text(trail.description[languageManager.selectedLanguage] ?? trail.description["en"]!)
                            .font(.body)
                        
                        Text("Ukończony przez: 1234 osoby")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        
                        Text(
                            trail.isHike && trail.isBike ? "Typ: Piesza, Rowerowa" :
                                (trail.isHike ? "Typ: Piesza" :
                                    (trail.isBike ? "Typ: Rowerowa" : "Typ: Nieznany")))
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                    
                    // Buttons
                    HStack(spacing: 20) {
                        Button(action: {
                            // Add to Plan Action
                        }) {
                            HStack {
                                Image(systemName: "star")
                                Text("W planach")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(Color(hex: "#108932"))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: "#108932"), lineWidth: 2)
                            )
                        }
                        
                        Button(action: {
                            // Mark as Complete Action
                        }) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Ukończony")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#108932"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
    }
}

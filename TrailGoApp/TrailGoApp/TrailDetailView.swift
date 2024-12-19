//
//  TrailDetailView.swift
//  TrailGoApp
//
//  Created by stud on 17/12/2024.
//

import SwiftUI

struct TrailDetailView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Trail Title and Language Toggle
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Główny Szlak Sudecki")
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
                        Image("trail-placeholder") // Replace with real image
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
                        .fill(Color(.red))
                        .frame(height: 15)
                        .cornerRadius(3)
                    
                    VStack{
                        // Route Info
                        HStack(spacing: 16) {
                            HStack {
                                HStack {
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color(hex: "#108932"))
                                    Text("Świeradów - Zdrój")
                                        .font(.subheadline)
                                }
                                Spacer()
                                HStack {
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(.gray)
                                    Text("Prudnik")
                                        .font(.subheadline)
                                }
                            }
                            
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        
                        Text("422km")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack {
                            HStack {
                                Image(systemName: "arrow.up.right")
                                    .foregroundColor(Color(hex: "#108932"))
                                Text("14 181 m")
                                    .font(.subheadline)
                            }
                            Spacer()
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(Color(hex: "#108932"))
                                Text("20 dni 5h")
                                    .font(.subheadline)
                            }
                        }
                        .padding(.horizontal)
                    }
                    Divider()
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Główny Szlak Sudecki to młodszy brat Głównego Szlaku Beskidzkiego (GSB). Krótszy i mniej uczęszczany czeka jeszcze na odkrycie przez wielu turystów. Chcesz być jedną z osób, które w tym roku dotrą do czerwonej kropki w Świeradowie Zdrój lub Prudniku?")
                            .font(.body)
                        
                        Text("Ukończony przez: 1234 osoby")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        
                        Text("Typ trasy: Piesza")
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

// MARK: - Preview
struct TrailDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TrailDetailView()
    }
}

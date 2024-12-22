//
//  TrailsListView.swift
//  TrailGoApp
//
//  Created by stud on 17/12/2024.
//

import SwiftUI
import Foundation

func loadTrails() -> [Trail] {
    guard let url = Bundle.main.url(forResource: "trails", withExtension: "json") else {
        fatalError("Nie znaleziono pliku trails.json!")
    }
    do {
        let data = try Data(contentsOf: url)
        let trails = try JSONDecoder().decode([Trail].self, from: data)
        return trails
    } catch {
        fatalError("Błąd ładowania danych z JSON-a: \(error)")
    }
}


struct TrailsListView: View {
    // Sample trail data
    let trails = loadTrails()
    
    var body: some View {
        NavigationView {
            VStack {
                // Title Header
                Text("Your Trails")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                // Toggle Buttons (To Do / Completed)
                HStack {
                    Button("To Do") {
                        // Add logic for "To Do"
                    }
                    .padding()
                    .background(Color(hex: "#108932"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("Completed") {
                        // Add logic for "Completed"
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                
                // Trails List
                List(trails) { trail in
                    NavigationLink(destination: TrailDetailView(trail: trail)) {
                        HStack {
                            // Trail Image
                            Image(trail.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                            
                            // Trail Name
                            Text(trail.name)
                                .font(.headline)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}

struct TrailsListView_Previews: PreviewProvider {
    static var previews: some View {
        TrailsListView()
    }
}


//
//  TrailsListView.swift
//  TrailGoApp
//
//  Created by stud on 17/12/2024.
//

import SwiftUI

struct TrailsListView: View {
    // Sample trail data
    let trails: [Trail] = [
        Trail(name: "Main Sudets Trail", imageName: "trail1", distance: "422 km", description: "Beautiful Sudets trail description."),
        Trail(name: "Via Regia", imageName: "trail2", distance: "320 km", description: "Historic trail of Via Regia."),
        Trail(name: "Main Beskid Trail", imageName: "trail3", distance: "517 km", description: "Longest mountain trail."),
        Trail(name: "Baltic Seaside Trail", imageName: "trail4", distance: "240 km", description: "Scenic seaside trail.")
    ]
    
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
                    NavigationLink(destination: TrailDetailView()) {
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


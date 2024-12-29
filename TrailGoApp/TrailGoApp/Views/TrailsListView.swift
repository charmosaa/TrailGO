import SwiftUI
import Foundation

struct TrailsListView: View {
    @StateObject var languageManager: LanguageManager
    var trails: [Trail]
    
    @State private var searchText: String = ""
    @State private var showHike: Bool = false
    @State private var showBike: Bool = false
    @State private var maxDistance: Double = 2000.0
    
    var filteredTrails: [Trail] {
        let searchedTrails = searchText.isEmpty ? trails : trails.filter { $0.name[languageManager.selectedLanguage]?.lowercased().contains(searchText.lowercased()) ?? false }
        
        let typeFilteredTrails: [Trail]
        if showHike && showBike {
            typeFilteredTrails = searchedTrails
        } else if showHike {
            typeFilteredTrails = searchedTrails.filter { $0.isHike }
        } else if showBike {
            typeFilteredTrails = searchedTrails.filter { $0.isBike }
        } else {
            typeFilteredTrails = searchedTrails
        }

        return typeFilteredTrails.filter { $0.distance <= Int(maxDistance) }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Your Trails")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .padding(.bottom,2)
                
                Rectangle()
                    .foregroundColor(Color(hex: "#108932"))
                    .frame(height: 10)
                    .cornerRadius(20)
                    .padding(.bottom,10)
                    .padding(.horizontal, 90)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading)
                    TextField("Search", text: $searchText)
                        .padding(7)
                        .padding(.horizontal, 10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "#108932"), lineWidth: 2)
                        )
                        .padding(.trailing,10)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(5)
                
                Divider()
                
                HStack {
                    Button("Hike") {
                        showHike.toggle()
                    }
                    .padding(.vertical,7)
                    .padding(.horizontal)
                    .background(showHike ? Color(hex: "#108932"): Color.gray.opacity(0.2))
                    .foregroundColor(showHike ? .white : .black)
                    .cornerRadius(8)
                    .frame(height: 20)
                    
                    Button("Bike") {
                        showBike.toggle()
                    }
                    .padding(.vertical,7)
                    .padding(.horizontal)
                    .background(showBike ? Color(hex: "#108932") : Color.gray.opacity(0.2))
                    .foregroundColor(showBike ? .white : .black)
                    .cornerRadius(8)
                }
                
                Divider()
                
                VStack {
                    HStack {
                        Text(String(format: NSLocalizedString("max_distance_label", comment: "Label for the maximum distance slider"), Int(maxDistance)))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    Slider(value: $maxDistance, in: 0...2000, step: 1)
                        .accentColor(Color(hex: "#108932"))
                        .padding(.horizontal)
                }
                .padding(.vertical, 5)

                List(filteredTrails) { trail in
                    NavigationLink(destination: TrailDetailView(trail: trail, languageManager: languageManager)) {
                        HStack {
                            Image(trail.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)

                            Text(trail.name[languageManager.selectedLanguage] ?? trail.name["en"]!)
                                .font(.headline)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}

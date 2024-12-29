import SwiftUI
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published var location: CLLocation?

    override init() {
        super.init()
    }

}

struct ContentView: View {
    @StateObject var languageManager: LanguageManager
    @State private var searchText: String = ""
   
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.1079, longitude: 17.0385), // Wrocław default
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    var trails: [Trail]

    var filteredTrails: [Trail] {
        let searchedTrails = searchText.isEmpty ? trails : trails.filter { $0.name[languageManager.selectedLanguage]?.lowercased().contains(searchText.lowercased()) ?? false }
        return searchedTrails
    }

    var body: some View {
        VStack {
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
            
            // Map displaying trails
            MapLine(trails: filteredTrails, languageManager: languageManager)
                .edgesIgnoringSafeArea(.all)
        }

    }
}

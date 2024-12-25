import SwiftUI
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()

    @Published var location: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

struct ContentView: View {
    @StateObject var languageManager: LanguageManager
    let trails = loadTrails()
    
    @State private var searchText: String = ""
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.1079, longitude: 17.0385), // Wrocław domyślnie
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    var filteredTrails: [Trail] {
        
        let searchedTrails = searchText.isEmpty ? trails : trails.filter { $0.name["en"]?.lowercased().contains(searchText.lowercased()) ?? false }
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
            MapLine(trails: filteredTrails, languageManager: languageManager)
            .edgesIgnoringSafeArea(.all)
        }
        .onChange(of: locationManager.location) { newLocation in
            if let location = newLocation {
                region.center = location.coordinate
            }
        }
    }
}



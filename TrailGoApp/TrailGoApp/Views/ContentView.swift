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
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.1079, longitude: 17.0385), // Wrocław domyślnie
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    let line1: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 50.8997, longitude: 15.3642),  // Świeradów Zdrój
        CLLocationCoordinate2D(latitude: 50.3282, longitude: 17.2855)   // Prudnik
    ]
    
    let line2: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 51.1079, longitude: 17.0385),  // Wrocław
        CLLocationCoordinate2D(latitude: 50.6756, longitude: 17.9213)   // Opole
    ]
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: .constant(""))
                    .padding(7)
                    .padding(.horizontal, 10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(7)

            // MapView z aktualizowaną lokalizacją
            MapLine(linesData: [
                MapLineData(coordinates: line1, color: .blue),
                MapLineData(coordinates: line2, color: .red)
            ])
            .edgesIgnoringSafeArea(.all)
        }
        .onChange(of: locationManager.location) { newLocation in
            if let location = newLocation {
                // Aktualizowanie regionu mapy na podstawie lokalizacji użytkownika
                region.center = location.coordinate
            }
        }
    }
}

#Preview {
    ContentView()
}

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
    let trails = loadTrails()
    
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.1079, longitude: 17.0385), // Wrocław domyślnie
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

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

            MapLine(trails: trails)
            .edgesIgnoringSafeArea(.all)
        }
        .onChange(of: locationManager.location) { newLocation in
            if let location = newLocation {
                region.center = location.coordinate
            }
        }
    }
}

#Preview {
    ContentView()
}

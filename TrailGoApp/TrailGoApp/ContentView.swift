//
//  ContentView.swift
//  TrailGoApp
//
//  Created by stud on 29/10/2024.
//

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
    @State private var searchText = ""
    var body: some View {
        VStack{
            HStack {
                Image(systemName: "magnifyingglass") // Search Icon
                TextField("Search", text: $searchText)
                                        .padding(7)
                                        .padding(.horizontal, 10)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                        .padding(.horizontal)
            } .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(7)
            Map(initialPosition: .region(region))
        }
        
    }
    
    
    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center:locationManager.location?.coordinate ??  CLLocationCoordinate2D(latitude: 50.703349, longitude: 18.09020),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    }

  
}
#Preview {
    ContentView()
}

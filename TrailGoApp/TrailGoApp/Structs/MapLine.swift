import SwiftUI
import MapKit
import CoreLocation

// Struktura reprezentująca pojedynczą linię z jej współrzędnymi i kolorem
struct MapLineData {
    let coordinates: [CLLocationCoordinate2D]  // Współrzędne linii
    let color: UIColor  // Kolor linii
}

// MapViewWithPolylines to handle multiple MKPolylines with different colors
struct MapLine: UIViewRepresentable {
    let linesData: [MapLineData]  // Tablica struktur MapLineData
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true // Pokazuje lokalizację użytkownika na mapie
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Usuwamy poprzednie poliliny
        uiView.removeOverlays(uiView.overlays)
        
        // Tworzymy słownik, w którym przechowujemy przypisane kolory
        for lineData in linesData {
            let polyline = MKPolyline(coordinates: lineData.coordinates, count: lineData.coordinates.count)
            context.coordinator.polylineColorMap[polyline] = lineData.color
            uiView.addOverlay(polyline, level: .aboveRoads)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        // Słownik przechowujący mapowanie polilinii do kolorów
        var polylineColorMap = [MKPolyline: UIColor]()
        
        // Funkcja do renderowania overlay (polilinii) z odpowiednim kolorem
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                // Tworzymy renderer i przypisujemy kolor z mapy
                let renderer = MKPolylineRenderer(polyline: polyline)
                if let color = polylineColorMap[polyline] {
                    renderer.strokeColor = color  // Ustawiamy kolor z mapy
                }
                renderer.lineWidth = 3.0
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

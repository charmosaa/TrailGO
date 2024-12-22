import SwiftUI
import MapKit
import CoreLocation

// Struktura reprezentująca pojedynczą linię z jej współrzędnymi, kolorem oraz nazwą
struct MapLineData {
    let coordinates: [CLLocationCoordinate2D]  // Współrzędne linii
    let color: UIColor  // Kolor linii
    let name: String    // Nazwa linii
    let imageName: String  // Nazwa pliku z obrazkiem (obrazek w assets)
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
        // Usuwamy poprzednie poliliny i anotacje
        uiView.removeOverlays(uiView.overlays)
        uiView.removeAnnotations(uiView.annotations)
        
        // Tworzymy słownik, w którym przechowujemy przypisane kolory
        for lineData in linesData {
            let polyline = MKPolyline(coordinates: lineData.coordinates, count: lineData.coordinates.count)
            context.coordinator.polylineColorMap[polyline] = lineData.color
            uiView.addOverlay(polyline, level: .aboveRoads)
            
            // Obliczamy środek linii i dodajemy anotację
            let centerCoordinate = centerOfPolyline(lineData.coordinates)
            let annotation = LineAnnotation(coordinate: centerCoordinate, title: lineData.name, imageName: lineData.imageName)
            uiView.addAnnotation(annotation)
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
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let lineAnnotation = annotation as? LineAnnotation {
                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "LineAnnotation")
                annotationView.canShowCallout = false
                
                // Ładujemy obrazek z assets na podstawie jego nazwy
                if let image = UIImage(named: lineAnnotation.imageName) {
                    let imageView = UIImageView(image: image)
                    
                    let newSize = CGSize(width: 50, height: 50)
                    imageView.frame = CGRect(origin: .zero, size: newSize)
                    
                   
                    
                    // Dodajemy napis (nazwę linii) pod obrazkiem
                    let label = UILabel()
                    label.text = lineAnnotation.title
                    label.font = UIFont.systemFont(ofSize: 12)
                    label.textColor = .black
                    label.sizeToFit()
                    
                    let contSize = CGSize(width: 60, height: 60)
                    let containerView = UIStackView()
                    containerView.axis = .vertical
                    containerView.alignment = .center
                    containerView.spacing = 8
                    containerView.backgroundColor = .white
                    containerView.frame = CGRect(origin: .zero, size: contSize)
                    containerView.addArrangedSubview(imageView)
                    containerView.addArrangedSubview(label)
                  
                    annotationView.addSubview(containerView)
                    annotationView.frame = CGRect(x: 0, y: 0, width: 60, height: 80)
                }
                
                return annotationView
            }
            return nil
        }
    }
    
    // Funkcja do obliczania środka polilinii
    func centerOfPolyline(_ coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        var latSum = 0.0
        var lonSum = 0.0
        for coordinate in coordinates {
            latSum += coordinate.latitude
            lonSum += coordinate.longitude
        }
        let count = Double(coordinates.count)
        return CLLocationCoordinate2D(latitude: latSum / count, longitude: lonSum / count)
    }
}

// Niestandardowa anotacja
class LineAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var imageName: String  // Zmieniamy nazwę właściwości na imageName
    
    init(coordinate: CLLocationCoordinate2D, title: String, imageName: String) {
        self.coordinate = coordinate
        self.title = title
        self.imageName = imageName
    }
}

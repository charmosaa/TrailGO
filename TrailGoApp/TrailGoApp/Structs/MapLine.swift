import SwiftUI
import MapKit
import CoreLocation

import UIKit

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized
        
        guard hexSanitized.count == 6 else { return nil }
        
        let scanner = Scanner(string: hexSanitized)
        var rgb: UInt64 = 0
        
        guard scanner.scanHexInt64(&rgb) else { return nil }
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}


struct MapLine: UIViewRepresentable {
    let trails: [Trail] 
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        for trail in trails {
            let coordinates = [
                CLLocationCoordinate2D(latitude: trail.startCoordinate.latitude, longitude: trail.startCoordinate.longitude),
                CLLocationCoordinate2D(latitude: trail.endCoordinate.latitude, longitude: trail.endCoordinate.longitude)
            ]
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            context.coordinator.polylineColorMap[polyline] = UIColor(hex: trail.colorHex)
            uiView.addOverlay(polyline, level: .aboveRoads)
            
            let centerCoordinate = centerOfPolyline(coordinates)
            let annotation = LineAnnotation(coordinate: centerCoordinate, title: trail.name, imageName: trail.imageName)
            uiView.addAnnotation(annotation)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var polylineColorMap = [MKPolyline: UIColor]()
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                if let color = polylineColorMap[polyline] {
                    renderer.strokeColor = color
                }
                renderer.lineWidth = 5.0
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let lineAnnotation = annotation as? LineAnnotation {
                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "LineAnnotation")
                annotationView.canShowCallout = false
                
                if let image = UIImage(named: lineAnnotation.imageName) {
                    let imageView = UIImageView(image: image)
                    let newSize = CGSize(width: 40, height: 40)
                    imageView.frame = CGRect(origin: .zero, size: newSize)
                    
                    let label = UILabel()
                    label.text = lineAnnotation.title
                    label.font = UIFont.boldSystemFont(ofSize: 12)
                    label.textColor = .black
                    label.numberOfLines = 2
                    label.textAlignment = .center
                    label.lineBreakMode = .byWordWrapping
                    
                    let containerView = UIStackView()
                    containerView.axis = .vertical
                    containerView.alignment = .center
                    containerView.spacing = 6
                    containerView.frame = CGRect(x: 0, y: 0, width: 80, height: 90)
                    containerView.backgroundColor = .white
                    
                    // Dodajemy obrazek i etykietę do kontenera
                    containerView.addArrangedSubview(imageView)
                    containerView.addArrangedSubview(label)
                    
                    annotationView.addSubview(containerView)
                }
                
                return annotationView
            }
            return nil
        }
    }
    
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

class LineAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var imageName: String
    
    init(coordinate: CLLocationCoordinate2D, title: String, imageName: String) {
        self.coordinate = coordinate
        self.title = title
        self.imageName = imageName
    }
}

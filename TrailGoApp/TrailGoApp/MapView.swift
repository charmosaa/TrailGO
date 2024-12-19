import UIKit
import MapKit

class MapView: UIViewController {

    var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the map view
        mapView = MKMapView(frame: self.view.frame)
        self.view.addSubview(mapView)

        // Set the map's delegate
        mapView.delegate = self

        // Example coordinates for your route
        let coordinates = [
            CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // San Francisco
            CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)  // Los Angeles
        ]

        drawRoute(coordinates: coordinates)
    }

    // Draw the route
    func drawRoute(coordinates: [CLLocationCoordinate2D]) {
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        fitRouteOnMap(polyline: polyline)
    }

    // Fit the map to show the route
    func fitRouteOnMap(polyline: MKPolyline) {
        let region = MKCoordinateRegion(polyline.boundingMapRect)
        mapView.setRegion(region, animated: true)
    }
}

extension MapView: MKMapViewDelegate {

    // Render the polyline overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .red
            renderer.lineWidth = 5.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

#Preview {
    MapView()
}

//
//  MapView.swift
//  Lepus
//
//  Created by Tan Ming Zhe on 11/1/22.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {

    let region: MKCoordinateRegion
    let lineCoordinates: [CLLocationCoordinate2D]
    

  func makeUIView(context: Context) -> MKMapView {
      //needs the frame for trackingmode to work
    let mapView = MKMapView(frame: UIScreen.main.bounds)
    mapView.delegate = context.coordinator
    mapView.region = region
    mapView.showsUserLocation = true
    mapView.userTrackingMode = .follow
    let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
    
    mapView.addOverlay(polyline)

    return mapView
  }

    
  func updateUIView(_ view: MKMapView, context: Context) {
      view.removeOverlays(view.overlays)
      let polylines = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
      view.addOverlay(polylines)
      print(lineCoordinates.count)
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

}

class Coordinator: NSObject, MKMapViewDelegate {
  var parent: MapView

  init(_ parent: MapView) {
    self.parent = parent
  }

  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if let routePolyline = overlay as? MKPolyline {
      let renderer = MKPolylineRenderer(polyline: routePolyline)
        renderer.strokeColor = UIColor.systemYellow
      renderer.lineWidth = 6
      return renderer
    }
    return MKOverlayRenderer()
  }
}

class LocationManager: NSObject, ObservableObject{
    private let locationManager = CLLocationManager()

    @Published var location:CLLocation = CLLocation()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
}

extension LocationManager : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{ return }
        
        self.location = location
        print("\(location.coordinate.latitude)")

    }
}


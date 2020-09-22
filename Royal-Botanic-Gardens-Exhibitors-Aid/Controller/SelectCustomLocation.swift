//
//  SelectCustomLocation.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 21/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit
import MapKit

/// helps to send location coordinate to the create exhibition view controller
protocol SelectLocationDelegate {
    func addLocation(coordinate: CLLocation)
}

/// helps to create new location
class SelectCustomLocation: UIViewController {
    
    var locationDelegate: SelectLocationDelegate?


    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationAdd: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        

        centerViewOnUserLocation()
    }
    
    /// centers to the Royal botanical Garden
    func centerViewOnUserLocation() {
        let coordinate: CLLocationCoordinate2D =  CLLocationCoordinate2D(latitude:  -37.831004, longitude: 144.978660)
        let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        mapView.setRegion(region, animated: true)
    }
    
    /// helps to get the cordinate
    /// returns: coordinate
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    /// custom location selected
    @IBAction func locationSelected(_ sender: Any) {
        let coordinate = getCenterLocation(for: mapView)
        
        locationDelegate?.addLocation(coordinate: coordinate)
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
}

extension SelectCustomLocation: MKMapViewDelegate {
}

//
//  MapViewController.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 6/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

/// Home screen controller, contains maps
class MapViewController: UIViewController, DatabaseListener {
    
    var locationList = [LocationAnnotation]()
    var exhibitions: [Exhibition] = []
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .exhibition
    
    /// helps to transfer data into the Exhibition Details screen.
    var selectedAnnotation: LocationAnnotation?
    
    var locationManager = CLLocationManager()


    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self

        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController

        // Register location annotation, Because i am not using (_:viewFor:)
        mapView.register(ExhibitionMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)



        
        
        /// to make sure that the navbar large text has more than one line, if not wrap the words
        centerViewOnUserLocation()
        checkLocationServices()
        
        
        

    }
    
    /// Loads locations with respect to displaying in the table view.
    /// - Parameter exhibitions: Temporary exhibitions to show, depending on search results or all exhibitions before searching any.
    func loadLocation(exhibitions: [Exhibition]) {
        
        // to make sure that locations are not not duplicated
        locationList.removeAll()
        
        for item in exhibitions {
            let location = LocationAnnotation(title: item.name ?? "No name", subtitle: item.desc ?? "No description", lat: item.exhibitionLat, lon: item.exhibitionLon, imageIcon: item.icon ?? " ", storeExhibition: item)
            locationList.append(location)
            mapView.addAnnotation(location)
        }
        
    }

    /// helps to focus on the annotation
    func focusOn(annotation: MKAnnotation, regionInMeters: Double) {
        mapView.selectAnnotation(annotation, animated: true)
        
        
        let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        
        mapView.setRegion(zoomRegion, animated: true)
        
        
    }
    
    func centerViewOnUserLocation() {
        let coordinate: CLLocationCoordinate2D =  CLLocationCoordinate2D(latitude:  -37.831004, longitude: 144.978660)
        let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        mapView.setRegion(region, animated: true)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        databaseController?.addListener(listener: self)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func onExhibitionPlantsChange(change: DatabaseChange, exhibitionPlants: [Plant]) {
        //
    }
    
    func onPlantListChange(change: DatabaseChange, plants: [Plant]) {
        //
    }
    
    func onExhibitionChange(change: DatabaseChange, exhibitions: [Exhibition]) {
        self.exhibitions = exhibitions
        loadLocation(exhibitions: self.exhibitions)
    }
    

    /// https://www.youtube.com/watch?v=WPpaAy73nJc
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // you dont have your location service enebled, user doesnot know why? make sure to let them know what is happening
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // show alert letting them know
            break
        case .denied:
            // show alert them how to turn on the permissions
            break
        case .authorizedAlways:
            mapView.showsUserLocation = true
//            centerViewOnUserLocation()
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
//            centerViewOnUserLocation()
            break
        @unknown default:
            break
        }
    }
    

}

// https://www.raywenderlich.com/7738344-mapkit-tutorial-getting-started#toc-anchor-001
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.selectedAnnotation = view.annotation as? LocationAnnotation
        
        let viewController = storyboard?.instantiateViewController(identifier: "exhibitionDetailsVC") as! ExhibitionDetailsViewController
        viewController.exhibition = selectedAnnotation?.storeExhibition
        viewController.locationAnnotation = selectedAnnotation
        
        /// Making navigation bar appear large text
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .largeTitle) ]

        guard let subView = (self.navigationController?.navigationBar.subviews) else {
            return
        }
        
        for navItem in subView {
             for itemSubView in navItem.subviews {
                 if let largeLabel = itemSubView as? UILabel {
                     largeLabel.text = self.title
                     largeLabel.numberOfLines = 0
                     largeLabel.lineBreakMode = .byWordWrapping
                 }
             }
        }

        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    


}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //
    }
    
    
}


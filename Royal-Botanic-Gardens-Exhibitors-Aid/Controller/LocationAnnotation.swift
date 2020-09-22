//
//  LocationAnnotation.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 6/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit
import MapKit

/// Mapview location annotation class, where details of the annotation is stored
class LocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var imageIcon: String?
    var storeExhibition: Exhibition?

    init(title: String, subtitle: String, lat: Double, lon: Double, imageIcon: String, storeExhibition: Exhibition) {
        self.title = title
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.subtitle = subtitle
        self.imageIcon = imageIcon
        self.storeExhibition = storeExhibition
    }
    
    /// saves differnet color for each annotation
    var iconTintColor: UIColor  {
      switch imageIcon {
      case "bamboo":
        return .red
      case "forest":
        return .brown
      case "herbs":
        return .blue
      case "spearmint":
        return .black
      case "lily":
        return .blue
      case "leaf":
        return .gray
      case "palm":
        return .darkGray
      case "trees":
        return .link
      case "rose":
        return .magenta
      default:
        return .orange
      }
    }
    
    /// saves different image icon for each annotation
    var image: UIImage {
      guard let name = imageIcon else { return #imageLiteral(resourceName: "imageLoad") }
      
      switch name {
      case "bamboo":
        return #imageLiteral(resourceName: "bamboo")
      case "forest":
        return #imageLiteral(resourceName: "forest")
      case "herbs":
        return #imageLiteral(resourceName: "herbs")
      case "spearmint":
        return #imageLiteral(resourceName: "spearmint")
      case "lily":
        return #imageLiteral(resourceName: "lily")
      case "leaf":
        return #imageLiteral(resourceName: "leaf")
      case "palm":
        return #imageLiteral(resourceName: "palm")
      case "trees":
        return #imageLiteral(resourceName: "trees")
      case "rose":
        return #imageLiteral(resourceName: "rose")
      default:
        return #imageLiteral(resourceName: "imageLoad")
      }
    }
    

}

/// class to help create annotation marker, color and callout disclosure
class ExhibitionMarkerView: MKMarkerAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
        guard let annotation = newValue as? LocationAnnotation else {
            return
        }

        canShowCallout = true
        rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

        
        markerTintColor = annotation.iconTintColor
        glyphImage = annotation.image
    }
  }
}



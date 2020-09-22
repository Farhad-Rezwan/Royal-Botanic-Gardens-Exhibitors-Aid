//
//  Icon.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 22/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import Foundation
import UIKit


/// icon class helps to show name, color, and show picture
class Icon {
    var imageIconName: String
    
    init(imageIconName: String) {
        self.imageIconName = imageIconName
    }
    
    
    var iconTintColor: UIColor  {
      switch imageIconName {
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
    
    var image: UIImage {
      switch imageIconName {
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

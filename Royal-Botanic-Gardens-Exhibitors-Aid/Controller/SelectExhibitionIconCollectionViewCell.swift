//
//  SelectExhibitionIconCollectionViewCell.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 22/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit

/// Cell for exhibition Icon
class SelectExhibitionIconCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String = "iconCollectionViewCell"
    @IBOutlet weak var collectionViewCellView: UIView!
    @IBOutlet weak var collectionViewCellImage: UIImageView!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    
    /// to make sure that the cell is not selected randomly
    override var isSelected: Bool{
        willSet{
            super.isSelected = newValue
            if newValue
            {
                self.layer.borderWidth = 1.0
                self.layer.cornerRadius = self.bounds.height / 2
                self.layer.borderColor = UIColor.gray.cgColor
            }
            else
            {
                self.layer.borderWidth = 0.0
                self.layer.cornerRadius = 0.0
            }
        }
    }
}

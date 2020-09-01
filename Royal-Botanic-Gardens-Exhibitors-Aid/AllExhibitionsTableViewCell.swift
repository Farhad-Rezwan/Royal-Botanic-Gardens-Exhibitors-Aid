//
//  AllExhibitionsTableViewCell.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 22/8/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit

class AllExhibitionsTableViewCell: UITableViewCell {
    @IBOutlet weak var exhibitionCellIconLabel: UILabel!
    @IBOutlet weak var exhibitionCellNameLabel: UILabel!
    @IBOutlet weak var exhibitionCellDescriptionLabel: UILabel!
    

    func setupExhibition(exhibition: Exhibition) {
        
        exhibitionCellIconLabel.text = exhibition.name
        exhibitionCellNameLabel.text = exhibition.icon
        exhibitionCellDescriptionLabel.text = exhibition.description
        
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  SelectExhibitionIconViewController.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 22/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit

/// to transfer icon information to the create exhibition view controller
protocol SelectIconDelegate {
    func addIcon(icon: Icon)
}

/// Helps to get icon for the new exhibition
class SelectExhibitionIconViewController: UIViewController {
    
    var selectedIndexPath: IndexPath?
    
    var delegate: SelectIconDelegate?
    
    @IBOutlet weak var addIconButtonDesign: UIButton!
    @IBOutlet weak var iconCollectionView: UICollectionView!
    var icons = [Icon]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDefaultIcons()
        
        /// designing the screens
        iconCollectionView.dataSource = self
        iconCollectionView.delegate = self
        iconCollectionView.layer.cornerRadius = 10
        iconCollectionView.layer.borderWidth = 1.0
        iconCollectionView.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        addIconButtonDesign.layer.cornerRadius = 10
        addIconButtonDesign.layer.borderWidth = 1.0
        addIconButtonDesign.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        
    }
    
    /// Create default icons for the users selection
    func createDefaultIcons() {
        icons.append(contentsOf: [Icon(imageIconName: "bamboo"), Icon(imageIconName: "forest"), Icon(imageIconName: "herbs"), Icon(imageIconName: "spearmint"), Icon(imageIconName: "lily"), Icon(imageIconName: "leaf"), Icon(imageIconName: "palm"), Icon(imageIconName: "trees"), Icon(imageIconName: "rose")])
    }
    
    @IBAction func addIconButton(_ sender: Any) {
        
        /// making sure that one icon is selected
        if selectedIndexPath != nil{
            delegate?.addIcon(icon: icons[selectedIndexPath!.row])

            self.navigationController?.popViewController(animated: true)
            return
        }
        
        /// Corresponding error message if any icon is not selected
        var errorMessage = ""
        
        if selectedIndexPath == nil {
            errorMessage += "-plese select an icon\n"
        }

        displayMessage(title: "Must select an Exhibition Icon", message: errorMessage)
    }
    
    /// Displays error message as alert
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: message of the alert
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
}


/// Collection view to help exhibition icon selection
extension SelectExhibitionIconViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectExhibitionIconCollectionViewCell else { return }
        redraw(selectedCell: cell)
        selectedIndexPath = indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectExhibitionIconCollectionViewCell else { return }
                redraw(deselectedCell: cell)
                selectedIndexPath = nil
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCollectionViewCell", for: indexPath) as! SelectExhibitionIconCollectionViewCell
        
        cell.collectionViewCellImage.image = icons[indexPath.row].image
        cell.collectionViewCellView.backgroundColor = icons[indexPath.row].iconTintColor
        
        return cell
    }
    
    /// makes boarder if the cell is selected
    /// - Parameter cell: collection view cell
    private func redraw(selectedCell cell: SelectExhibitionIconCollectionViewCell
            ) {
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = cell.bounds.height / 2
        cell.layer.borderColor = UIColor.systemGroupedBackground.cgColor
    }

    /// removes boarder if the cell is selected
    /// - Parameter cell: collection view cell
    private func redraw(deselectedCell cell: SelectExhibitionIconCollectionViewCell) {
        cell.layer.borderWidth = 0.0
        cell.layer.cornerRadius = 0.0

    }
    
    /// reference for both method: https://stackoverflow.com/questions/44205550/select-only-one-item-in-uicollectionviewcontroller
    
}

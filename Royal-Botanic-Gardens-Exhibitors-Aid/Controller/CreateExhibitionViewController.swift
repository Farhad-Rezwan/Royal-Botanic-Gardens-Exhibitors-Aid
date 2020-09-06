//
//  CreateExhibitionViewController.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 6/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit

class CreateExhibitionViewController: UIViewController {

    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var exhibitionNameTextField: UITextField!
    @IBOutlet weak var exhibitionDescriptionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController

        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectLocationAction(_ sender: Any) {
    }
    
    @IBAction func selectIconAction(_ sender: Any) {
    }
    @IBAction func createExhibitionButton(_ sender: Any) {
        if exhibitionNameTextField.text != "" && exhibitionDescriptionTextView.text != "" {
            let name = exhibitionNameTextField.text!
            let description = exhibitionDescriptionTextView.text!

            let _ = databaseController?.addExhibition(name: name, desc: description, exhibitionLat: 10.0010, exhibitionLon: 10.2034, icon: "A")
            
            
            navigationController?.popViewController(animated: true)
            return
        }
        var errorMessage = "Please ensure all fields are filled: \n"
        
        if exhibitionNameTextField.text == "" {
            errorMessage += "-must provide name\n"
        }
        
        if exhibitionDescriptionTextView.text == "" {
            errorMessage += "-must provide description"
        }
        
        displayMessage(title: "Not all fields filled", message: errorMessage)
        
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

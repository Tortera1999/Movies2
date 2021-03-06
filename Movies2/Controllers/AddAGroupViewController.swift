//
//  AddAGroupViewController.swift
//  Movies2
//
//  Created by Nikhil Iyer on 8/3/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import Firebase

class AddAGroupViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var groupOverview: UITextField!
    @IBOutlet weak var publicOrPrivateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleTap))
//        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addAGroup(_ sender: Any) {
        if(groupName.text != "" && groupOverview.text != ""){
        var index = 0
        index = publicOrPrivateSegmentedControl.selectedSegmentIndex
        
        if(index == 0){
            DataService2.instance.writeAGroupToFirebase(publicOrNot: true, passwordForPrivate: "", name: groupName.text!, groupInfo: groupOverview.text!)
        } else{
            DataService2.instance.writeAGroupToFirebase(publicOrNot: false, passwordForPrivate: "pass", name: groupName.text!, groupInfo: groupOverview.text!)
        }
        
        self.dismiss(animated: true, completion: nil)
        }
        else{
            let alertController = UIAlertController(title: "Error", message: "Please enter all fields", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    

}

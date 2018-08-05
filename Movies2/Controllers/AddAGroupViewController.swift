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

    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var groupOverview: UITextField!
    @IBOutlet weak var publicOrPrivateSegmentedControl: UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addAGroup(_ sender: Any) {
        var index = 0
        index = publicOrPrivateSegmentedControl.selectedSegmentIndex
        
        if(index == 0){
            DataService2.instance.writeAGroupToFirebase(publicOrNot: true, passwordForPrivate: "", name: groupName.text!, groupInfo: groupOverview.text!)
        } else{
            DataService2.instance.writeAGroupToFirebase(publicOrNot: false, passwordForPrivate: "pass", name: groupName.text!, groupInfo: groupOverview.text!)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    

}

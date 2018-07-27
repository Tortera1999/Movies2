//
//  AddFriendViewController.swift
//  Movies2
//
//  Created by Nikhil Iyer on 7/27/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import FirebaseAuth

class AddFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var listOfFriends : [String] = []
    var listOfFriendsUID : [String] = []
    
    var editedListOfFriends : [String] = []
    var editedListOfFriendsUID : [String] = []

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var listOfFriendsTB: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listOfFriendsTB.delegate = self
        listOfFriendsTB.dataSource = self
        
        DataService.instance.getEmails { (returnedFriendsArray, returnedUIDArray) in
            self.listOfFriends = returnedFriendsArray
            self.listOfFriendsUID = returnedUIDArray
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchFriends(_ sender: Any) {
        for item in listOfFriendsUID{
            if(item != (Auth.auth().currentUser?.uid)!){
                let index = listOfFriendsUID.index(of: item)
                if(listOfFriends[index!].contains(emailTextField.text!)){
                    editedListOfFriends.append(listOfFriends[index!])
                    editedListOfFriendsUID.append(item)
                }
            }
        }
        listOfFriendsTB.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editedListOfFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listOfFriendsTB.dequeueReusableCell(withIdentifier: "AddFriendTableViewCell", for: indexPath) as! AddFriendTableViewCell
        cell.emailLabel.text = editedListOfFriends[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DataService.instance.addFriends(email: editedListOfFriends[indexPath.row], uid: editedListOfFriendsUID[indexPath.row])
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

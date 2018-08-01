//
//  AddFriendViewController.swift
//  Movies2
//
//  Created by Nikhil Iyer on 7/27/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import FirebaseAuth

class AddFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource ,UITextFieldDelegate {
    
    var listOfFriends : [String] = []
    var listOfFriendsUID : [String] = []
    var friendsArray: [String] = []
    
    var editedListOfFriends : [String] = []
    var editedListOfFriendsUID : [String] = []

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var listOfFriendsTB: UITableView!
    @IBOutlet weak var myFriendsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listOfFriendsTB.delegate = self
        listOfFriendsTB.dataSource = self
        emailTextField.delegate = self
        myFriendsTableView.dataSource = self
        myFriendsTableView.delegate  = self
        
        
        DataService.instance.getEmails { (returnedFriendsArray, returnedUIDArray) in
            self.listOfFriends = returnedFriendsArray
            self.listOfFriendsUID = returnedUIDArray
        }
        DataService.instance.getFriendsOfCurrUser { (returnedArray, returnedArrayUID) in
            self.friendsArray = returnedArray
            self.myFriendsTableView.reloadData()
        }
        emailTextField.addTarget(self, action: #selector(searchFriends), for: .editingChanged)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        DataService.instance.getEmails { (returnedFriendsArray, returnedUIDArray) in
            self.listOfFriends = returnedFriendsArray
            self.listOfFriendsUID = returnedUIDArray
        }
        DataService.instance.getFriendsOfCurrUser { (returnedArray, returnedArrayUID) in
            self.friendsArray = returnedArray
            self.myFriendsTableView.reloadData()
    
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func searchFriends() {
    
        editedListOfFriends = []
        editedListOfFriendsUID = []
        
        DataService.instance.getEmails { (returnedFriendsArray, returnedUIDArray) in
            self.listOfFriends = returnedFriendsArray
            self.listOfFriendsUID = returnedUIDArray
        }
        
        for item in listOfFriendsUID{
            if(item != (Auth.auth().currentUser?.uid)!){
                let index = listOfFriendsUID.index(of: item)
                if((listOfFriends[index!].contains(emailTextField.text!) && !self.friendsArray.contains(listOfFriends[index!]))){
                    editedListOfFriends.append(listOfFriends[index!])
                    editedListOfFriendsUID.append(item)
                }
            }
        }
        listOfFriendsTB.reloadData()
        myFriendsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.listOfFriendsTB){
        return editedListOfFriends.count
        }
        else{
            return friendsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == self.listOfFriendsTB){
        let cell = listOfFriendsTB.dequeueReusableCell(withIdentifier: "AddFriendTableViewCell", for: indexPath) as! AddFriendTableViewCell
        cell.emailLabel.text = editedListOfFriends[indexPath.row]
        return cell
        }else{
            let cell = myFriendsTableView.dequeueReusableCell(withIdentifier: "MyFriendsCell") as! MyFriendsCell
            cell.configureCell(email: friendsArray[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == self.listOfFriendsTB){
        DataService.instance.addFriends(email: editedListOfFriends[indexPath.row], uid: editedListOfFriendsUID[indexPath.row])
            DataService.instance.getFriendsOfCurrUser { (returnedArray, returnedArrayUID) in
                self.friendsArray = returnedArray
                self.myFriendsTableView.reloadData()
                self.emailTextField.text = ""
                self.searchFriends()
            }
        }else{
            
        }
    }
    

}

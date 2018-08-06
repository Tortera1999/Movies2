//
//  ChatViewController.swift
//  Movies2
//
//  Created by Nikhil Iyer on 8/3/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import Firebase

let DB_BASE3 = Database.database().reference()

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    var REF_BASE3 = DB_BASE3

    var id : String = ""
    var publicOrNot = true
    
    var sendTheName = ""
    
  
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTF: UITextField!
    @IBOutlet weak var addFriendsButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 84
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if(AppDelegate.popSendButtonAction == 0){
            REF_BASE3.child("Groups").child("Public").child(AppDelegate.group.groupName!).child("Messages").observe(.childAdded) { (snap) in
                self.messageUpdate()
            }
        }
        else{
            REF_BASE3.child("Groups").child("Private").child(AppDelegate.group.groupName!).child("Messages").observe(.childAdded) { (snap) in
                self.messageUpdate()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        
        if(AppDelegate.popSendButtonAction == 0){
            addFriendsButton.isHidden = true
            publicOrNot = true
        } else{
            addFriendsButton.isHidden = false
            publicOrNot = false
        }
        
        
        DataService2.instance.getMessagesForASpecificGroup(publicOrNot: AppDelegate.group.publicOrNot!, name: AppDelegate.group.groupName!, idIfPrivate: AppDelegate.group.groupId!) { (messages1) in
            DataService2.instance.messages = messages1
            
        }
       
        
    }
    
    

    @objc func messageUpdate(){
        DataService2.instance.getMessagesForASpecificGroup(publicOrNot: AppDelegate.group.publicOrNot!, name: AppDelegate.group.groupName!, idIfPrivate: AppDelegate.group.groupId!) { (messages1) in
            DataService2.instance.messages = messages1
            
        }
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addAFriend(_ sender: Any) {
        AppDelegate.popSendButtonAction = 1
        let  popvc = self.storyboard?.instantiateViewController(withIdentifier: "PopOverReccVC")
        self.present(popvc!, animated: true, completion: nil)
    }
    
    
    @IBAction func sendMessageAction(_ sender: Any) {
        DataService2.instance.writeMessageToGroup(publicOrNot: AppDelegate.group.publicOrNot!, name: AppDelegate.group.groupName!, message: messageTF.text!, idIfPrivate: AppDelegate.group.groupId!)
        
       messageUpdate()
        messageTF.text = ""
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //TableView functions

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService2.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        cell.configureCell(content: DataService2.instance.messages[indexPath.row].message!)
        if(DataService2.instance.messages[indexPath.row].sender == Auth.auth().currentUser?.uid){
            cell.tvLeadingconstraint.constant = view.frame.width/3
        }
        else {
            cell.tvTrailingconstraint.constant = view.frame.width/3
        }
        return cell
    }
    

    
    


}

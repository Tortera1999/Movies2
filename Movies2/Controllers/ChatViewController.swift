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
    
    var messages: [Message] = []

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
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

      
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
        
        
       messageUpdate()
        
        
    }
    
   

    @objc func messageUpdate(){
        DataService2.instance.getMessagesForASpecificGroup(publicOrNot: AppDelegate.group.publicOrNot!, name: AppDelegate.group.groupName!, idIfPrivate: AppDelegate.group.groupId!) { (messages1) in
            self.messages = messages1.sorted(by: {$0.time! < $1.time!})
            self.tableView.reloadData()
           
        }
        
        
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
        
        messageTF.text = ""
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //TableView functions

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        cell.configureCell(content: messages[indexPath.row].message!)
        if(messages[indexPath.row].sender == Auth.auth().currentUser?.uid){
            cell.tvLeadingconstraint.constant = view.frame.width/3
            cell.tvTrailingconstraint.constant =  5
        }
        else {
            cell.tvTrailingconstraint.constant = view.frame.width/3
            cell.tvLeadingconstraint.constant = 5
        }
        return cell
    }
    

    
    


}

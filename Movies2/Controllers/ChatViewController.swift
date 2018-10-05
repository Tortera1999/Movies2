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
   
    var mainVote = 0
  
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
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
        
        self.titleLabel.text = AppDelegate.group.groupName!
        
        
        if(AppDelegate.popSendButtonAction == 0){
            addFriendsButton.isHidden = true
            publicOrNot = true
        } else{
            addFriendsButton.isHidden = false
            publicOrNot = false
        }
        view.bindToKeyboard()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.handleTap))
        view.addGestureRecognizer(tap)
        
       messageUpdate()
        
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
    
    @objc func messageUpdate(){
        DataService2.instance.getMessagesForASpecificGroup(publicOrNot: AppDelegate.group.publicOrNot!, name: AppDelegate.group.groupName!, idIfPrivate: AppDelegate.group.groupId!) { (messages1) in
            self.messages = messages1.sorted(by: {$0.time! < $1.time!})
            
            print(self.messages)
            self.tableView.reloadData()
           
        }
        

        self.tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addAFriend(_ sender: Any) {
        AppDelegate.popSendButtonAction = 1
        let  popvc = self.storyboard?.instantiateViewController(withIdentifier: "PopOverReccVC") as! PopOverReccVC
        self.present(popvc, animated: true, completion: nil)
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
    
    @objc func upvoteFunc(sender : chatButton){
        let cell = sender.superview?.superview as! ChatCell
        if(AppDelegate.popSendButtonAction == 0){
            DataService2.instance.vote(isUpvote: true, groupName: AppDelegate.group.groupName!, isPublic: true, messageID: messages[sender.tag].id!) { (votes) in
                self.messages[sender.tag].favCount = votes
                self.messages[sender.tag].isUpvoted = true
                self.tableView.reloadData()
                print("\nvotes: \(votes)\n")
//                cell.upvoteButton.isHidden = true
//                cell.downvoteButton.isHidden = false
                return
            }
        }
        else{
            print(AppDelegate.group.groupName!)
            DataService2.instance.vote(isUpvote: true, groupName: AppDelegate.group.groupName!, isPublic: false, messageID: messages[sender.tag].id!) { (votes) in
                self.messages[sender.tag].favCount = votes
                self.messages[sender.tag].isUpvoted = true
                self.tableView.reloadData()
//                cell.upvoteButton.isHidden = true
//                cell.downvoteButton.isHidden = false
                print("\nvotes: \(votes)\n")
                return
            }
        }
        
        
    }
    
    @objc func downvoteFunc(sender : chatButton){
        let cell = sender.superview?.superview as! ChatCell
        if(AppDelegate.popSendButtonAction == 0){
            DataService2.instance.vote(isUpvote: false, groupName: AppDelegate.group.groupName!, isPublic: true, messageID: messages[sender.tag].id!) { (votes) in
                self.messages[sender.tag].favCount = votes
                self.messages[sender.tag].isUpvoted = false
                self.tableView.reloadData()
//                cell.upvoteButton.isHidden = false
//                cell.downvoteButton.isHidden = true
                print("\nvotes: \(votes)\n")
                
            }
        }
        else{
            print("I am here??????")
            DataService2.instance.vote(isUpvote: false, groupName: AppDelegate.group.groupName!, isPublic: false, messageID: messages[sender.tag].id!) { (votes) in
                self.messages[sender.tag].favCount = votes
                self.messages[sender.tag].isUpvoted = false
                self.tableView.reloadData()
//                cell.upvoteButton.isHidden = false
//                cell.downvoteButton.isHidden = true
                print("\nvotes: \(votes)\n")
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        cell.configureCell(content: messages[indexPath.row].message!)
        cell.textView.clipsToBounds = true
        cell.textView.layer.cornerRadius = 5
      
        cell.upvoteButton.tag = indexPath.row
        cell.downvoteButton.tag = indexPath.row
        
        
        
        if(messages[indexPath.row].isUpvoted != nil){
        if(messages[indexPath.row].isUpvoted!){
            cell.upvoteButton.isHidden = true
            cell.downvoteButton.isHidden = false
        } else{
            cell.upvoteButton.isHidden = false
            cell.downvoteButton.isHidden = true
            
        }
        }
        
        cell.favoriteCountLabel.text = String(messages[indexPath.row].favCount!)
        
        
        //self.id = messages[indexPath.row].id!
        
//        cell.upvoteButton.messsage = messages[indexPath.row]
//        cell.downvoteButton.messsage = messages[indexPath.row]
        
        
        
        
        cell.upvoteButton.addTarget(self, action: #selector(ChatViewController.upvoteFunc), for: UIControlEvents.touchUpInside)
        cell.downvoteButton.addTarget(self, action: #selector(ChatViewController.downvoteFunc), for: UIControlEvents.touchUpInside)
        
        if(messages[indexPath.row].sender == Auth.auth().currentUser?.uid){
            cell.tvLeadingconstraint.constant = view.frame.width/3
            cell.tvTrailingconstraint.constant =  5
            cell.textView.backgroundColor = UIColor(red: 0/255, green: 170/255, blue: 221/255, alpha: 1.0)
            
        }
        else {
            cell.tvTrailingconstraint.constant = view.frame.width/3
            cell.tvLeadingconstraint.constant = 5
        }
        return cell
    }
    

    
    


}

//
//  ChatViewController.swift
//  Movies2
//
//  Created by Nikhil Iyer on 8/3/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
   

    var id : String = ""
    var publicOrNot = true
    var messages: [Message] = []
    var sendTheName = ""
    
  
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTF: UITextField!
    @IBOutlet weak var addFriendsButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 84
        tableView.rowHeight = UITableViewAutomaticDimension
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
            self.messages = messages1
            print("The messasges are:")
            print(self.messages)
        }
        // Do any additional setup after loading the view.
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
        return cell
    }
    

    
    


}

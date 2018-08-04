//
//  ChatViewController.swift
//  Movies2
//
//  Created by Nikhil Iyer on 8/3/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    var id : String = ""
    var publicOrNot = true
    var messages: [Message] = []
    var sendTheName = ""
    
    @IBOutlet weak var messageTF: UITextField!
    @IBOutlet weak var addFriendsButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        print(id)
        
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

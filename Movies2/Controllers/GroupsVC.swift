//
//  GroupsVC.swift
//  Movies2
//
//  Created by Sehajbir Randhawa on 8/3/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit

class GroupsVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var publicOrPrivateSegment: UISegmentedControl!
    
    @IBOutlet weak var groupsTB: UITableView!
    
    var groupsArray : [Group] = []
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupsTB.delegate = self
        groupsTB.dataSource = self

        DataService2.instance.getAllPublicGroups { (groupArray) in
            self.groupsArray = groupArray
            self.groupsTB.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func PublicOrPrivatefunc(_ sender: Any) {
        if publicOrPrivateSegment.selectedSegmentIndex == 0 {
            DataService2.instance.getAllPublicGroups { (groupArray) in
                self.groupsArray = groupArray
                self.groupsTB.reloadData()
            }
        } else{
            DataService2.instance.getAllUserPrivateGroups(handler: { (groupArray) in
                self.groupsArray = groupArray
                self.groupsTB.reloadData()
            })
        }
    }
    
    @IBAction func addAGroupAction(_ sender: Any) {
        self.performSegue(withIdentifier: "addAGroupSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell", for: indexPath) as! GroupTableViewCell
        cell.groupNameLabel.text = groupsArray[indexPath.row].groupName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "chatSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "chatSegue"){
            let vc = segue.destination as! ChatViewController
            index = (self.groupsTB.indexPathForSelectedRow?.row)!
            vc.id = groupsArray[index].groupId!
            AppDelegate.group = groupsArray[index]
            if(publicOrPrivateSegment.selectedSegmentIndex == 0){
                AppDelegate.popSendButtonAction = 0
            } else{
                AppDelegate.popSendButtonAction = 1
            }
            
        }
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

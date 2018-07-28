//
//  PopOverReccVC.swift
//  Movies2
//
//  Created by Sehajbir Randhawa on 7/29/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit

class PopOverReccVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
   
    //Outlets
    
    @IBOutlet weak var viewOut: UIView!
    @IBOutlet weak var tableView: UITableView!
   
    
    var friendsArray: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       tableView.delegate = self
        tableView.dataSource = self
        
        DataService.instance.getFriendsOfCurrUser { (returnedArray) in
            self.friendsArray = returnedArray
            DataService.instance.recommendArray = self.friendsArray
            self.tableView.reloadData()
        }
       
    }

    func addTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnView))
        tap.delegate = self
        viewOut.addGestureRecognizer(tap)
    
    }
    
    @objc func tapOnView(){
        self.friendsArray = []
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        DataService.instance.writeRecommendationsToFirebase(recommendArray: DataService.instance.recommendArray, movie: DataService.instance.chosenMovie!)
        self.friendsArray = []
        dismiss(animated: true, completion: nil)
    }
    
    
//TableView functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PopOverReccCell") as? PopOverReccCell{
            cell.cellConfigure(email: friendsArray[indexPath.row])
            return cell
        }
        return PopOverReccCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
   


}

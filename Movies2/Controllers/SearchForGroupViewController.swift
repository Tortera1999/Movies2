//
//  SearchForGroupViewController.swift
//  Movies2
//
//  Created by Nikhil Iyer on 8/8/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit

class SearchForGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
   
    @IBOutlet weak var searchTF: InsetTextField!
    @IBOutlet weak var groupTB: UITableView!
    
    var groups : [Group] = []
    var groupsCopy : [Group] = []
    
    var spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groupTB.delegate = self
        groupTB.dataSource = self
        
        DataService2.instance.getAllPublicGroups { (group) in
            self.groups = group
            self.groupsCopy = self.groups
            self.groupTB.reloadData()
        }
        
        searchTF.addTarget(self, action: #selector(goBtnPressed), for: .editingChanged)
        
        
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleTap))
//        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
//    @objc func handleTap(){
//        view.endEditing(true)
//    }
    @IBAction func dismissTheController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
     @objc func goBtnPressed() {
        
        print("in the editing tf func")
        addSpinner()
        var g : [Group] = []
        
        if(searchTF.text! != ""){
            print("in the editing tf func")
            for item in groupsCopy{
                if(item.groupName!.contains(searchTF.text!)){
                    g.append(item)
                }
            }
            groups = g
        } else{
            groups = groupsCopy
        }
        
        self.groupTB.reloadData()
        removeSpinner()
        
        
    }

    func addSpinner(){
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: (UIScreen.main.bounds.width/2) - ((spinner?.frame.width)!/2), y: 150)
        spinner?.activityIndicatorViewStyle = .whiteLarge
        spinner?.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        spinner?.startAnimating()
        groupTB?.addSubview(spinner!)
        
    }
    
    func removeSpinner(){
        if(spinner != nil){
            spinner?.removeFromSuperview()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchForGroupTableViewCell", for: indexPath) as! SearchForGroupTableViewCell
        cell.GroupNameLabel.text = groups[indexPath.row].groupName!
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DataService2.instance.subscribeToPublicGroup(group: groups[indexPath.row])
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

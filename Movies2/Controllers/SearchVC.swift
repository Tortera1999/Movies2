//
//  SearchVC.swift
//  Movies2
//
//  Created by Sehajbir Randhawa on 7/23/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {
    
    //Outlets
    @IBOutlet weak var textField: InsetTextField!
    @IBOutlet weak var tableView: UITableView!
    var spinner: UIActivityIndicatorView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        textField.delegate = self
        tableView.dataSource  = self
        tableView.delegate = self
        
        textField.addTarget(self, action: #selector(goBtnPressed), for: .editingChanged)
        
    }
    
    
    
    func addSpinner(){
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: (UIScreen.main.bounds.width/2) - ((spinner?.frame.width)!/2), y: 150)
        spinner?.activityIndicatorViewStyle = .whiteLarge
        spinner?.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        spinner?.startAnimating()
        tableView?.addSubview(spinner!)
        
    }
    
    func removeSpinner(){
        if(spinner != nil){
            spinner?.removeFromSuperview()
        }
    }
    
    
    @objc func goBtnPressed() {
        addSpinner()
        
        DataService.instance.downloadDataBasedOnGenre(completion: { (success) in
            if(success){
                    self.removeSpinner()
                    print("\(DataService.instance.movies)")
                    self.tableView.reloadData()
            }
        }, genreID: -1, keyword: textField.text!)
        
       self.removeSpinner()
    }
    
   
    
    
    //TableView functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       //return DataService.instance.searches.count
       return DataService.instance.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchTableViewCell{
            let data = DataService.instance.movies[indexPath.row]
            cell.movie = data
            return cell
        }
        return UITableViewCell()
    }
    
    

    
}

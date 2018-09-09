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
    var index: Int?
    
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
        
        DataService.instance.downloadDataBasedOnGenre(completion: { (movie) in
            if(movie != nil){
                    self.removeSpinner()
                    self.tableView.reloadData()
            }
        }, genreID: -1, keyword: textField.text!)
        
       self.removeSpinner()
    }
    
   
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        self.performSegue(withIdentifier: "SVCtoDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SVCtoDetailSegue"){
            if let vc = segue.destination as? DetailViewController{
                vc.movie = DataService.instance.movies[index!]
            }
        }
    }
    

    
}

//
//  ProfileVC.swift
//  Movies2
//
//  Created by Sehajbir Randhawa on 7/27/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SwiftyUUID
import AlamofireImage
import Alamofire


class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    //Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var myListTableView: UITableView!
    
    var moviesArray: [Movie] = []
    
    var ref: DatabaseReference!
    var pref: StorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        pref = Storage.storage().reference()
        
        
        myListTableView.delegate = self
        myListTableView.dataSource = self
        DataService.instance.getMovieList { (returnedMovieArray) in
            self.moviesArray = returnedMovieArray
            self.myListTableView.reloadData()
        }
        
        profileImage.isUserInteractionEnabled = false
        
        userName.text = Auth.auth().currentUser?.email
        
        if let photoUrl = Auth.auth().currentUser?.photoURL {
            profileImage.af_setImage(withURL: photoUrl)
        }
        
       
    }
    
    @IBAction func editProfile(_ sender: Any) {
        profileImage.isUserInteractionEnabled = true
    }
    
    @IBAction func changePic(_ sender: UITapGestureRecognizer) {
        
        print("Here in the profile pic change")
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
//
//        let size = CGSize(width: 288, height: 288)
//        let newImage = resize(image: editedImage, newSize: size)
        
        profileImage.image = originalImage
        
        profileImage.isUserInteractionEnabled = false
        let uploadData = UIImagePNGRepresentation(originalImage)
        
        let uuid = SwiftyUUID.UUID()
        
        let uuidString = uuid.CanonicalString()
        
        pref.child(uuidString).putData(uploadData!, metadata: nil) { (metadata, error) in
            if let error = error {
                print(error)
                picker.dismiss(animated: true, completion: nil)
                return
            } else{
                DispatchQueue.main.async {
                    let imageUrl = metadata?.downloadURL()?.absoluteString
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.photoURL = URL(string: imageUrl!)
                    changeRequest?.commitChanges(completion: { (error) in
                        if let error = error{
                            print(error)
                            picker.dismiss(animated: true, completion: nil)
                            return
                        } else{
                            let values = ["profilePic" : imageUrl!] as [String: Any]
                            self.ref.child("Users").child((Auth.auth().currentUser?.uid)!).child("Profile Details").setValue(values)
                            picker.dismiss(animated: true, completion: nil)
                        }
                    })
                }
                
            }
            
        }
        
        
    }
    
    
    
    //TableView functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = myListTableView.dequeueReusableCell(withIdentifier: "ListCell") as? ListCell{
            cell.configureCell(movieImageUrl: moviesArray[indexPath.row].poster!, movieTitle: moviesArray[indexPath.row].movieTitle!, releaseDate: moviesArray[indexPath.row].releaseDate!)
            
            return cell
        }
        return ListCell()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let recommend = UITableViewRowAction(style: .normal, title: "Recommend") { action, index in
            DataService.instance.chosenMovie = self.moviesArray[indexPath.row]
           let  popvc = self.storyboard?.instantiateViewController(withIdentifier: "PopOverReccVC")
            self.present(popvc!, animated: true, completion: nil)
                    }
        recommend.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.168627451, blue: 0.1960784314, alpha: 1)
        
    
        
        return [recommend]
    }
    
   

  

}

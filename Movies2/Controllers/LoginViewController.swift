//
//  LoginViewController.swift
//  Movies2
//
//  Created by Nikhil Iyer on 7/23/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn(_ sender: Any) {
        //self.performSegue(withIdentifier: "loginSegue", sender: self)
        
        if(emailTextField.text != "" && passwordTextField.text != "")
        {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if let error = error {
                    let alertController = UIAlertController(title: "Error", message: "Could not sign in. Please make sure your email and password are correct", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                else{
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            })
        }
        else{
            let alertController = UIAlertController(title: "Error", message: "Please enter username or password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in

            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }

    }
    @IBAction func register(_ sender: Any) {
        if(emailTextField.text! == ""){
            let alertController = UIAlertController(title: "Error", message: "Please enter an email address", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else if(passwordTextField.text! == ""){
            let alertController = UIAlertController(title: "Error", message: "Please enter a password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else{
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if let error = error{
                    print(error)
                    let alertController = UIAlertController(title: "Error", message: "Cannot register user", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                        
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                } else{
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            })
        }
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

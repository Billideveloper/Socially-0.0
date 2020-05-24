//
//  SignUpViewController.swift
//  SStories
//
//  Created by Ravi Thakur on 04/04/20.
//  Copyright © 2020 Ravi Thakur. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import  Firebase
import ProgressHUD

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var useremail: UITextField!
    
    @IBOutlet weak var userpassword: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
        
        UpdateUI()
    }
    
    func UpdateUI(){
        navigationItem.title = "SignUp"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func loginscreen(){
          self.navigationController?.dismiss(animated: true, completion: nil)
          
      }
    
    
    
    
    @IBAction func signUpbun(_ sender: Any) {
        

        let email = useremail.text!
        let pass = userpassword.text!
                
        Auth.auth().createUser(withEmail: email, password: pass) { (Authdata, error) in
            if let e = error{
                ProgressHUD.showError()
                print(e.localizedDescription)
            }
            
            if error == nil{
                ProgressHUD.showSuccess("your account is created sucessfully")
                print("Sucessfully created user")
                          self.loginscreen()
                
                if let mauthdata = Authdata{
                self.createuserdbase(authdata: mauthdata)
                }

                
                
                
            }
            
            
        }
        
    
    }
    
    func createuserdbase(authdata: AuthDataResult){
        let myname = username.text!

        
           let dict:Dictionary<String, Any> = [
               Userdb.init().userEmail: authdata.user.email as Any,
               Userdb.init().userUId: authdata.user.uid as Any,
               Userdb.init().Username:myname as Any,
               Userdb.init().UserProfileURL :""
           ]
           
           Database.database().reference().child("Users").child(authdata.user.uid).updateChildValues(dict) { (error, refrence) in
               if let e = error{
                   print(e.localizedDescription)
               }
               
               print("user sucessfully added to database")
               
               
           }
           
           
       }

    
    
    
    
  
    
    
    @IBAction func signinbun(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

//
//  ViewController.swift
//  SStories
//
//  Created by Ravi Thakur on 04/04/20.
//  Copyright © 2020 Ravi Thakur. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
import GoogleSignIn
import ProgressHUD


class ViewController: UIViewController, GIDSignInDelegate {
    
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var googlebtn: UIView!
    
    @IBOutlet weak var password: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authstatecheacker()
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.clientID = "511469327214-gk5ecglj80up83h2c3ofa8n4tnfgrrst.apps.googleusercontent.com"
        
        
        
    
                // Do any additional setup after loading the view.
    }
    
    
    
    func authstatecheacker(){
        
        _ = Auth.auth().addStateDidChangeListener({ (auth, user) in
            
            if user == nil{
                print("there is np user")
            }
            
            
            if user != nil{
                self.segue()

            }

            
            })
        
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        

        self.performSegue(withIdentifier: "signup", sender: nil)

    }
    
    @IBAction func signIn(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (AUthdata, error) in
            if let e = error{
                print(e.localizedDescription)
                
                ProgressHUD.showError(e.localizedDescription)
                
            }
            if error == nil{
                print("Sucessfully signed in")
                
                ProgressHUD.showSuccess("You are signedIn sucessfully")
                self.segue()
                
                if let authdata = AUthdata{
                    self.createuserdatabase(authdata: authdata)
                }
                
                
                
                
                                
            }
        }
        
        
    }
    
    
    func createuserdatabase(authdata: AuthDataResult){
        
        let dict:Dictionary<String, Any> = [
            Userdb.init().userEmail: authdata.user.email as Any,
            Userdb.init().userUId: authdata.user.uid as Any
        ]
        
        Database.database().reference().child("Users").child(authdata.user.uid).updateChildValues(dict) { (error, refrence) in
            if let e = error{
                print(e.localizedDescription)
            }
            
            print("user sucessfully added to database")
            
            
        }
        
        
    }
    
    
    
    func segue(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let myhomevc = storyboard.instantiateViewController(withIdentifier: "Hometab") as? UITabBarController{
            
            myhomevc.modalPresentationStyle = .fullScreen
            myhomevc.isModalInPresentation = true
            
            self.present(myhomevc, animated: true, completion: nil)
            
            ProgressHUD.showSuccess("Welcome to stories")
            
        }

        
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // ...
      if let error = error {
        print(error)
        // ...
        return
      }

      guard let authentication = user.authentication else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
        
        
        
        Auth.auth().signIn(with: credential) { (authdata, error) in
            if let e = error{
                print(e.localizedDescription)
            }
            
            if let mauthdata = authdata{
            self.createuserdbase(authdata: mauthdata)
            }
            
            
            
            print("sucess")
        }
      // ...
    }
    
    func createuserdbase(authdata: AuthDataResult){
           
           let dict:Dictionary<String, Any> = [
               Userdb.init().userEmail: authdata.user.email as Any,
               Userdb.init().userUId: authdata.user.uid as Any,
               Userdb.init().Username: authdata.user.displayName as Any,
               Userdb.init().UserProfileURL: authdata.user.photoURL?.absoluteString as Any
               
           ]
           
           Database.database().reference().child("Users").child(authdata.user.uid).updateChildValues(dict) { (error, refrence) in
               if let e = error{
                   print(e.localizedDescription)
               }
               
               print("google user sucessfully added to database")
               
               
           }
           
           
       }
       
    
    
    

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    

    }

    


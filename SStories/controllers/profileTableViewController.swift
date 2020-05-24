//
//  profileTableViewController.swift
//  SStories
//
//  Created by Ravi Thakur on 28/04/20.
//  Copyright © 2020 Ravi Thakur. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Firebase
import ProgressHUD


class profileTableViewController: UITableViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    @IBOutlet weak var updateprofile: UIBarButtonItem!
    
    var userprofileurl = ""
    
    @IBOutlet weak var profileimage: UIImageView!
    
    @IBOutlet weak var profileusername: UILabel!
    
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    
    var userprofileimg : UIImage? = nil

    var profilecontroller: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        getdata()
               
        updateUI()
    }
    
    
    func segues(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let myhomevc = storyboard.instantiateViewController(withIdentifier: "signme") as?  ViewController{
            
            myhomevc.modalPresentationStyle = .fullScreen
            myhomevc.isModalInPresentation = true
            ProgressHUD.showSuccess("you are loged out")
            self.present(myhomevc, animated: true, completion: nil)

        }}

    @IBAction func logout_Button(_ sender: Any) {
           let firebaseAuth = Auth.auth()
        do {
            ProgressHUD.showSuccess("Sucessfully logout")

          try firebaseAuth.signOut()
                        segues()
            
        } catch let signOutError as NSError {
            ProgressHUD.showError("Sorry something error occurd")
          print ("Error signing out: %@", signOutError)
        }
        
        
        
    }
    func updateUI(){
        
        profilecontroller = UIImagePickerController()
        profilecontroller.delegate = self
        
        profileimage.layer.cornerRadius = profileimage.frame.size.height/2
             profileimage.layer.borderWidth = 1
             profileimage.layer.borderColor = UIColor.black.cgColor
        
        
        profileimage.isUserInteractionEnabled = true
        
       navigationItem.title = "My Profile"
       navigationController?.navigationBar.prefersLargeTitles = true
        
 let tapgesture = UITapGestureRecognizer(target: self, action: #selector(showimage))
 
     profileimage.addGestureRecognizer(tapgesture)

        

               }
    
    
    @objc func showimage(){
        
        profileimage.clipsToBounds = true
        profileimage.isUserInteractionEnabled = true
        
        profilecontroller.sourceType = .photoLibrary
        profilecontroller.allowsEditing = true
        self.present(profilecontroller, animated: true, completion: nil)
        

    }

    
    
    
        
    

    func getdata(){
        let currentuserid = Auth.auth().currentUser!.uid
        
        Database.database().reference().child("Users").child(currentuserid).observeSingleEvent(of: .value) { (snapshot) in
            
            
            let value = snapshot.value as! NSDictionary
            
            let username = value[Userdb.init().Username] as! String
            let useremail = value[Userdb.init().userEmail] as! String
            self.userprofileurl = value[Userdb.init().UserProfileURL] as! String

            self.email.text = useremail
            
            self.name.text = username
            self.profileusername.text = username
            
            if self.userprofileurl != ""{
                
                self.profileimage.loadimages(_urlstring: self.userprofileurl) { (profileimage) in
                    
                    self.profileimage.image = profileimage
                }
                
            }
            
            
            if self.userprofileurl == ""{
                self.profileimage.image = UIImage(named: "profilepicture")
            }
            
            
                        
        }
        
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedprofileimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            if picker == profilecontroller{
                
                userprofileimg = selectedprofileimage
                profileimage.image = selectedprofileimage
                
                
            }
            
            
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    
    @IBAction func update_profile(_ sender: Any) {
        
        
        if userprofileimg != nil{
            
            ProgressHUD.show("Updating")
            guard let imageselected = self.userprofileimg else{
                return
            }
            
            guard let profileimagedata = imageselected.jpegData(compressionQuality: 0.4) else{
                return
            }
            
            let currentuserid = Auth.auth().currentUser!.uid

            let profilestorageref = Storage.storage().reference(forURL: "gs://sstories-f3e3c.appspot.com")
            
            let profileimagetref = profilestorageref.child("User_profile").child(currentuserid)
            let pmetadata = StorageMetadata()
            pmetadata.contentType = "image/jpg"
            
            
            profileimagetref.putData(profileimagedata, metadata: pmetadata) { (sdata, error) in
                if let e  = error{
                    print(e.localizedDescription)
                }
                
                profileimagetref.downloadURL { (url, error) in
                    if let e = error{
                        print(e.localizedDescription)
                    }
                    
                    let profileimageurl = url?.absoluteString
                    
                    print(profileimageurl as Any)
                    
                    print("Sucessfully profile image is updated")
                    
                    
                    // let update our database
                    
                    
                    let dict:Dictionary<String, Any> = [

                        Userdb.init().UserProfileURL :profileimageurl as Any

                    ]
                    
                    Database.database().reference().child("Users").child(currentuserid).updateChildValues(dict) { (error, refrence) in
                                if let e = error{
                                    print(e.localizedDescription)
                                }
                                
                        ProgressHUD.showSuccess("Sucessfully updated")
                        DispatchQueue.main.async {
                            self.getdata()
                        
                        }
                                
                            }
                    
                    
                    
                    
                    

                
                    
                    
                    
                }
            }
        

            
            

            
            
            
        }
        
        
        
        
        
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


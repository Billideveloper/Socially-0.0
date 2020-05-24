//
//  PostStory__ViewController.swift
//  SStories
//
//  Created by Ravi Thakur on 19/04/20.
//  Copyright © 2020 Ravi Thakur. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import Firebase
import  ProgressHUD


class PostStory__ViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate{
    
    @IBOutlet weak var story_Image: UIImageView!
    
    @IBOutlet weak var story_Text: UITextView!
    
    @IBOutlet weak var share_Story: UIButton!
    
    var storyimage:UIImagePickerController!
    
    var storypostername = ""
    var storyposteremail = ""
    var storyposterimagrurl = ""
    
    var imagfe : UIImage? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        storyimage = UIImagePickerController()
        storyimage.delegate = self
        
        story_Image.isUserInteractionEnabled = true
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(showimage))
    
        story_Image.addGestureRecognizer(tapgesture)
        // Do any additional setup after loading the view.
       
        updateui()
        
    }
    
    func updateui(){
        
        story_Text.sizeToFit()
        
        story_Text.delegate = self
        
        story_Text.text = "Please Write your story here"
        story_Text.textColor = .lightGray
        
        
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if story_Text.text != ""{
            story_Text.text = ""
            story_Text.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if story_Text.text == ""{
            story_Text.text = "Please Write your story here"

            story_Text.textColor = .lightGray
            
        }
    }
    
    
    
    
    
    
    @objc func showimage(){
        
        story_Image.clipsToBounds = true
        story_Image.isUserInteractionEnabled = true
        
        storyimage.sourceType = .photoLibrary
        storyimage.allowsEditing = true
        self.present(storyimage, animated: true, completion: nil)
        

    }
    
    
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            if picker == storyimage{
                
                imagfe = selectedimage
                
                story_Image.image = selectedimage
            }
            
            
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func updateUI(){
        navigationItem.title = "Share"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func segue(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let myhomevc = storyboard.instantiateViewController(withIdentifier: "Hometab") as? UITabBarController{
            
            myhomevc.modalPresentationStyle = .fullScreen
            myhomevc.isModalInPresentation = true
            
            self.present(myhomevc, animated: true, completion: nil)
            
        }

        
    }

    
    @IBAction func share_Storyy(_ sender: Any) {
    
        guard let imageselected = self.imagfe else{
            ProgressHUD.show("Uploading Your new story")
            return
        }
        
        
        guard let imagedata = imageselected.jpegData(compressionQuality: 0.4) else{
            return
        }
        
        let currentuserid = Auth.auth().currentUser!.uid

        
        Database.database().reference().child("Users").child(currentuserid).observe(.value) { (snapshot) in
                       
                         
                         let value = snapshot.value as! NSDictionary
            let username = value[Userdb.init().Username] as? String  ?? ""
            let useremail = value[Userdb.init().userEmail] as? String ?? ""
            let userimageurl = value[Userdb.init().UserProfileURL] as? String ?? ""
            self.storypostername = username
            self.storyposteremail = useremail
            self.storyposterimagrurl = userimageurl
                                   
                                                  
                     }

    
        
        
        let storageref = Storage.storage().reference(forURL: "gs://sstories-f3e3c.appspot.com")
        
        let postref = storageref.child("story_Posted").child(Auth.auth().currentUser!.uid)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        ProgressHUD.show("updating your story")
        
        postref.putData(imagedata, metadata: metadata) { (sdata, error) in
            postref.downloadURL { (url, error) in
                if let e = error{
                    print(e)
                }
                
                let story_imagurl = url?.absoluteString
                
                let storytext = self.story_Text.text!
                
                            
                                
    
    
                let dict:Dictionary<String, Any> = [

                    UsersStory.init().storyImageurl: story_imagurl as Any,
                    UsersStory.init().storyPoster:Auth.auth().currentUser?.uid as Any,
                    UsersStory.init().storytext: storytext as Any,
                    UsersStory.init().storyPostername:self.storypostername as Any,
                    UsersStory.init().storyposteremail: self.storyposteremail as Any,
                    UsersStory.init().storyposterimageurl: self.storyposterimagrurl as Any,
                    UsersStory.init().storydate: Date().timeIntervalSince1970
                    
                
                ]
                
                Database.database().reference().child("Stories_Posted").childByAutoId().setValue(dict) { (error, database) in
                    if let e = error{
                        print(e.localizedDescription)
                    }
                    print("story is sucessfully added")
                    ProgressHUD.showSuccess("Sucessfully added your story")
                    self.segue()
                   
                }
        
                
            }
        }
        
    
        
                
        
    }
    

}

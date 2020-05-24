
//
//  homestoriesViewController.swift
//  SStories
//
//  Created by Ravi Thakur on 05/04/20.
//  Copyright © 2020 Ravi Thakur. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import SDWebImage



class homestoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
        
    
    let userid = Auth.auth().currentUser!.uid

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableview.reloadData()
                updateUI()
        loadstories()
        
        // Do any additional setup after loading the view.
    }
    
    var stories:[Storydatamodel] = []
    
    func updateUI(){
        navigationItem.title = "Stories"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableview.dataSource = self
        tableview.delegate = self
            }
    
    
    
    
    
    func loadstories(){
        
        
        Database.database().reference().child("Stories_Posted").queryOrderedByValue().observeSingleEvent(of: .value) { (snapshot) in
          
            for snap in snapshot.children{
                
                let storysnap = snap as! DataSnapshot
                let story = storysnap.value as! [String:Any]
                
                
                if let storysendername = story[UsersStory.init().storyPostername], let storysenderemail = story[UsersStory.init().storyposteremail] , let storyposterimagurl = story[UsersStory.init().storyposterimageurl], let storytext = story[UsersStory.init().storytext], let storyimagurl = story[UsersStory.init().storyImageurl]{
                    
                    let newstory = Storydatamodel(storytext: storytext as! String, storysendername: storysendername as! String, storysenderemail: storysenderemail as! String, storyposterimagurl: storyposterimagurl as! String, storyimagurl: storyimagurl as! String)
                    
                    self.stories.append(newstory)
                    
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
                    }
                    
                    
                    
                    
                }
                
                
                
            }
            
        }
        
        
        
        
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      
        let rotationtransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rotationtransform
        UIView.animate(withDuration: 0.6) {
            cell.layer.transform = CATransform3DIdentity
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dbstories = stories[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "stories", for: indexPath) as!  storiesTableViewCell
        
    
        cell.Story_text.text = dbstories.storytext
        cell.Story_poster_name.text = dbstories.storysendername
        
        
        let emailsyntax = "STORY_POSTED_BY"
        let email = dbstories.storysenderemail
        
        cell.Story_poster_email.text = "\(emailsyntax) : \(email)"
        
        let storyimagurl = dbstories.storyimagurl
        print(storyimagurl)
        
        cell.Story_image.loadimages(_urlstring: storyimagurl) { (image) in
            cell.Story_image.image = image
        }
        
        
        let storyposterimagurl = dbstories.storyposterimagurl
        
        if storyposterimagurl == ""{
            cell.Story_poster_imageview.image = UIImage(named: "profilepicture")
        }else{
            cell.Story_poster_imageview.loadimages(_urlstring: storyposterimagurl) { (userimage) in
                cell.Story_poster_imageview.image = userimage

            
        }
        }
        
        
        
        
        
        
        return cell
    }

    

    
    


}

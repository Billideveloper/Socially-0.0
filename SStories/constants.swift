//
//  constants.swift
//  SStories
//
//  Created by Ravi Thakur on 18/04/20.
//  Copyright © 2020 Ravi Thakur. All rights reserved.
//

import Foundation
import SDWebImage

struct Userdb {
let Username = "myname"
let userUId = "myuid"
let userEmail = "myemail"
let UserProfileURL = "myprofileurl"
}

struct UsersStory {
    let storyPostername = "story_poster_name"
    let storyposteremail = "story_Poster_email"
    let storyPoster = "story_Posted_by"
    let storyImageurl = "story_image_url"
    let storytext = "story_text"
    let storyposterimageurl = "story_Poster_Image_url"
    let storydate = "Story_Posted_date"

}


struct Storydatamodel{
    
    let storytext: String
    let storysendername: String
    let storysenderemail: String
    let storyposterimagurl: String
    let storyimagurl: String
}

extension UIImageView{
    func loadimages(_urlstring: String!, onSucess:((UIImage) -> Void)? = nil){
        
        
        self.image = UIImage()
        
        guard let string = _urlstring else{
            return
        }
        guard let url = URL(string: string) else{
            return
        }
        
        
        self.sd_setImage(with: url) { (image, error, cache, url) in
            
            if onSucess != nil , error == nil{
                onSucess!(image!)
            }
                    }
        
        
    }
    
    
    
    
}




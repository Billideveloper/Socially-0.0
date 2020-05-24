//
//  storiesTableViewCell.swift
//  SStories
//
//  Created by Ravi Thakur on 24/04/20.
//  Copyright © 2020 Ravi Thakur. All rights reserved.
//

import UIKit

class storiesTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var Story_image: UIImageView!
    
    @IBOutlet weak var Story_text: UITextView!
    
    @IBOutlet weak var Story_poster_imageview: UIImageView!
    
    @IBOutlet weak var Story_poster_name: UILabel!
    
    @IBOutlet weak var Story_poster_email: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
                // Initialization code
        Story_text.delegate = self as? UITextViewDelegate
        updatetextview(Storytext: Story_text)
        updateui()
        
    }
    
    
    func updatetextview(Storytext: UITextView){
        Storytext.isEditable = false
        Storytext.isScrollEnabled = false
        Storytext.sizeToFit()
    }
    
    
    func updateui(){
        Story_poster_imageview.layer.cornerRadius = Story_poster_imageview.frame.size.height/2
        Story_poster_imageview.layer.borderWidth = 1
        Story_poster_imageview.layer.borderColor = UIColor.black.cgColor
        
        Story_image.layer.cornerRadius = 10
        Story_image.layer.borderWidth = 1
        Story_image.layer.borderColor = UIColor.black.cgColor
        
        
        
    }
    
}

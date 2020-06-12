//
//  memeCollectionViewCell.swift
//  Meme-me1.0
//
//  Created by mahmoud diab on 6/11/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit

class memeTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var memeNoteLabel: UILabel!
    @IBOutlet weak var sentMemeImage: UIImageView!
 
        func configureCell (with sentMeme : Meme)
        {
            styleMemeImg(sentMemeImage: sentMemeImage)
            sentMemeImage.image = sentMeme.memedImage
            memeNoteLabel.text = sentMeme.memeNote
            dateLabel.text = sentMeme.dateCreated
        }
     
    
}

//
//  memeCollectionViewCell.swift
//  Meme-me1.0
//
//  Created by mahmoud diab on 6/11/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit

class memeCollectionViewCell: UICollectionViewCell {
     
    @IBOutlet weak var sentMemeImage: UIImageView!
   
    @IBOutlet weak var memeDateLabel: UILabel!
    
    
    
    func configureCell (with sentMeme : Meme)
    {
        sentMemeImage.image = sentMeme.memedImage
        memeDateLabel.text = sentMeme.dateCreated
      styleMemeImg(sentMemeImage: sentMemeImage)
        
    }
}

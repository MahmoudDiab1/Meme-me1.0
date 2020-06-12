//
//  memeDetailViewController.swift
//  Meme-me1.0
//
//  Created by mahmoud diab on 6/11/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    @IBOutlet weak var memeNote: UILabel!
    @IBOutlet weak var memeDate: UILabel!
    @IBOutlet weak var memeDetailImage: UIImageView?
    var meme:Meme? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memeDetailImage?.image = meme?.memedImage
        memeNote.text = meme?.memeNote
        memeDate.text = meme?.dateCreated
        styleMemeImg(sentMemeImage: memeDetailImage!)
    }
   
    }
 

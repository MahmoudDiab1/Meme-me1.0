//
//  File.swift
//  Meme-me1.0
//
//  Created by mahmoud diab on 6/12/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation
import UIKit

//    MARK:- Style textFields ( Top - Bottom )
func styleTextField ( textField : UITextField )  {
    let attributes : [NSAttributedString.Key : Any] =
        [
            NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.strokeWidth:-4
    ]
    textField.textAlignment = .center
    textField.borderStyle = .none
    textField.textColor = UIColor.white
    textField.defaultTextAttributes = attributes
    textField.textAlignment = .center
    textField.borderStyle = .none
    
}

// MARK:- style memeImage
func styleMemeImg (sentMemeImage : UIImageView) {
          sentMemeImage.layer.cornerRadius = 10
    sentMemeImage.layer.borderWidth = 0.5
          sentMemeImage.layer.borderColor = UIColor.white.cgColor
}

//
//  UIViewExt.swift
//  Meme-me1.0
//
//  Created by mahmoud diab on 6/10/20.
//  Copyright © 2020 Diab. All rights reserved.
//
import UIKit

extension UITextField
{
    func bindToKeyboard ()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification)
    {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let startingFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endingFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = startingFrame.origin.y - endingFrame.origin.y
        UITextField.animateKeyframes(withDuration: duration, delay: 0.0, options: KeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y -= deltaY
            print(deltaY)
        }, completion: nil)
        
    
    }
}


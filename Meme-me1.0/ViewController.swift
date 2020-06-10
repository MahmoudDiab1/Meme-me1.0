//
//  ViewController.swift
//  Meme-me1.0
//
//  Created by mahmoud diab on 6/10/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var navBar: UINavigationItem!
    //MARK:         - outlets and Variables
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var captureByCameraBtn: UIBarButtonItem!
    @IBOutlet weak var memeImageView: UIImageView!
    //variables
    let pickerController = UIImagePickerController()
    var keyboardHight : CGFloat=0
    
    
    //    MARK:- Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shareBtn.isEnabled = (memeImageView.image != nil)
        captureByCameraBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        setupScene()
    }
    
    
    // MARK:- IBActions
    
    @IBAction func pickAnImageFromAlbume(_ sender: Any)
    {
        pickerController.delegate = self
        present (pickerController,animated: true , completion: nil)
    }
    
    @IBAction func captureFromCamera(_ sender: Any)
    {
        pickerController.delegate = self
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        
        let memedImage =  generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed == true
            {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func cancleBtnPressed(_ sender: Any) {
        topTextField.text = "Top"
        bottomTextField.text = "Bottom"
        memeImageView.image = nil
        shareBtn.isEnabled = false
    }
    
    //    MARK:- save meme
    
    func save() {
        let image = memeImageView.image
        let memedImage = MemeImageModel(topText: topTextField.text, bottomText: bottomTextField.text, image: image!)
    }
    
    
    //    MARK:- Generate Memed Image
    func generateMemedImage() -> UIImage {
        toolBar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        toolBar.isHidden = false
        return memedImage
    }
    
    //    MARK:- keyboard handeling
 
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)) ,
                                               name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)) ,                                                name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyBoardWillShow (_ notification:Notification)  {
        let userInfoDic = notification.userInfo
        let keyboardSize = userInfoDic![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let KeyboardHight = keyboardSize.cgRectValue.height
        
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= KeyboardHight
            
            
            
        }
    }
    
    @objc func keyBoardWillHide (_ notification:Notification)
    {
        
        let userInfoDic = notification.userInfo
        let keyboardSize = userInfoDic![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let KeyboardHight = keyboardSize.cgRectValue.height
        keyboardHight = KeyboardHight
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += KeyboardHight
            
        }
    }
    
    
    
    
    //    MARK:- Setup Scene
    
    func setupScene()
    {
        //  top text field styling
        styleTextField(textField: topTextField)
        topTextField.text = "Top"
        let panTop = UIPanGestureRecognizer(target: self, action: #selector(handleTopPan(sender:)))
        topTextField.addGestureRecognizer(panTop)
        
        
        //  bottom text field styling
        styleTextField(textField: bottomTextField)
        bottomTextField.text = "Bottom"
        let panBottom = UIPanGestureRecognizer(target: self, action: #selector(handleBottomPan(sender:)))
        bottomTextField.addGestureRecognizer(panBottom)
        
    }
    
    
    
    
    //    MARK:- Style textFields
    func styleTextField ( textField : UITextField)
    {
        let attributes : [NSAttributedString.Key : Any] =
            [
                NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.strokeColor: UIColor.black,
                NSAttributedString.Key.strokeWidth:-4
                
        ]
        
        textField.defaultTextAttributes = attributes
        textField.delegate = self
        textField.textAlignment = .center
        textField.borderStyle = .none
        
    }
    
    //    MARK:- Handel pan gestures for top and bottom textFields
    @objc func handleTopPan (sender:UIPanGestureRecognizer)
    {
        let translation = sender.translation(in: sender.view)
        self.topTextField.center.x += translation.x
        self.topTextField.center.y += translation.y
        sender.setTranslation(CGPoint.zero, in: sender.view)
    }
    @objc func handleBottomPan(sender:UIPanGestureRecognizer)
    {
        let translation = sender.translation(in: sender.view)
        self.bottomTextField.center.x += translation.x
        self.bottomTextField.center.y += translation.y
        sender.setTranslation(CGPoint.zero, in: sender.view)
    }
    
    
    // MARK:-   UIImagePicker delegat functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            self.memeImageView.image = image
            picker.dismiss(animated: true, completion: nil)
        }
        shareBtn.isEnabled = (memeImageView.image != nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    // MARK:-    TextField delegat functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
       
    
//   additional feature to reset text to top and bottom if user input was nothing.
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField.text == "" {
//            if textField.tag == 0
//            {
//                textField.text = "Top"
//
//            }
//            else
//            {
//                textField.text = "Bottom"
//            }
//        }
//    }
   
    
}


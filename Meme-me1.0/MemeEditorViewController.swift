//
//  ViewController.swift
//  Meme-me1.0
//
//  Created by mahmoud diab on 6/10/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
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
    
    func pickWithSource (sourceType : UIImagePickerController.SourceType)
    {
        pickerController.delegate = self
        present (pickerController,animated: true , completion: nil)
        if sourceType == .camera {
            pickerController.sourceType = .camera
        } else {
            pickerController.sourceType = .photoLibrary
        }
    }
    
    @IBAction func pickAnImageFromAlbume(_ sender: Any) {
        pickWithSource(sourceType: .photoLibrary)
    }
    
    @IBAction func captureFromCamera(_ sender: Any) {
        pickWithSource(sourceType: .camera)
    }
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        
        let memedImage =  generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = {(_, completed: Bool, _, _) in
            if completed == true {
                self.save(memedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        topTextField.text = "Top"
        bottomTextField.text = "Bottom"
        memeImageView.image = nil
        shareBtn.isEnabled = false
    }
    
    //    MARK:- save meme
    
    func save(_ memedImage:UIImage) {
        
        let meme = MemeImageModel(topText: topTextField.text!, bottomText: bottomTextField.text!, origionalImage: memeImageView.image! ,memedImage: memedImage)
    }
    
    
    
    //    MARK:- Generate Memed Image
    func generateMemedImage() -> UIImage {
        toolBar.isHidden = true
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
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
    
    
    
    @objc func keyBoardWillShow (_ notification:Notification) {
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    @objc func keyBoardWillHide (_ notification:Notification) {
        view.frame.origin.y = 0
    }
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        if bottomTextField.isFirstResponder {
            return keyboardSize.cgRectValue.height
        } else {
            return 0
        }
    }
    
    
    
    
    
    
    //    MARK:- Setup Scene
    
    func setupScene() {
        memeImageView.contentMode = .scaleAspectFit
        memeImageView.backgroundColor = .lightGray
        captureByCameraBtn.tintColor = .black
        cancelButton.tintColor = .black
        shareBtn.tintColor = .blue
        
        //  top text field styling
        styleTextField(textField: topTextField)
        styleTextField(textField: bottomTextField)
        
        
    }
    
    
    
    
    //    MARK:- Style textFields
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
        textField.delegate = self
        textField.textAlignment = .center
        textField.borderStyle = .none
        let panTop = UIPanGestureRecognizer(target: self, action: #selector(handlePantop(sender:)))
        let panBottomm = UIPanGestureRecognizer(target: self, action: #selector(handlePanBottom(sender:)))
        topTextField.addGestureRecognizer(panTop)
        bottomTextField.addGestureRecognizer(panBottomm)
        if textField.tag == 0  {
            topTextField.text = "Top"
        }  else {
            bottomTextField.text = "Bottom"
        }
        
    }
    
    //    MARK:- Handel pan gestures for top and bottom textFields
    
    @objc func handlePantop(sender:UIPanGestureRecognizer) {
        let translation = sender.translation(in: sender.view)
        topTextField.center.x += translation.x
        topTextField.center.y += translation.y
        sender.setTranslation(CGPoint.zero, in: sender.view)
    }
    @objc func handlePanBottom(sender:UIPanGestureRecognizer) {
        let translation = sender.translation(in: sender.view)
        bottomTextField.center.x += translation.x
        bottomTextField.center.y += translation.y
        sender.setTranslation(CGPoint.zero, in: sender.view)
    }
    
    // MARK:-   UIImagePicker delegat functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.memeImageView.image = image
            picker.dismiss(animated: true, completion: nil)
        }
        shareBtn.isEnabled = (memeImageView.image != nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
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
    
    
}


//
//  SignupViewController.swift
//  ParseStarterProject
//
//  Created by Mathieu Skulason on 27/06/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let firstNameTextField = SideImageTextField()
    let lastNameTextField = SideImageTextField()
    let emailTextField = SideImageTextField()
    let passwordTextField = SideImageTextField()
    let confirmPasswordTextField = SideImageTextField()
    let imagePicker = UIImagePickerController()
    let profilePictureImageView = UIImageView()
    var scrollView: UIScrollView!
    var currTextFieldFrame: CGRect?
    var diffHeight: CGFloat?
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.flatTealColor()
        
        currTextFieldFrame = nil
        diffHeight = nil
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        imagePicker.allowsEditing = true
        
        let backButton = UIButton(frame: CGRectMake(5, 20, 80, 44))
        backButton.setTitle("< Back", forState: UIControlState.Normal)
        backButton.titleLabel?.font = UIFont.maxwellBoldWithSize(21.0)
        backButton.titleLabel?.textAlignment = NSTextAlignment.Left
        backButton.setTitleColor(UIColor.flatWhiteColor(), forState: UIControlState.Normal)
        backButton.setTitleColor(UIColor.flatGrayColor(), forState: UIControlState.Highlighted)
        backButton.addTarget(self, action: #selector(SignupViewController.backSegue), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backButton)
        
        let appTitleLabel = UILabel(frame: CGRectMake(100, 20, CGRectGetWidth(self.view.frame) - 200, 44))
        appTitleLabel.font = UIFont.maxwellBoldWithSize(21.0)
        appTitleLabel.text = "League Manager"
        appTitleLabel.textAlignment = NSTextAlignment.Center
        appTitleLabel.textColor = UIColor.flatWhiteColor()
        self.view.addSubview(appTitleLabel)
        
        let labelBottomBorder = UIView(frame: CGRectMake(0, CGRectGetMaxY(appTitleLabel.frame) - 2, CGRectGetWidth(self.view.frame), 2))
        labelBottomBorder.backgroundColor = UIColor.flatWhiteColor()
        self.view.addSubview(labelBottomBorder)
        
        scrollView = UIScrollView(frame: CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        let scrollViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.dismissKeyboard))
        scrollView.addGestureRecognizer(scrollViewTapGesture)
        
        self.view.addSubview(scrollView)
        
        profilePictureImageView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 80, 40, 160, 160)
        profilePictureImageView.layer.cornerRadius = CGRectGetWidth(profilePictureImageView.frame) / 2.0
        profilePictureImageView.layer.backgroundColor = UIColor.whiteColor().CGColor
        profilePictureImageView.layer.borderColor = UIColor.flatTealColorDark().CGColor
        profilePictureImageView.layer.borderWidth = 3
        profilePictureImageView.layer.masksToBounds = true
        profilePictureImageView.userInteractionEnabled = true
        
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.chooseImage))
        profilePictureImageView.addGestureRecognizer(profileTapGesture)
        
        scrollView.addSubview(profilePictureImageView)
        
        firstNameTextField.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 110, CGRectGetMaxY(profilePictureImageView.frame) + 20, 220, 40)
        firstNameTextField.textField.placeholder = "first name"
        firstNameTextField.textField.delegate = self
        firstNameTextField.layer.borderColor = UIColor.flatTealColorDark().CGColor
        firstNameTextField.layer.borderWidth = (1.5)
        scrollView.addSubview(firstNameTextField)
        
        lastNameTextField.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 110, CGRectGetMaxY(firstNameTextField.frame) + 20, 220, 40)
        lastNameTextField.textField.placeholder = "second name"
        lastNameTextField.textField.delegate = self
        lastNameTextField.layer.borderColor = UIColor.flatTealColorDark().CGColor
        lastNameTextField.layer.borderWidth = (1.5)
        scrollView.addSubview(lastNameTextField)
        
        emailTextField.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 110, CGRectGetMaxY(lastNameTextField.frame) + 20, 220, 40)
        emailTextField.textField.placeholder = "email"
        emailTextField.textField.delegate = self
        emailTextField.layer.borderColor = UIColor.flatTealColorDark().CGColor
        emailTextField.layer.borderWidth = (1.5)
        scrollView.addSubview(emailTextField)
        
        passwordTextField.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 110, CGRectGetMaxY(emailTextField.frame) + 20, 220, 40)
        passwordTextField.textField.placeholder = "password"
        passwordTextField.textField.delegate = self
        passwordTextField.layer.borderColor = UIColor.flatTealColorDark().CGColor
        passwordTextField.layer.borderWidth = (1.5)
        scrollView.addSubview(passwordTextField)
        
        confirmPasswordTextField.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 110, CGRectGetMaxY(passwordTextField.frame) + 20, 220, 40)
        confirmPasswordTextField.textField.placeholder = "confirm password"
        confirmPasswordTextField.textField.delegate = self
        confirmPasswordTextField.layer.borderColor = UIColor.flatTealColorDark().CGColor
        confirmPasswordTextField.layer.borderWidth = (1.5)
        scrollView.addSubview(confirmPasswordTextField)
        
        let signupButton = UIButton(frame: CGRectMake(CGRectGetMidX(self.view.frame) - 60, CGRectGetMaxY(confirmPasswordTextField.frame) + 20, 120, 36))
        signupButton.layer.cornerRadius = 4
        signupButton.layer.backgroundColor = UIColor.flatTealColorDark().CGColor
        signupButton.setTitle("SIGNUP", forState: UIControlState.Normal)
        signupButton.setTitleColor(UIColor.flatWhiteColor(), forState: UIControlState.Normal)
        signupButton.setTitleColor(UIColor.flatGrayColor(), forState: UIControlState.Highlighted)
        signupButton.addTarget(self, action: #selector(SignupViewController.signup), forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(signupButton)
        
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(signupButton.frame) + 50)
        
        // add the keyboard notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignupViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignupViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func signup() {
        
        if passwordTextField.textField.text == confirmPasswordTextField.textField.text {
            
            let newUser = PFUser()
            newUser.username = emailTextField.textField.text
            newUser.email = emailTextField.textField.text
            newUser.password = passwordTextField.textField.text
            
            let progressHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
            if self.profilePictureImageView.image != nil {
                progressHud.mode = MBProgressHUDMode.AnnularDeterminate
            }
            else {
                progressHud.mode = MBProgressHUDMode.Indeterminate
            }
            
            newUser.signUpInBackgroundWithBlock({
                 (succeeded: Bool, error: NSError?) -> Void in
                
                if error == nil {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        if self.profilePictureImageView.image != nil {
                            
                            let imageFile = PFFile(data: UIImageJPEGRepresentation(self.profilePictureImageView.image!, 0.5)!)
                            imageFile.saveInBackgroundWithBlock({
                                (succeeded: Bool, error: NSError?) -> Void in
                                
                                if error == nil && succeeded {
                                    print("uploaded file to parse")
                                    let user = PFUser.currentUser()
                                    user!["someFile"] = imageFile
                                    user?.saveInBackgroundWithBlock({
                                        (succeeded: Bool, error: NSError?) -> Void in
                                        
                                        if succeeded && error == nil {
                                            print("saved user after photo")
                                            progressHud.hide(true)
                                            self.signupSegue()
                                        }
                                        else {
                                            print("error occurred when saving user with image: %@ and succeeded \(succeeded)", error)
                                        }
                                    })
                                    
                                } else {
                                    print("Error uploading file to parse")
                                }
                                
                                
                                }, progressBlock: {
                                    (percentDone: Int32) -> Void in
                                    print("percent done: %d", percentDone)
                                    let percent: Float = Float(percentDone) / 100
                                    print("float done  \(percent)")
                                    progressHud.progress = percent
                                    
                            })
                            
                        }
                        else {
                            print("signed up")
                            progressHud.hide(true)
                            self.signupSegue()
                        }
                        
                    })
                }
                else {
                    print("error occurred: %@", error)
                    progressHud.hide(true)
                }
                
            })
        }
        else {
            print("password does not match show an error")
        }
        
    }
    
    func backSegue() {
        self.performSegueWithIdentifier("revertToLoginSegue", sender: self)
    }
    
    func signupSegue() {
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("loginFromSignupSegue", sender: self)
        })
    }
    
    
    // MARK: Image Picker and delegate
    func chooseImage() {
        
        print("choose image")
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            
            self.presentViewController(imagePicker, animated: true, completion: {
                
                
            })
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        profilePictureImageView.image = image;
        
        self.dismissViewControllerAnimated(true, completion: {
            
        })
    }
    
    // MARK: Text field delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        currTextFieldFrame = textField.superview!.frame
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: Keyboard Notifications
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        
        let userInfo = notification.userInfo
        var keyboardHeight = (userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue().size.height
        let keyboardAnimationTime = (userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        
        if keyboardHeight != nil && currTextFieldFrame != nil {

            let height = (CGRectGetMaxY(currTextFieldFrame!) + 64) - scrollView.contentOffset.y
            keyboardHeight = CGRectGetHeight(self.view.frame) - keyboardHeight!

            if height > keyboardHeight {
                diffHeight = height - keyboardHeight!
                
                UIView.animateWithDuration(keyboardAnimationTime!, animations: {
                    self.scrollView.setContentOffset(CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y + self.diffHeight!), animated: false)
                    }, completion: {
                        (succeeded: Bool) -> Void in
                        
                })
            }
            
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {

        if diffHeight != nil {
            self.scrollView.setContentOffset(CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y - diffHeight!), animated: true)
        }
    }
    
    
    
}

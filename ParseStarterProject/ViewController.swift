//
//  ViewController.swift
//  ParseStarterProject
//
//  Created by Mathieu Skulason on 18/06/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    
    var usernameTextField = SideImageTextField()
    var passwordTextField = SideImageTextField()
    var currTextFieldFrame: CGRect?
    var diffHeight: CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.flatTealColor()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        let titleLabel = UILabel(frame: CGRectMake(0, CGRectGetWidth(self.view.frame) * 0.4, CGRectGetWidth(self.view.frame), 24))
        titleLabel.text = "League Manager"
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.maxwellBoldWithSize(28.0)
        self.view.addSubview(titleLabel)
        
        usernameTextField.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 110, CGRectGetHeight(self.view.frame) * 0.5, 220, 40)
        usernameTextField.layer.borderWidth = (1.5)
        usernameTextField.layer.borderColor = UIColor.flatTealColorDark().CGColor
        usernameTextField.textField.placeholder = "username"
        usernameTextField.textField.delegate = self
        usernameTextField.textField.font = UIFont.openSansItalicWithSize(15.0)
        self.view.addSubview(usernameTextField)
        
        passwordTextField.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 110, CGRectGetMaxY(usernameTextField.frame) + 10, 220, 40)
        passwordTextField.layer.borderWidth = (1.5)
        passwordTextField.layer.borderColor = UIColor.flatTealColorDark().CGColor
        passwordTextField.textField.placeholder = "********"
        passwordTextField.textField.delegate = self
        passwordTextField.textField.font = UIFont.openSansItalicWithSize(15.0)
        passwordTextField.textField.secureTextEntry = true
        self.view.addSubview(passwordTextField)
        
        
        let loginButton = UIButton(frame: CGRectMake(CGRectGetMidX(self.view.frame) - 60, CGRectGetHeight(self.view.frame) * 0.7, 120, 36));
        loginButton.layer.backgroundColor = UIColor.flatTealColorDark().CGColor;
        loginButton.layer.cornerRadius = 4.0;
        loginButton.titleLabel?.font = UIFont.openSansWithSize(17.0)
        loginButton.setTitle("LOGIN", forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.flatWhiteColor(), forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.flatGrayColor(), forState: UIControlState.Highlighted)
        loginButton.addTarget(self, action: #selector(ViewController.login), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(loginButton)
        
        let signupButton = UIButton(frame: CGRectMake(CGRectGetMidX(self.view.frame) - 60, CGRectGetMaxY(loginButton.frame) + 14, 120, 36))
        signupButton.layer.backgroundColor = UIColor.flatTealColorDark().CGColor;
        signupButton.layer.cornerRadius = 4.0
        signupButton.titleLabel?.font = UIFont.openSansWithSize(17.0)
        signupButton.setTitle("SIGNUP", forState: UIControlState.Normal)
        signupButton.setTitleColor(UIColor.flatWhiteColor(), forState: UIControlState.Normal)
        signupButton.setTitleColor(UIColor.flatGrayColor(), forState: UIControlState.Highlighted)
        signupButton.addTarget(self, action: #selector(ViewController.signup), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(signupButton)
        
        // add the keyboard notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if (PFUser.currentUser() != nil) {
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }

    }
    
    func login() {
        
        PFUser.logInWithUsernameInBackground(usernameTextField.textField.text!, password:passwordTextField.textField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                })
            } else {
                // The login failed. Check error to see why.
                let alert = UIAlertView(title: "login error", message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
        }
    }
    
    func signup() {
        self.performSegueWithIdentifier("signupSegue", sender: self)
    }
    
    func dismissKeyboard() {
        print("dismiss keyboard")
        self.view.endEditing(true)
    }
    // Mark text field delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        currTextFieldFrame = textField.superview!.frame
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Keyboard notifications
    func keyboardWillShow(notification: NSNotification) {
        
        print("keyboard will show")
        
        let userInfo = notification.userInfo
        let keyboardHeight = (userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue().size.height
        let keyboardAnimationTime = (userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        
        if keyboardHeight != nil && currTextFieldFrame != nil {

            let height =  CGRectGetMaxY(currTextFieldFrame!)
            let absoluteKeyboardHeight = CGRectGetHeight(self.view.frame) - keyboardHeight!

            if height > absoluteKeyboardHeight {
                
                diffHeight = height - absoluteKeyboardHeight
                
                
                UIView.animateWithDuration(keyboardAnimationTime!, animations: {
                    var passFrame = self.passwordTextField.frame
                    passFrame.origin.y -= self.diffHeight!
                    self.passwordTextField.frame = passFrame
                    
                    var loginFrame = self.usernameTextField.frame
                    loginFrame.origin.y -= self.diffHeight!
                    self.usernameTextField.frame = loginFrame
                    
                    }, completion: { (succeeded: Bool) -> Void in
                    
                })
            } else {
                diffHeight = nil
            }
            
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        print("keyboard will hide")
        
        if diffHeight != nil {
            
            print("keyboard animation")
            
            UIView.animateWithDuration(0.3, animations: {
                self.passwordTextField.frame.origin.y += self.diffHeight!
                self.usernameTextField.frame.origin.y += self.diffHeight!
                }, completion: { (succeeded: Bool) -> Void in
                    
            })
            
        }
        
    }


}


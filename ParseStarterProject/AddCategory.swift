//
//  AddCategory.swift
//  ParseStarterProject
//
//  Created by Mathieu Skulason on 28/06/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

import UIKit

class AddCategory: UIViewController {
    
    let categoryTextField = UITextField()
    let pointsForTieTextField = UITextField()
    let pointsForWinTextField = UITextField()
    
    var selectedChampionship: Championship?

    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.flatWhiteColor()
        
        let navBar = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64))
        navBar.backgroundColor = UIColor.flatTealColor()
        self.view.addSubview(navBar)
        
        let backgroundTapGesture = UITapGestureRecognizer(target: self, action: "backgroundTap")
        self.view.addGestureRecognizer(backgroundTapGesture)
        
        let appTitleLabel = UILabel(frame: CGRectMake(100, 20, CGRectGetWidth(self.view.frame) - 200, 44))
        appTitleLabel.font = UIFont.maxwellBoldWithSize(21.0)
        appTitleLabel.text = "Add Championship"
        appTitleLabel.textAlignment = NSTextAlignment.Center
        appTitleLabel.textColor = UIColor.flatWhiteColor()
        self.view.addSubview(appTitleLabel)
        
        let appCancelButton = UIButton(frame: CGRectMake(10, 20, 80, 44))
        appCancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        appCancelButton.titleLabel!.font = UIFont.maxwellBoldWithSize(19.0)
        appCancelButton.setTitle("Cancel", forState: UIControlState.Normal)
        appCancelButton.setTitleColor(UIColor.flatRedColor(), forState: UIControlState.Normal)
        appCancelButton.setTitleColor(UIColor.flatRedColorDark(), forState: UIControlState.Highlighted)
        appCancelButton.addTarget(self, action: "cancelCategory", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(appCancelButton)
        
        let appAddButton = UIButton(frame: CGRectMake(CGRectGetWidth(self.view.frame) - 90, 20, 80, 44))
        appAddButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        appAddButton.titleLabel!.font = UIFont.maxwellBoldWithSize(19.0)
        appAddButton.setTitle("Add", forState: UIControlState.Normal)
        appAddButton.setTitleColor(UIColor.flatGreenColor(), forState: UIControlState.Normal)
        appAddButton.setTitleColor(UIColor.flatGreenColorDark(), forState: UIControlState.Highlighted)
        appAddButton.addTarget(self, action: "addCategory", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(appAddButton)
        
        let championshipNameLabel = UILabel(frame: CGRectMake(CGRectGetMidX(self.view.frame) - 120, CGRectGetHeight(self.view.frame) * 0.2, 240, 50))
        championshipNameLabel.text = "Name of Category"
        championshipNameLabel.font = UIFont.openSansBoldWithSize(17.0)
        championshipNameLabel.textColor = UIColor.flatPlumColor()
        championshipNameLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(championshipNameLabel)
        
        categoryTextField.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 130, CGRectGetMaxY(championshipNameLabel.frame), 260, 50)
        categoryTextField.font = UIFont.openSansBoldWithSize(15.0)
        categoryTextField.textColor = UIColor.flatBlackColor()
        categoryTextField.textAlignment = NSTextAlignment.Center
        categoryTextField.attributedPlaceholder = NSAttributedString(string: "enter category name", attributes: [NSFontAttributeName : UIFont.openSansBoldItalicWithSize(15.0)])
        self.view.addSubview(categoryTextField)
        
        let pointsForTieLabel = UILabel(frame: CGRectMake(10, CGRectGetMaxY(categoryTextField.frame) + 40, CGRectGetWidth(self.view.frame) * 0.5 - 20, 30))
        pointsForTieLabel.text = "Points for tie"
        pointsForTieLabel.font = UIFont.openSansBoldWithSize(16.0)
        pointsForTieLabel.textColor = UIColor.flatYellowColorDark()
        pointsForTieLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(pointsForTieLabel)
        
        pointsForTieTextField.frame = CGRectMake(10, CGRectGetMaxY(pointsForTieLabel.frame) + 5, CGRectGetWidth(self.view.frame) * 0.5 - 20, 30)
        pointsForTieTextField.font = UIFont.openSansBoldWithSize(14.0)
        pointsForTieTextField.textColor = UIColor.flatBlackColor()
        pointsForTieTextField.textAlignment = NSTextAlignment.Center
        pointsForTieTextField.attributedPlaceholder = NSAttributedString(string: "enter points for tie", attributes: [NSFontAttributeName : UIFont.openSansBoldItalicWithSize(15.0)])
        self.view.addSubview(pointsForTieTextField)
        
        let pointsForWinLabel = UILabel(frame: CGRectMake(CGRectGetMidX(self.view.frame) + 10, CGRectGetMinY(pointsForTieLabel.frame), CGRectGetWidth(self.view.frame) * 0.5 - 20, 30))
        pointsForWinLabel.text = "Points for win"
        pointsForWinLabel.font = UIFont.openSansBoldWithSize(16.0)
        pointsForWinLabel.textColor = UIColor.flatBlueColorDark()
        pointsForWinLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(pointsForWinLabel)
        
        pointsForWinTextField.frame = CGRectMake(CGRectGetMidX(self.view.frame) + 10, CGRectGetMinY(pointsForTieTextField.frame), CGRectGetWidth(self.view.frame) * 0.5 - 20, 30)
        pointsForWinTextField.font = UIFont.openSansBoldWithSize(14.0)
        pointsForWinTextField.textColor = UIColor.flatBlackColor()
        pointsForWinTextField.textAlignment = NSTextAlignment.Center
        pointsForWinTextField.attributedPlaceholder = NSAttributedString(string: "enter points for win", attributes: [NSFontAttributeName : UIFont.openSansBoldItalicWithSize(15.0)])
        self.view.addSubview(pointsForWinTextField)
        
    }
    
    func backgroundTap() {
        self.view.endEditing(true)
    }
    
    func cancelCategory() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addCategory() {
        
        var numberFormatter = NSNumberFormatter()
        numberFormatter.allowsFloats = false
        numberFormatter.minimumIntegerDigits = 1
        
        let progressHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHud.mode = MBProgressHUDMode.Indeterminate
        
        if (categoryTextField.text != "" && numberFormatter.numberFromString(pointsForTieTextField.text!)?.integerValue != nil  && numberFormatter.numberFromString(pointsForWinTextField.text!)?.integerValue != nil) {
            
            var category = LMCategory.object()
            category.name = categoryTextField.text
            category.pointsForTie = numberFormatter.numberFromString(pointsForTieTextField.text!)!
            category.pointsForWin = numberFormatter.numberFromString(pointsForWinTextField.text!)!
            category.championshipId = selectedChampionship!.objectId
            
            category.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                
                progressHud.hide(true)
                
                if succeeded == true && error == nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                } else {
                    print("error saving category")
                }
                
            })
            
        } else {
            print("error field not entered correctly")
        }
    }
    
}

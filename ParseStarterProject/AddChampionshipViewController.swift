//
//  AddChampionshipViewController.swift
//  ParseStarterProject
//
//  Created by Mathieu Skulason on 28/06/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

import UIKit

class AddChampionshipViewController: UIViewController {
    
    let datePicker = UIDatePicker()
    let datePickerView = UIView()
    let championshipTextField = UITextField()
    let startDateButton = UIButton()
    let endDateButton = UIButton()
    let acceptButton = UIButton()
    var startDate: NSDate?
    var endDate: NSDate?
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.flatWhiteColor()
        
        let navBar = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64))
        navBar.backgroundColor = UIColor.flatTealColor()
        self.view.addSubview(navBar)
        
        let backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(AddChampionshipViewController.backgroundTap))
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
        appCancelButton.addTarget(self, action: #selector(AddChampionshipViewController.cancelAdd), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(appCancelButton)
        
        let appAddButton = UIButton(frame: CGRectMake(CGRectGetWidth(self.view.frame) - 90, 20, 80, 44))
        appAddButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        appAddButton.titleLabel!.font = UIFont.maxwellBoldWithSize(19.0)
        appAddButton.setTitle("Add", forState: UIControlState.Normal)
        appAddButton.setTitleColor(UIColor.flatGreenColor(), forState: UIControlState.Normal)
        appAddButton.setTitleColor(UIColor.flatGreenColorDark(), forState: UIControlState.Highlighted)
        appAddButton.addTarget(self, action: #selector(AddChampionshipViewController.addChampionship), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(appAddButton)
        
        let championshipNameLabel = UILabel(frame: CGRectMake(CGRectGetMidX(self.view.frame) - 120, CGRectGetHeight(self.view.frame) * 0.2, 240, 50))
        championshipNameLabel.text = "Name of championship"
        championshipNameLabel.font = UIFont.openSansBoldWithSize(17.0)
        championshipNameLabel.textColor = UIColor.flatSkyBlueColor()
        championshipNameLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(championshipNameLabel)
        
        championshipTextField.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 130, CGRectGetMaxY(championshipNameLabel.frame), 260, 50)
        championshipTextField.font = UIFont.openSansBoldWithSize(15.0)
        championshipTextField.textColor = UIColor.flatBlackColor()
        championshipTextField.textAlignment = NSTextAlignment.Center
        championshipTextField.attributedPlaceholder = NSAttributedString(string: "enter championship name", attributes: [NSFontAttributeName : UIFont.openSansBoldItalicWithSize(15.0)])
        self.view.addSubview(championshipTextField)
        
        startDateButton.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 140, CGRectGetHeight(self.view.frame) * 0.5, 120, 40)
        startDateButton.layer.borderWidth = (2.0)
        startDateButton.layer.borderColor = UIColor.flatWatermelonColor().CGColor
        startDateButton.layer.cornerRadius = (16.0)
        startDateButton.titleLabel!.font = UIFont.openSansBoldWithSize(15.0)
        startDateButton.setTitle("Start Date", forState: UIControlState.Normal)
        startDateButton.setTitleColor(UIColor.flatBlackColor(), forState: UIControlState.Normal)
        startDateButton.setTitleColor(UIColor.flatGrayColorDark(), forState: UIControlState.Highlighted)
        startDateButton.addTarget(self, action: #selector(AddChampionshipViewController.showStartDatePicker), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(startDateButton)
        
        endDateButton.frame = CGRectMake(CGRectGetMidX(self.view.frame) + 20, CGRectGetHeight(self.view.frame) * 0.5, 120, 40)
        endDateButton.layer.borderWidth = (2.0)
        endDateButton.layer.borderColor = UIColor.flatMintColor().CGColor
        endDateButton.layer.cornerRadius = (16.0)
        endDateButton.titleLabel!.font = UIFont.openSansBoldWithSize(15.0)
        endDateButton.setTitle("End Date", forState: UIControlState.Normal)
        endDateButton.setTitleColor(UIColor.flatBlackColor(), forState: UIControlState.Normal)
        endDateButton.setTitleColor(UIColor.flatGrayColorDark(), forState: UIControlState.Highlighted)
        endDateButton.addTarget(self, action: #selector(AddChampionshipViewController.showEndDatePicker), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(endDateButton)
        
        datePickerView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 216.0 + 40)
        datePickerView.alpha = (0.0)
        self.view.addSubview(datePickerView)
        
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.frame = CGRectMake(0, 40, CGRectGetWidth(self.view.frame), 216.0)
        self.datePickerView.addSubview(datePicker)
        
        let datePickerViewHeader = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(datePickerView.frame), 40))
        datePickerViewHeader.backgroundColor = UIColor.flatOrangeColor()
        self.datePickerView.addSubview(datePickerViewHeader)
        
        acceptButton.frame = CGRectMake(CGRectGetWidth(datePickerViewHeader.frame) - 110, 0, 100, 40)
        acceptButton.titleLabel!.font = UIFont.openSansBoldWithSize(19.0)
        acceptButton.setTitle("Accept", forState: UIControlState.Normal)
        acceptButton.setTitleColor(UIColor.flatWhiteColor(), forState: UIControlState.Normal)
        acceptButton.setTitleColor(UIColor.flatGrayColor(), forState: UIControlState.Highlighted)
        self.datePickerView.addSubview(acceptButton)
        
        let cancelDateButton = UIButton(frame: CGRectMake(10, 0, 100, 40))
        cancelDateButton.titleLabel!.font = UIFont.openSansBoldWithSize(19.0)
        cancelDateButton.setTitle("Cancel", forState: UIControlState.Normal)
        cancelDateButton.setTitleColor(UIColor.flatWhiteColor(), forState: UIControlState.Normal)
        cancelDateButton.setTitleColor(UIColor.flatGrayColor(), forState: UIControlState.Highlighted)
        cancelDateButton.addTarget(self, action: #selector(AddChampionshipViewController.hideDatePicker), forControlEvents: UIControlEvents.TouchUpInside)
        self.datePickerView.addSubview(cancelDateButton)
        
    }
    
    func cancelAdd() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addChampionship() {
        
        if startDate != nil && endDate != nil && championshipTextField.text != "" {
            
            let progressHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            progressHud.mode = MBProgressHUDMode.Indeterminate
            
            let championship = PFObject(className: "Championship")
            championship["name"] = championshipTextField.text!
            championship["startDate"] = startDate!
            championship["endDate"] = endDate!
            championship["userId"] = PFUser.currentUser()!.objectId!
            
            championship.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                
                progressHud.hide(true)
                
                if succeeded == true && error == nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.cancelAdd()
                    })
                }
                else {
                    print("error couldn't save championship")
                }
            })
        }
        else {
            print("data not correctly composed")
        }
        
    }
    
    func backgroundTap() {
        self.view.endEditing(true)
        self.hideDatePicker()
    }
    
    // MARK: Date Picker
    
    func showStartDatePicker() {
        
        datePickerView.alpha = 1.0
        acceptButton.addTarget(self, action: #selector(AddChampionshipViewController.hideStartDatePicker), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.showDatePicker()
    }
    
    func hideStartDatePicker() {
        
        acceptButton.removeTarget(self, action: #selector(AddChampionshipViewController.hideStartDatePicker), forControlEvents: UIControlEvents.TouchUpInside)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        startDate = datePicker.date
        startDateButton.setTitle(dateFormatter.stringFromDate(datePicker.date), forState: UIControlState.Normal)
        
        self.hideDatePicker()
    }
    
    func showEndDatePicker() {
        
        datePickerView.alpha = 1.0
        acceptButton.addTarget(self, action: #selector(AddChampionshipViewController.hideEndDatePicker), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.showDatePicker()
    }
    
    func hideEndDatePicker() {
        
        acceptButton.removeTarget(self, action: #selector(AddChampionshipViewController.hideEndDatePicker), forControlEvents: UIControlEvents.TouchUpInside)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        endDate = datePicker.date
        endDateButton.setTitle(dateFormatter.stringFromDate(datePicker.date), forState: UIControlState.Normal)
        
        self.hideDatePicker()
    }
    
    // MARK: Date Picker Animations
    
    func showDatePicker() {
        UIView.animateWithDuration(0.3, animations: {
            self.datePickerView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.datePickerView.frame), CGRectGetWidth(self.datePickerView.frame), CGRectGetHeight(self.datePickerView.frame))
            }, completion: { (succeeded: Bool) -> Void in
                
        })
    }
    
    func hideDatePicker() {
        UIView.animateWithDuration(0.3, animations: {
            self.datePickerView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.datePickerView.frame), CGRectGetHeight(self.datePickerView.frame))
            }, completion: { (succeeded: Bool) -> Void in
                self.datePickerView.alpha = 0.0
        })
    }
}

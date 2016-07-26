//
//  CategoryOverviewViewController.swift
//  ParseStarterProject
//
//  Created by Mathieu Skulason on 28/06/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

import UIKit

class CategoryOverviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let categoryTableView = UITableView()
    var selectedChampionship: Championship?
    var categoryArray: NSMutableArray?
    
    override func viewDidLoad() {
        
        categoryArray = NSMutableArray()
        
        let navBar = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64))
        navBar.backgroundColor = UIColor.flatTealColor()
        self.view.addSubview(navBar)
        
        let appTitleLabel = UILabel(frame: CGRectMake(100, 20, CGRectGetWidth(self.view.frame) - 200, 44))
        appTitleLabel.font = UIFont.maxwellBoldWithSize(21.0)
        appTitleLabel.text = "Categories"
        appTitleLabel.textAlignment = NSTextAlignment.Center
        appTitleLabel.textColor = UIColor.flatWhiteColor()
        self.view.addSubview(appTitleLabel)
        
        let addButton = UIButton(frame: CGRectMake(CGRectGetWidth(self.view.frame) - 90, 20, 75, 44))
        addButton.setTitle("+", forState: UIControlState.Normal)
        addButton.setTitleColor(UIColor.flatGreenColor(), forState: UIControlState.Normal)
        addButton.setTitleColor(UIColor.flatGreenColorDark(), forState: UIControlState.Highlighted)
        addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        addButton.titleLabel!.font = UIFont.maxwellWithSize(42.0)
        addButton.addTarget(self, action: "addChampionship", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(addButton)
        
        let backButton = UIButton(frame: CGRectMake(10, 20, 80, 44))
        backButton.setTitle("< Back", forState: UIControlState.Normal)
        backButton.setTitleColor(UIColor.flatRedColor(), forState: UIControlState.Normal)
        backButton.setTitleColor(UIColor.flatRedColorDark(), forState: UIControlState.Highlighted)
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        backButton.titleLabel!.font = UIFont.maxwellBoldWithSize(24.0)
        backButton.addTarget(self, action: "dismiss", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backButton)
        
        categoryTableView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        self.view.addSubview(categoryTableView)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.downloadCategoriesForChampionship(selectedChampionship!.objectId)
        
    }
    
    func downloadCategoriesForChampionship(championshipId: String!) {
        
        let progressHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHud.mode = MBProgressHUDMode.Indeterminate
        
        let query = PFQuery(className: "Category")
        query.whereKey("championshipId", equalTo: championshipId)
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            
            progressHud.hide(true)
            
            if error == nil && objects != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.categoryArray = NSMutableArray(array: objects!)
                    self.categoryTableView.reloadData()
                })
            }
            else {
                
            }
            
        })
    }
    
    func addChampionship() {
        self.performSegueWithIdentifier("addCategorySegue", sender: self)
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Table view delegate and data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier") as UITableViewCell!
        
        let category = categoryArray!.objectAtIndex(indexPath.row) as! LMCategory
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cellIdentifier")
            
            let disclosureLabel = UILabel(frame: CGRectMake(CGRectGetWidth(self.view.frame) - 50, 0, 40, 45))
            disclosureLabel.text = ">"
            disclosureLabel.font = UIFont.maxwellBoldWithSize(23.0)
            disclosureLabel.textColor = UIColor.flatSkyBlueColor()
            disclosureLabel.textAlignment = NSTextAlignment.Right
            cell?.addSubview(disclosureLabel)
            
        }
        
        cell.textLabel!.text = category.name
        cell!.textLabel!.font = UIFont.openSansBoldWithSize(15.0)
        cell!.textLabel!.textColor = UIColor.flatBlackColor()
      
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("teamMatchingSegue", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addCategorySegue" {
            let addCategoryVC = segue.destinationViewController as! AddCategory
            addCategoryVC.selectedChampionship = selectedChampionship
        }
        else if(segue.identifier == "teamMatchingSegue") {
            let teamMatchVC = segue.destinationViewController as! TeamMatchingAndSetupViewController
            teamMatchVC.selectedChampionship = selectedChampionship
            teamMatchVC.selectedCategory = categoryArray!.objectAtIndex(categoryTableView.indexPathForSelectedRow!.row) as? LMCategory
        }
        
        
    }
    
}

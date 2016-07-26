//
//  ChampionshipsOverview.swift
//  ParseStarterProject
//
//  Created by Mathieu Skulason on 28/06/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

import UIKit
import Parse
import Fabric
import Crashlytics

class ChampionshipsOverview: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let championshipTableView = UITableView()
    let dateFormatter = NSDateFormatter()
    var championshipArray: NSMutableArray?
    
    override func viewDidLoad() {
        
        championshipArray = NSMutableArray()
        
        let navBar = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64))
        navBar.backgroundColor = UIColor.flatTealColor()
        self.view.addSubview(navBar)
        
        let appTitleLabel = UILabel(frame: CGRectMake(100, 20, CGRectGetWidth(self.view.frame) - 200, 44))
        appTitleLabel.font = UIFont.maxwellBoldWithSize(21.0)
        appTitleLabel.text = "Championships"
        appTitleLabel.textAlignment = NSTextAlignment.Center
        appTitleLabel.textColor = UIColor.flatWhiteColor()
        self.view.addSubview(appTitleLabel)
        
        let logoutButton = UIButton(frame: CGRectMake(15, 20, 75, 44))
        logoutButton.setTitle("Logout", forState: UIControlState.Normal)
        logoutButton.setTitleColor(UIColor.flatRedColor(), forState: UIControlState.Normal)
        logoutButton.setTitleColor(UIColor.flatRedColorDark(), forState: UIControlState.Highlighted)
        logoutButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        logoutButton.titleLabel!.font = UIFont.maxwellBoldWithSize(21.0)
        logoutButton.addTarget(self, action: #selector(ChampionshipsOverview.logout), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(logoutButton)
        
        let addButton = UIButton(frame: CGRectMake(CGRectGetWidth(self.view.frame) - 90, 20, 75, 44))
        addButton.setTitle("+", forState: UIControlState.Normal)
        addButton.setTitleColor(UIColor.flatGreenColor(), forState: UIControlState.Normal)
        addButton.setTitleColor(UIColor.flatGreenColorDark(), forState: UIControlState.Highlighted)
        addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        addButton.titleLabel!.font = UIFont.maxwellWithSize(42.0)
        addButton.addTarget(self, action: #selector(ChampionshipsOverview.addChampionship), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(addButton)
        
        championshipTableView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)
        championshipTableView.delegate = self
        championshipTableView.dataSource = self
        self.view.addSubview(championshipTableView)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.downloadChampionships()
        
    }
    
    func downloadChampionships() {
        let query = PFQuery(className: "Championship")
        query.whereKey("userId", equalTo: PFUser.currentUser()!.objectId!)
        
        let progressHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHud.mode = MBProgressHUDMode.Indeterminate
        
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            
            progressHud.hide(true)
            
            if error == nil {
                self.championshipArray = NSMutableArray(array: objects!)
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.championshipTableView.reloadData()
                })
            } else {
                print("error downloading championships")
            }
        })
    }
    
    // MARK: Table view delegate and datasource
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return championshipArray!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier") as UITableViewCell?
        
        let championship = championshipArray!.objectAtIndex(indexPath.row) as! Championship
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cellIdentifier")
            
            let disclosureLabel = UILabel(frame: CGRectMake(CGRectGetWidth(self.view.frame) - 50, 0, 40, 45))
            disclosureLabel.text = ">"
            disclosureLabel.font = UIFont.maxwellBoldWithSize(23.0)
            disclosureLabel.textColor = UIColor.flatSkyBlueColor()
            disclosureLabel.textAlignment = NSTextAlignment.Right
            cell?.addSubview(disclosureLabel)
            
        }
        
        let startDate = championship.startDate
        let startDateString = dateFormatter.stringFromDate(startDate)
        let endDate = championship.endDate
        let endDateString = dateFormatter.stringFromDate(endDate)
        
        cell!.textLabel!.text = championship.name
        cell!.textLabel!.font = UIFont.openSansBoldWithSize(15.0)
        cell!.textLabel!.textColor = UIColor.flatBlackColor()
        cell!.detailTextLabel!.text = startDateString + " - " + endDateString
        cell!.detailTextLabel!.font = UIFont.openSansItalicWithSize(11.0)
        cell!.detailTextLabel!.textColor = UIColor.flatBlackColor()
        //cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.viewChampionship()
    }
    
    func viewChampionship() {
        self.performSegueWithIdentifier("categorySegue", sender: self)
    }
    
    func addChampionship() {
        self.performSegueWithIdentifier("addChampionshipSegue", sender: self)
    }
    
    func logout() {
        PFUser.logOutInBackgroundWithBlock({ (error: NSError?) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "categorySegue" {
            let categoryOverviewVC = segue.destinationViewController as! CategoryOverviewViewController
            categoryOverviewVC.selectedChampionship = championshipArray!.objectAtIndex(championshipTableView.indexPathForSelectedRow!.row) as? Championship
        }
    }
    
}

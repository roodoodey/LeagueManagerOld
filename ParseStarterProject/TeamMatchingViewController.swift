//
//  TeamMatchingViewController.swift
//  ParseStarterProject
//
//  Created by Mathieu Skulason on 28/06/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

import UIKit
import Parse

class TeamMatchingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RAReorderableLayoutDataSource, RAReorderableLayoutDelegate {
    
    var selectedCategory: PFObject?
    var selectedChampionship: PFObject?
    
    var roundCollectionView: UICollectionView?
    var matchCollectionView: UICollectionView?
    var roundsArray: NSMutableArray?
    

    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.flatWhiteColor()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(60, 40)
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        roundCollectionView = UICollectionView(frame: CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 40), collectionViewLayout: layout)
        roundCollectionView!.registerClass(RoundsCollectionViewCell.self, forCellWithReuseIdentifier: "cellIdentifier")
        roundCollectionView!.dataSource = self;
        roundCollectionView!.delegate = self
        roundCollectionView!.backgroundColor = UIColor.flatWhiteColor()
        self.view.addSubview(roundCollectionView!)
        
        
        let matchLayout = RAReorderableLayout()
        matchLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        //matchLayout.longPress!.minimumPressDuration = (0.3)
        
        matchCollectionView = UICollectionView(frame: CGRectMake(0, CGRectGetMaxY(roundCollectionView!.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(roundCollectionView!.frame)), collectionViewLayout: matchLayout)
        matchCollectionView!.registerClass(MatchCollectionViewCell.self, forCellWithReuseIdentifier: "matchIdentifier")
        matchCollectionView!.delegate = self
        matchCollectionView!.dataSource = self
        matchCollectionView!.backgroundColor = UIColor.flatBrownColorDark()
        self.view.addSubview(matchCollectionView!)
        
        
        let navBar = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64))
        navBar.backgroundColor = UIColor.flatTealColor()
        self.view.addSubview(navBar)
        
        let appTitleLabel = UILabel(frame: CGRectMake(100, 20, CGRectGetWidth(self.view.frame) - 200, 44))
        appTitleLabel.font = UIFont.maxwellBoldWithSize(21.0)
        appTitleLabel.text = "Matches"
        appTitleLabel.textAlignment = NSTextAlignment.Center
        appTitleLabel.textColor = UIColor.flatWhiteColor()
        self.view.addSubview(appTitleLabel)
        
        let addButton = UIButton(frame: CGRectMake(CGRectGetWidth(self.view.frame) - 90, 20, 75, 44))
        addButton.setTitle("+", forState: UIControlState.Normal)
        addButton.setTitleColor(UIColor.flatGreenColor(), forState: UIControlState.Normal)
        addButton.setTitleColor(UIColor.flatGreenColorDark(), forState: UIControlState.Highlighted)
        addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        addButton.titleLabel!.font = UIFont.maxwellWithSize(42.0)
        addButton.addTarget(self, action: Selector("addChampionship"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(addButton)
        
        let backButton = UIButton(frame: CGRectMake(10, 20, 80, 44))
        backButton.setTitle("< Back", forState: UIControlState.Normal)
        backButton.setTitleColor(UIColor.flatRedColor(), forState: UIControlState.Normal)
        backButton.setTitleColor(UIColor.flatRedColorDark(), forState: UIControlState.Highlighted)
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        backButton.titleLabel!.font = UIFont.maxwellBoldWithSize(24.0)
        backButton.addTarget(self, action: #selector(TeamMatchingViewController.dismiss), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backButton)
        
        
        
        
        
    }
    
    // MARK: Collection view delegate and data source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == roundCollectionView
        {
            return 7;
        }
        else if collectionView == matchCollectionView {
            return 10
        }
        
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == roundCollectionView {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellIdentifier", forIndexPath: indexPath) as! RoundsCollectionViewCell
            cell.roundNumberLabel!.text = "\(indexPath.row + 1)"
            
            return cell
        }
        else if collectionView == matchCollectionView {
            
            print("reloading indexpath: \(indexPath.row)")
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("matchIdentifier", forIndexPath: indexPath) as! MatchCollectionViewCell
            cell.backgroundColor = UIColor.flatWhiteColorDark()
            cell.teamNameLabel.text = "\(indexPath.row)"
            
            if indexPath.row % 2 != 0 {
                cell.invertInterfaceComponents(true, withAnimation: false)
            }
            else {
                cell.invertInterfaceComponents(false, withAnimation: false)
            }
            
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellIdentifier", forIndexPath: indexPath) 
        //cell.roundNumberLabel!.text = "\(indexPath.row + 1)"
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView == matchCollectionView {
            return CGSizeMake(CGRectGetWidth(self.view.frame) / 2.0, 60)
        }
        
        return CGSizeMake(60, 60)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: Reorderable layout
    
    
    func collectionView(collectionView: UICollectionView, atIndexPath: NSIndexPath, canMoveToIndexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, atIndexPath: NSIndexPath, didMoveToIndexPath toIndexPath: NSIndexPath) {
        
        for index in 0...9 {
            
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! MatchCollectionViewCell
            
            
        }
        
        collectionView.reloadSections(NSIndexSet(index: 0))
        
    }
    
}

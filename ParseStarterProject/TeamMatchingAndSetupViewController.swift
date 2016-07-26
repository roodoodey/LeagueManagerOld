//
//  TeamMatchingAndSetupViewController.swift
//  LeagueManager
//
//  Created by Mathieu Skulason on 11/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

import UIKit

class TeamMatchingAndSetupViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, AddTeamDelegate {

    
    // MARK: global UI elements and variables
    
    var roundCollectionView: UICollectionView?
    var matchCollectionView: UICollectionView?
    var teamTableView: UITableView?
    var addTeamView: AddTeamControl?
    var nextRoundButton: UIButton?
    var deleteRoundButton: UIButton?
    var startButton: UIButton?
    
    // MARK: data objects
    var selectedCategory: LMCategory?
    var selectedChampionship: Championship?
    // the highest round possible, if any exist.
    var selectedRound: LMRound?
    
    var matchArray: NSMutableArray?
    var roundArray: NSMutableArray?
    var teamArray: NSMutableArray?
    
    var viewModel: TeamMatchmakingViewModel?
    
    var chooseArrangement: UIView? = nil
    var snapshot: UIView? = nil
    var sourceIndexPath: NSIndexPath? = nil
    
    // MARK: View setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        matchArray = NSMutableArray()
        roundArray = NSMutableArray()
        teamArray = NSMutableArray()
        viewModel = TeamMatchmakingViewModel()
        
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.flatWhiteColor()
        
        
        // Mark: Navigation bar initializations
        
        let navBar = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64))
        navBar.backgroundColor = UIColor.flatTealColor()
        self.view.addSubview(navBar)
        
        let appTitleLabel = UILabel(frame: CGRectMake(100, 20, CGRectGetWidth(self.view.frame) - 200, 44))
        appTitleLabel.font = UIFont.maxwellBoldWithSize(21.0)
        appTitleLabel.text = "Matches"
        appTitleLabel.textAlignment = NSTextAlignment.Center
        appTitleLabel.textColor = UIColor.flatWhiteColor()
        self.view.addSubview(appTitleLabel)
        
        /*
        let addButton = UIButton(frame: CGRectMake(CGRectGetWidth(self.view.frame) - 90, 20, 75, 44))
        addButton.setTitle("+", forState: UIControlState.Normal)
        addButton.setTitleColor(UIColor.flatGreenColor(), forState: UIControlState.Normal)
        addButton.setTitleColor(UIColor.flatGreenColorDark(), forState: UIControlState.Highlighted)
        addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        addButton.titleLabel!.font = UIFont.maxwellWithSize(42.0)
        addButton.addTarget(self, action: "addChampionship", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(addButton)
        */
        
        let backButton = UIButton(frame: CGRectMake(10, 20, 80, 44))
        backButton.setTitle("< Back", forState: UIControlState.Normal)
        backButton.setTitleColor(UIColor.flatRedColor(), forState: UIControlState.Normal)
        backButton.setTitleColor(UIColor.flatRedColorDark(), forState: UIControlState.Highlighted)
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        backButton.titleLabel!.font = UIFont.maxwellBoldWithSize(24.0)
        backButton.addTarget(self, action: #selector(TeamMatchingAndSetupViewController.dismiss), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backButton)
        
        
        self.downloadRounds()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Download functions
    
    func downloadRounds() {
        
        let progressHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHud.mode = MBProgressHUDMode.Indeterminate
        
        let roundQuery = PFQuery(className: "Round")
        if selectedCategory != nil {
            roundQuery.whereKey("categoryId", equalTo: selectedCategory!.objectId!)
        }
        
        
        roundQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
        
            if error == nil && objects != nil {
                
                dispatch_async(dispatch_get_main_queue(), {
                    progressHud.hide(true)
                    self.roundArray = NSMutableArray(array: objects!)
                    self.roundArray = NSMutableArray(array: self.viewModel!.sortRounds(self.roundArray!))
                    self.selectedRound = self.roundArray?.lastObject as? LMRound
                    print("number of rounds \(self.roundArray!.count)")
                    self.layoutViewBasedOn()
                })
            }
            
        })
        
    }
    
    func downloadMatches() {
        
        let progressHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHud.mode = MBProgressHUDMode.Indeterminate
        
        let matchQuery = PFQuery(className: "Match")
        print("selected category \(selectedCategory?.objectId)")
        matchQuery.whereKey("categoryId", equalTo: selectedCategory!.objectId!)
        matchQuery.limit = 1000
        
        matchQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil && objects!.count != 0 {

                dispatch_async(dispatch_get_main_queue(), {
                    
                    progressHud.hide(true)
                    self.matchArray = NSMutableArray(array: objects!)
                    print("matches are \(self.matchArray?.count)")
                    self.matchCollectionView!.reloadData()
                    
                })
            }
            else {
                
            }
            
        })
        
    }
    
    func downloadTeams() {
        
        let progressHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHud.mode = MBProgressHUDMode.Indeterminate
        
        let teamQuery = PFQuery(className: "Team")
        teamQuery.whereKey("categoryId", equalTo: selectedCategory!.objectId!)
        
        teamQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil && objects != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    progressHud.hide(true)
                    
                    print("team object \(self.selectedCategory!.objectId) and number of results \(objects?.count)")
                    self.teamArray = NSMutableArray(array: objects!)
                    self.teamTableView?.reloadData()
                    self.matchCollectionView?.reloadData()
                })
            }
            
        })
        
    }
    
    // MARK: View layouting
    
    func layoutViewBasedOn() {
        
        if roundArray?.count == 0 {
            // MARK: team table view, add team and start round
            
            startButton = UIButton(frame: CGRectMake(CGRectGetMidX(self.view.frame) - 50, 64 + 10, 100, 40))
            startButton!.layer.borderWidth = 1.5
            startButton!.layer.borderColor = UIColor.flatRedColorDark().CGColor
            startButton!.layer.cornerRadius = 15.0
            startButton!.setTitle("Start", forState: UIControlState.Normal)
            startButton!.setTitleColor(UIColor.flatRedColorDark(), forState: UIControlState.Normal)
            startButton!.setTitleColor(UIColor.flatRedColor(), forState: UIControlState.Highlighted)
            startButton!.addTarget(self, action: #selector(TeamMatchingAndSetupViewController.startMatchmaking), forControlEvents: UIControlEvents.TouchUpInside)
            startButton!.titleLabel?.font = UIFont.maxwellBoldWithSize(21)
            self.view.addSubview(startButton!)
            
            let removeTeamButton = UIButton(frame: CGRectMake(10, 64 + 15, 30, 30))
            removeTeamButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            removeTeamButton.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
            removeTeamButton.titleLabel?.textAlignment = NSTextAlignment.Center
            removeTeamButton.setTitle("-", forState: UIControlState.Normal)
            removeTeamButton.setTitleColor(UIColor.flatRedColorDark(), forState: UIControlState.Normal)
            removeTeamButton.addTarget(self, action: #selector(TeamMatchingAndSetupViewController.deleteSelectedTeam), forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(removeTeamButton)
            
            let addTeamButton = UIButton(frame: CGRectMake(CGRectGetWidth(self.view.frame) - 50, 64 + 15, 30, 30))
            addTeamButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            addTeamButton.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
            addTeamButton.titleLabel?.textAlignment = NSTextAlignment.Center
            addTeamButton.setTitle("+", forState: UIControlState.Normal)
            addTeamButton.setTitleColor(UIColor.flatGreenColor(), forState: UIControlState.Normal)
            addTeamButton.titleLabel?.font = UIFont.maxwellWithSize(36)
            addTeamButton.addTarget(self, action: #selector(TeamMatchingAndSetupViewController.showAddTeamView), forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(addTeamButton)
            
            teamTableView = UITableView(frame: CGRectMake(0, CGRectGetMaxY(startButton!.frame) + 10, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(startButton!.frame) - 10), style: UITableViewStyle.Plain)
            teamTableView?.delegate = self
            teamTableView?.dataSource = self
            teamTableView?.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(TeamMatchingAndSetupViewController.longPressGestureForCell(_:)))
            view.addGestureRecognizer(longPress)

            self.view.addSubview(teamTableView!)
            
            self.downloadTeams()
        }
        else {
            // MARK: round collection view initialization
            
            if roundCollectionView == nil {
                let layout = UICollectionViewFlowLayout()
                layout.itemSize = CGSizeMake(60, 40)
                layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
                layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
                
                roundCollectionView = UICollectionView(frame: CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 40), collectionViewLayout: layout)
                roundCollectionView!.registerClass(RoundsCollectionViewCell.self, forCellWithReuseIdentifier: "roundCell")
                roundCollectionView!.dataSource = self;
                roundCollectionView!.delegate = self
                roundCollectionView!.backgroundColor = UIColor.flatWhiteColor()
                roundCollectionView!.alwaysBounceHorizontal = true
                self.view.addSubview(roundCollectionView!)
            }
            else {
                roundCollectionView?.alpha = 1
            }
            
            if nextRoundButton == nil {
                nextRoundButton = UIButton(frame: CGRectMake(CGRectGetMidX(self.view.frame) - 60, CGRectGetMaxY(roundCollectionView!.frame) + 10, 120, 30))
                nextRoundButton!.layer.borderWidth = 2.0
                nextRoundButton!.layer.borderColor = UIColor.flatGreenColor().CGColor
                nextRoundButton!.layer.cornerRadius = 15.0
                nextRoundButton!.setTitle("Next Round", forState: UIControlState.Normal)
                nextRoundButton!.setTitleColor(UIColor.flatGreenColor(), forState: UIControlState.Normal)
                nextRoundButton!.setTitleColor(UIColor.flatGreenColorDark(), forState: UIControlState.Highlighted)
                nextRoundButton!.addTarget(self, action: #selector(TeamMatchingAndSetupViewController.nextRoundPressed), forControlEvents: UIControlEvents.TouchUpInside)
                nextRoundButton!.titleLabel?.font = UIFont.maxwellBoldWithSize(21)
                self.view.addSubview(nextRoundButton!)
            }
            else {
                nextRoundButton?.alpha = 1
            }
            
            if deleteRoundButton == nil {
                deleteRoundButton = UIButton(frame: CGRectMake(CGRectGetWidth(self.view.frame) - 90, CGRectGetMaxY(roundCollectionView!.frame) + 10, 80, 30))
                deleteRoundButton!.layer.borderWidth = 2.0
                deleteRoundButton!.layer.borderColor = UIColor.flatRedColor().CGColor
                deleteRoundButton!.layer.cornerRadius = 15.0
                deleteRoundButton!.setTitle("Delete", forState: UIControlState.Normal);
                deleteRoundButton!.setTitleColor(UIColor.flatRedColor(), forState: UIControlState.Normal)
                deleteRoundButton!.setTitleColor(UIColor.flatRedColorDark(), forState: UIControlState.Highlighted)
                deleteRoundButton!.titleLabel?.font = UIFont.maxwellBoldWithSize(21)
                deleteRoundButton!.addTarget(self, action: #selector(TeamMatchingAndSetupViewController.deleteRoundPressed), forControlEvents: UIControlEvents.TouchUpInside)
                self.view.addSubview(deleteRoundButton!)
            }
            else {
                deleteRoundButton?.alpha = 1
            }
            
            
            if matchCollectionView == nil {
                let matchLayout = SeparatorLayout()
                matchLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame) / 2.0, 70)
                matchLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
                matchLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
                matchLayout.registerClass(GraySeparatorCollectionReusableView.self, forDecorationViewOfKind: "Separator")
                matchLayout.minimumLineSpacing = 2
                
                matchCollectionView = UICollectionView(frame: CGRectMake(0, CGRectGetMaxY(nextRoundButton!.frame) + 10, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(nextRoundButton!.frame) - 10), collectionViewLayout: matchLayout)
                matchCollectionView!.registerClass(MatchCollectionViewCell.self, forCellWithReuseIdentifier: "matchCell")
                matchCollectionView!.dataSource = self
                matchCollectionView!.delegate = self
                matchCollectionView!.backgroundColor = UIColor.flatWhiteColor()
                matchCollectionView?.alwaysBounceVertical = true;
                self.view.addSubview(matchCollectionView!)
            }
            else {
                matchCollectionView?.alpha = 1
            }
            
            self.downloadTeams()
            self.downloadMatches()
        }
    }
    
    // MARK: Button actions
    
    func deleteSelectedTeam() {
        if teamTableView?.indexPathForSelectedRow != nil && teamArray != nil {
            let team = teamArray!.objectAtIndex(teamTableView!.indexPathForSelectedRow!.row) as! LMTeam
            let index = teamTableView!.indexPathForSelectedRow!.row
            
            let progressHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            progressHud.mode = MBProgressHUDMode.Indeterminate
            
            team.deleteInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
            
                dispatch_async(dispatch_get_main_queue(), {
                    
                    progressHud.hide(true)
                    
                    if succeeded {
                        self.teamArray?.removeObjectAtIndex(index)
                        self.teamTableView?.reloadData()
                    }
                })
                
            })
        }
    }
    
    func showAddTeamView() {
        
        print("show add team view")
        
        if addTeamView == nil {
            addTeamView = AddTeamControl()
            addTeamView?.selectedCategory = self.selectedCategory
            addTeamView?.selectedChampionship = self.selectedChampionship
            addTeamView!.frame = CGRectMake(CGRectGetMidX(self.view.frame) - addTeamView!.frame.size.width / 2.0, CGRectGetMidY(self.view.frame) - addTeamView!.frame.size.height / 2.0, CGRectGetWidth(addTeamView!.frame), CGRectGetHeight(addTeamView!.frame));
            addTeamView?.delegate = self
            self.view.addSubview(addTeamView!)
            
        }
        addTeamView?.alpha = 1.0
        self.view.bringSubviewToFront(addTeamView!)
        addTeamView!.acceptButton.addTarget(self, action: #selector(TeamMatchingAndSetupViewController.addTeam), forControlEvents: UIControlEvents.TouchUpInside)
        addTeamView!.dismissButton.addTarget(self, action: #selector(TeamMatchingAndSetupViewController.cancelAddTeam), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    
    func addTeam() {
        
        addTeamView!.saveTeamWithCompletion({ ( succeeded: Bool, newTeam: PFObject!, error: NSError!) -> Void in
            
            print("added team")
            
            if succeeded {
                self.addTeamView?.removeFromSuperview()
                self.addTeamView = nil
                self.teamArray?.addObject(newTeam)
                self.teamTableView?.reloadData()
            }
            else {
                let alert = UIAlertController(title: "Error", message: "Couldn't save team, trye again", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
                    
                    alert.dismissViewControllerAnimated(true, completion: nil)
                    
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
        
    }
    
    func cancelAddTeam() {
        addTeamView?.removeFromSuperview()
    }
    
    func startRandomMatchmaking() {
        
        if startButton != nil {
            startButton?.alpha = 0
        }
        
        if chooseArrangement != nil {
            chooseArrangement?.alpha = 0
        }
        
        if teamArray!.count % 2 == 0 && roundArray!.count == 0 {
            
            let progressHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            progressHud.mode = MBProgressHUDMode.Indeterminate
            
            let firstRound = LMRound.object()
            firstRound.categoryId = selectedCategory!.objectId!
            firstRound.championshipId = selectedChampionship!.objectId!
            firstRound.roundNumber = NSNumber(int: 1)
            
            firstRound.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                
                if succeeded {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        progressHud.hide(true)
                        
                        self.matchArray = NSMutableArray(array: self.viewModel!.randomMatchesFromTeams(self.teamArray, roundId: firstRound.objectId!, categoryId: self.selectedCategory!.objectId!))
                        
                        PFObject.saveAllInBackground(NSArray(array: self.matchArray!) as [AnyObject], block: ({ (succeeded: Bool, error: NSError?) -> Void in
                            
                            
                            if succeeded {
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    
                                    print("saved all matches in background")
                                    
                                    UIView.animateWithDuration((0.3), animations: {
                                        
                                        self.teamTableView?.alpha = 0
                                        
                                        }, completion: ({ (finished: Bool) -> Void in
                                            
                                            self.roundArray?.addObject(firstRound)
                                            self.selectedRound = self.roundArray?.lastObject as? LMRound
                                            self.layoutViewBasedOn()
                                            
                                        }))
                                    
                                })
                                
                            }
                            else {
                                
                            }
                        }))
                        
                        
                    })
                }
                else {
                    
                    
                    
                }
                
            })
            
        }
        else {
            let alert = UIAlertController(title: "Error", message: "You need a pair number of teams for the algorithm to work.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Button", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }

    }
    
    func startOrderedMatchmaking() {
        
        if startButton != nil {
            startButton?.alpha = 0
        }
        
        if chooseArrangement != nil {
            chooseArrangement?.alpha = 0
        }
        
        if teamArray!.count % 2 == 0 && roundArray!.count == 0 {
            
            let progressHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            progressHud.mode = MBProgressHUDMode.Indeterminate
            
            let firstRound = LMRound.object()
            firstRound.categoryId = selectedCategory!.objectId!
            firstRound.championshipId = selectedChampionship!.objectId!
            firstRound.roundNumber = NSNumber(int: 1)
            
            firstRound.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                
                if succeeded {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        progressHud.hide(true)
                        
                        self.matchArray = NSMutableArray(array: self.viewModel!.orderedMatchesFromTeams(self.teamArray, roundId: firstRound.objectId!, categoryId: self.selectedCategory!.objectId!))
                        //self.matchArray = NSMutableArray(array: self.viewModel!.randomMatchesFromTeams(self.teamArray, roundId: firstRound.objectId!, categoryId: self.selectedCategory!.objectId!))
                        
                        PFObject.saveAllInBackground(NSArray(array: self.matchArray!) as [AnyObject], block: ({ (succeeded: Bool, error: NSError?) -> Void in
                            
                            
                            if succeeded {
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    
                                    print("saved all matches in background")
                                    
                                    UIView.animateWithDuration((0.3), animations: {
                                        
                                        self.teamTableView?.alpha = 0
                                        
                                        }, completion: ({ (finished: Bool) -> Void in
                                            
                                            self.roundArray?.addObject(firstRound)
                                            self.selectedRound = self.roundArray?.lastObject as? LMRound
                                            self.layoutViewBasedOn()
                                            
                                        }))
                                    
                                })
                                
                            }
                            else {
                                
                            }
                        }))
                        
                        
                    })
                }
                else {
                    
                    
                    
                }
                
            })
            
        }
        else {
            let alert = UIAlertController(title: "Error", message: "You need a pair number of teams for the algorithm to work.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Button", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
                
                alert.dismissViewControllerAnimated(true, completion: nil)
                
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func startMatchmaking() {
        
        if chooseArrangement == nil {
            chooseArrangement = UIView(frame: CGRectMake(CGRectGetMidX(self.view.frame) - 120, CGRectGetMidY(self.view.frame) - 100, 240, 200))
            chooseArrangement?.layer.borderColor = UIColor.flatTealColor().CGColor
            chooseArrangement?.layer.borderWidth = 2
            chooseArrangement?.layer.cornerRadius = 12.0
            chooseArrangement?.layer.masksToBounds = true
            chooseArrangement?.backgroundColor = UIColor.flatWhiteColor()
            self.view.addSubview(chooseArrangement!)
            
            let headerView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(chooseArrangement!.frame), 40))
            headerView.backgroundColor = UIColor.flatTealColor()
            chooseArrangement!.addSubview(headerView)
            
            let headerTitle = UILabel(frame: CGRectMake(0, 0, CGRectGetWidth(headerView.frame), CGRectGetHeight(headerView.frame)))
            headerTitle.font = UIFont.maxwellBoldWithSize(21)
            headerTitle.text = "Choose Ordering"
            headerTitle.textColor = UIColor.flatWhiteColor()
            headerTitle.textAlignment = NSTextAlignment.Center
            headerView.addSubview(headerTitle)
            
            let matchmakeOrderedButton = UIButton()
            matchmakeOrderedButton.frame = CGRectMake(CGRectGetMidX(headerView.frame) - 100, CGRectGetHeight(headerView.frame) + 24, 200, 40);
            matchmakeOrderedButton.setTitle("Use team ordering", forState: UIControlState.Normal)
            matchmakeOrderedButton.setTitleColor(UIColor.flatGreenColor(), forState: UIControlState.Normal)
            matchmakeOrderedButton.titleLabel?.font = UIFont.openSansBoldWithSize(16)
            matchmakeOrderedButton.setTitleColor(UIColor.flatGreenColorDark(), forState: UIControlState.Highlighted)
            matchmakeOrderedButton.addTarget(self, action: #selector(TeamMatchingAndSetupViewController.startOrderedMatchmaking), forControlEvents: UIControlEvents.TouchUpInside)
            chooseArrangement?.addSubview(matchmakeOrderedButton)
            
            let matchmakeRandomButton = UIButton()
            matchmakeRandomButton.frame = CGRectMake(CGRectGetMidX(headerView.frame) - 100, CGRectGetMaxY(matchmakeOrderedButton.frame) + 24, 200, 40)
            matchmakeRandomButton.setTitle("Use random ordering", forState: UIControlState.Normal)
            matchmakeRandomButton.setTitleColor(UIColor.flatSkyBlueColor(), forState: UIControlState.Normal)
            matchmakeRandomButton.setTitleColor(UIColor.flatSkyBlueColorDark(), forState: UIControlState.Highlighted)
            matchmakeRandomButton.titleLabel?.font = UIFont.openSansBoldWithSize(16)
            matchmakeRandomButton.addTarget(self, action: #selector(TeamMatchingAndSetupViewController.startRandomMatchmaking), forControlEvents: UIControlEvents.TouchUpInside)
            chooseArrangement?.addSubview(matchmakeRandomButton)
            
        }
        else {
            self.view.bringSubviewToFront(chooseArrangement!)
            chooseArrangement?.alpha = 1
        }
        
    }
    
    func deleteRoundPressed() {
        
        if self.selectedRound == roundArray?.lastObject as? LMRound {
            
            let matchesForRound = viewModel?.findMatchesWithRound(self.selectedRound!, allMatches: matchArray!)
            let roundToDelete = NSMutableArray(array: matchesForRound!)
            roundToDelete.addObject(self.selectedRound!)
            
            let progressHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            progressHud.mode = MBProgressHUDMode.Indeterminate
            
            PFObject.deleteAllInBackground(roundToDelete as [AnyObject], block: { (succeeded: Bool, error: NSError?) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    
                    progressHud.hide(true)
                    
                    if succeeded {
                        self.roundArray!.removeObject(self.selectedRound!)
                        self.matchArray!.removeObjectsInArray(matchesForRound! as [AnyObject])
                        
                        if self.roundArray?.count != 0 {
                            self.selectedRound = self.roundArray?.lastObject as? LMRound
                            self.roundCollectionView?.reloadData()
                            self.matchCollectionView?.reloadData()
                        }
                        else {
                            self.roundCollectionView?.alpha = 0
                            self.matchCollectionView?.alpha = 0
                            self.deleteRoundButton?.alpha = 0
                            self.nextRoundButton?.alpha = 0
                            self.teamTableView?.alpha = 1
                            self.startButton?.alpha = 1
                        }
                        
                        
                    }
                    else {
                        let alert = UIAlertView(title: "Error", message: "Unable to delete round: \(error?.localizedDescription)", delegate: nil, cancelButtonTitle: "Done")
                        alert.show()
                    }
                    
                })
            })
            
        }
        
    }
    
    func nextRoundPressed() {
        print("next round pressed")
        
        viewModel?.updateTeamValuesForCategory(selectedCategory, allMatches: matchArray, allTeams: teamArray)
        
        PFObject.saveAllInBackground(NSArray(array: teamArray!) as [AnyObject], block:( { (succeeded: Bool, error: NSError?) -> Void in
            
            if succeeded {
                print("saved all updated values in the background")
                dispatch_async(dispatch_get_main_queue(), {
                    let matchmakedTeams = self.viewModel?.matchmakeTeams(self.teamArray, theMatchmakedTeams: NSMutableArray(), allMatches: self.matchArray, allTeams: self.teamArray)
                    
                    print("matchmaked teams are \(matchmakedTeams)")
                    
                    if matchmakedTeams == nil {
                        let alert = UIAlertView(title: "Error", message: "Couldn't matchmake teams", delegate: nil, cancelButtonTitle: "Done")
                        alert.show()
                    }
                    else {
                        let nextRounds = self.viewModel?.createNewRoundForMatchmakedTeams(self.roundArray!, selectedChampionship: self.selectedChampionship!, selectedCategory: self.selectedCategory!)
                        
                        nextRounds?.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                            
                            if succeeded {
                                dispatch_async(dispatch_get_main_queue(), {
                                    
                                    let matches = self.viewModel?.createMatchesFromMatchmakedTeams(matchmakedTeams, currentRound: nextRounds!, selectedChampionship: self.selectedChampionship!, selectedCategory: self.selectedCategory!)
                                    
                                    PFObject.saveAllInBackground(matches as? [AnyObject], block: ( { (succeeded: Bool, error: NSError?) -> Void in
                                        
                                        if succeeded {
                                            dispatch_async(dispatch_get_main_queue(), {
                                                self.roundArray?.addObject(nextRounds!)
                                                self.matchArray?.addObjectsFromArray(matches as! [LMMatch])
                                                self.selectedRound = nextRounds!
                                                self.matchCollectionView?.reloadData()
                                                self.roundCollectionView?.reloadData()
                                            })
                                        }
                                        else {
                                            let alert = UIAlertView(title: "Error", message: "Could not save new matches after matchmaking", delegate: nil, cancelButtonTitle: "Ok")
                                            alert.show()
                                        }
                                        
                                    }))
                                })
                            }
                            else {
                                
                                let alert = UIAlertView(title: "Error", message: "Could not save new round after matchmaking", delegate: nil, cancelButtonTitle: "Ok")
                                alert.show()
                                
                            }
                            
                        })
                    }
                    
                    
                })
            }
            else {
                print("did not manage to save all values in the background")
            }
            
        }))
        
    }
    
    
    // MARK: Text Field Delegate
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        print("text field should return")
        
        let pos: Int = Int(textField.tag / 2)
    
        let matchObject = self.matchArray?.objectAtIndex(pos) as! LMMatch
        
        if textField.tag % 2 == 0 {
            let numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = NSNumberFormatterStyle.NoStyle
            matchObject.teamOneGoals = numberFormatter.numberFromString(textField.text!)
        }
        else {
            let numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = NSNumberFormatterStyle.NoStyle
            matchObject.teamTwoGoals = numberFormatter.numberFromString(textField.text!)
        }
        
        return true
    }
    
    
    // MARK: Add Team Delegate and actions
    
    func showImagePicker(imagePicker: UIImagePickerController!) {
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func dismissImagePicker(imagePicker: UIImagePickerController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: table view delegate and data source
    
    func longPressGestureForCell(longPress: UILongPressGestureRecognizer) {
        
        let state = longPress.state
        
        let location = longPress.locationInView(teamTableView)
        let indexPath = teamTableView?.indexPathForRowAtPoint(location)
        
        //snapshot = nil
        //sourceIndexPath = nil
        
        switch (state) {
            
        case UIGestureRecognizerState.Began:
            
            if indexPath != nil {
                sourceIndexPath = indexPath
                
                let cell = teamTableView?.cellForRowAtIndexPath(indexPath!)
                
                // take a snapshot of the selected row using helper method
                snapshot = self.customSnapshotFromView(cell!)
                
                // Add the snapshot as subview, center at cell's center..
                var center = cell?.center
                snapshot?.center = center!
                snapshot?.alpha = 0
                teamTableView?.addSubview(snapshot!)
                
                UIView.animateWithDuration(0.25, animations: {
                    
                    // Offset for gesture location.
                    center?.y = location.y
                    self.snapshot?.center = center!
                    self.snapshot?.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    self.snapshot?.alpha = (0.98)
                    
                    // Fade out
                    cell?.alpha = 0
                    
                    },
                    completion: { (succeeded: Bool) -> Void in
                    
                        cell?.hidden = true
                        
                })
            }
            
            break
            
        case UIGestureRecognizerState.Changed:
            
                var center = snapshot?.center
                center?.y = location.y
                self.snapshot?.center = center!
                
                // Is destination valid and is it different from source?
                if indexPath != nil && !indexPath!.isEqual(sourceIndexPath) {
                    teamArray?.exchangeObjectAtIndex(indexPath!.row, withObjectAtIndex: sourceIndexPath!.row)
                    teamTableView?.moveRowAtIndexPath(sourceIndexPath!, toIndexPath: indexPath!)
                    sourceIndexPath = indexPath
                }
                
            break
            
        default:
            
            var cell: UITableViewCell? = nil
            
            if sourceIndexPath != nil {
                cell = teamTableView?.cellForRowAtIndexPath(sourceIndexPath!)
            }
            
            cell?.hidden = false
            cell?.alpha = 0
            
            UIView.animateWithDuration(0.25, animations: {
                
                self.snapshot?.center = cell!.center
                self.snapshot?.transform = CGAffineTransformIdentity
                self.snapshot?.alpha = 0
                
                // Undo fade out
                cell?.alpha = 1
                
                }, completion: { (succeeded: Bool) -> Void in
                    
                    self.sourceIndexPath = nil
                    self.snapshot?.removeFromSuperview()
                    self.snapshot = nil
                    
            })
            
            break
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamArray!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("identifier") as UITableViewCell!
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "identifier")
            cell.textLabel?.font = UIFont.openSansBoldWithSize(15)
            cell.textLabel?.textColor = UIColor.blackColor()
        }
        
        let object = teamArray?.objectAtIndex(indexPath.row) as! LMTeam
        
        if object.teamName != nil {
            cell.textLabel?.text = object.teamName
        }
        
        return cell
    }
    
    
    
    // MARK: Collection view delegate and data source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == roundCollectionView
        {
            return roundArray!.count
        }
        else if collectionView == matchCollectionView {
            print("match array: \(matchArray?.count)")
            
            let matchesForRound = viewModel?.findMatchesWithRound(selectedRound!, allMatches: matchArray!)
            
            return matchesForRound!.count * 2
        }
        
        
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == roundCollectionView {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("roundCell", forIndexPath: indexPath) as! RoundsCollectionViewCell
            
            let object = roundArray?.objectAtIndex(indexPath.row) as! LMRound
            
            let roundNumber = object.roundNumber
            
            cell.roundNumberLabel!.text = roundNumber.stringValue
            
            if self.selectedRound == object {
                cell.roundNumberLabel.textColor = UIColor.flatGreenColor()
            }
            else {
                cell.roundNumberLabel.textColor = UIColor.flatBlackColor()
            }
            
            return cell
        }
        else if(collectionView == matchCollectionView) {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("matchCell", forIndexPath: indexPath) as! MatchCollectionViewCell
            
            
            var matchesForRound = viewModel?.findMatchesWithRound(selectedRound!, allMatches: matchArray!)
            matchesForRound = viewModel?.sortMatchesByNumber(matchesForRound)
            
            let matchObject = matchesForRound?.objectAtIndex(indexPath.row / 2) as! LMMatch
            cell.scoreTextField.tag = indexPath.row
            
            let numberFormatter = NSNumberFormatter ()
            numberFormatter.numberStyle = NSNumberFormatterStyle.NoStyle
            
            if indexPath.row % 2 == 0 {
                
                let teamOneId = matchObject.teamOneId
                let teamOne = viewModel?.findTeamWithId(teamOneId, inArray: self.teamArray)
                
                cell.matchObject = matchObject
                cell.isTeamOne = true
                cell.teamNameLabel?.text = teamOne?.teamName
                cell.scoreTextField.text = numberFormatter.stringFromNumber(matchObject.teamOneGoals)
                cell.invertInterfaceComponents(false, withAnimation: false)
                
                
                cell.saveScoreCompletion({ (succeeded: Bool, someError: NSError?) -> Void in
                    
                    if (someError != nil) {
                        let alert = UIAlertView(title: "Error", message: "input error", delegate: nil, cancelButtonTitle: "Ok")
                        alert.show()
                    }
                    else {
                        let alert = UIAlertView(title: "Saved", message: "Saved match", delegate: nil, cancelButtonTitle: "Ok")
                        alert.show()
                    }
                    
                })
                
            }
            else {
                
                let teamTwoId = matchObject.teamTwoId
                let teamTwo = viewModel?.findTeamWithId(teamTwoId, inArray: self.teamArray)
                
                cell.matchObject = matchObject
                cell.isTeamOne = false
                cell.teamNameLabel?.text = teamTwo?.teamName
                cell.scoreTextField.text = numberFormatter.stringFromNumber(matchObject.teamTwoGoals)
                cell.invertInterfaceComponents(true, withAnimation: false)
                
                cell.saveScoreCompletion({ (succeeded: Bool, someError: NSError?) -> Void in
                    
                    if someError != nil {
                        let alert = UIAlertView(title: "Error", message: "input error", delegate: nil, cancelButtonTitle: "Ok")
                        alert.show()
                    }
                    else {
                        let alert = UIAlertView(title: "Saved", message: "Match saved", delegate: nil, cancelButtonTitle: "Ok")
                        alert.show()
                    }
                    
                })
            }
            
            
            return cell
            
        }
        
    
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellIdentifier", forIndexPath: indexPath) 
        //cell.roundNumberLabel!.text = "\(indexPath.row + 1)"
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("did select item at indexPath \(indexPath.row)")
        
        if collectionView == roundCollectionView {
            self.selectedRound = self.roundArray?.objectAtIndex(indexPath.row) as? LMRound
            //println("selected round \(selectedRound)")
            
            if selectedRound == self.roundArray?.lastObject as? LMRound {
                deleteRoundButton?.hidden = false;
            }
            else {
                deleteRoundButton?.hidden = true;
            }
            
            self.roundCollectionView?.reloadData()
            self.matchCollectionView?.reloadData()
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if collectionView == roundCollectionView {
            return CGSizeMake(60, 40)
        }
        else if collectionView == matchCollectionView {
            return CGSizeMake(CGRectGetWidth(self.view.frame) / 2.0, 70)
        }
        
        return CGSizeMake(60, 60)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func customSnapshotFromView(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let snapshot = UIImageView(image: image)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0
        snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
        snapshot.layer.shadowRadius = 5
        snapshot.layer.shadowOpacity = (0.4)
        
        return snapshot
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

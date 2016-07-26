//
//  TeamMatchmakingViewModel.swift
//  LeagueManager
//
//  Created by Mathieu Skulason on 12/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

import UIKit

class TeamMatchmakingViewModel: NSObject {
   
    var roundsArray: NSArray?
    var matchesArray: NSArray?
    var teamsArray: NSArray?
    
    var selectedRoundIndex: Int?
    
    func orderedMatchesFromTeams(teams: NSArray!, roundId: String, categoryId: String) -> NSArray {
        
        var mutableTeams = NSMutableArray(array: teams)
        print("Number of teams for random matchmaking \(teams.count)")
        let mutableMatches = NSMutableArray()
        
        for var i = 0; i < teams.count; i = i + 2 {
            
            let teamOne = teams.objectAtIndex(i) as! LMTeam
            //mutableTeams.removeObjectAtIndex(i)
            
            let teamTwo = teams.objectAtIndex(i + 1) as! LMTeam
            //mutableTeams.removeObjectAtIndex(i + 1)
            
            let newMatch = LMMatch.object()
            newMatch.teamOneId = teamOne.objectId
            newMatch.teamTwoId = teamTwo.objectId
            newMatch.matchNumber = NSNumber(int: mutableMatches.count + 1)
            newMatch.roundId = roundId
            newMatch.categoryId = categoryId
            newMatch.teamOneGoals = NSNumber(int: 0)
            newMatch.teamTwoGoals = NSNumber(int: 0)
            
            mutableMatches.addObject(newMatch)
        }
        
        return mutableMatches
    }
    
    func randomMatchesFromTeams(teams: NSArray!, roundId: String, categoryId: String) -> NSArray {
        
        let mutableTeams = NSMutableArray(array: teams)
        print("number of teams for random matchmaking: \(teams.count)")
        let mutableMatches = NSMutableArray()
        
        while mutableTeams.count != 0 {
            
            print("matchmaking teams")
            
            let randPosTeamOne: Int = Int(arc4random_uniform(UInt32(mutableTeams.count)))
            let teamOne = mutableTeams.objectAtIndex(randPosTeamOne) as! LMTeam
            mutableTeams.removeObjectAtIndex(randPosTeamOne)
            
            let randPosTeamTwo: Int = Int(arc4random_uniform(UInt32(mutableTeams.count)))
            let teamTwo = mutableTeams.objectAtIndex(randPosTeamTwo) as! LMTeam
            mutableTeams.removeObjectAtIndex(randPosTeamTwo)
            
            let newMatch = LMMatch.object()
            newMatch.teamOneId = teamOne.objectId
            newMatch.teamTwoId = teamTwo.objectId
            newMatch.matchNumber = NSNumber(int: Int32(mutableMatches.count + 1))
            newMatch.roundId = roundId
            newMatch.categoryId = categoryId
            newMatch.teamOneGoals = NSNumber(int: 0)
            newMatch.teamTwoGoals = NSNumber(int: 0)
            
            mutableMatches.addObject(newMatch)
            
        }
        
        return mutableMatches
    }
    
    func findTeamWithId(teamId: String, inArray: NSArray!) -> LMTeam? {
        
        print("running find team")
        
        for team in inArray {
            let currentTeam = team as! LMTeam
            
            if currentTeam.objectId == teamId {
                print("found team")
                return currentTeam
            }
        }
        
        
        return nil
    }
    
    func findMatchesWithRound(theRound: LMRound, allMatches: NSArray) -> NSArray {
        
        let matchesForRound = NSMutableArray()
        
        for matchObj: AnyObject in allMatches {
            let currentMatch = matchObj as! LMMatch
            
            if currentMatch.roundId == theRound.objectId {
                print("Found match for round")
                matchesForRound.addObject(currentMatch)
            }
        }
        
        return NSArray(array: matchesForRound)
        
    }
    
    // MARK: Create teams based on matchmaking below, it gives an nsarray, with two spots, 
    // each two indices represent opposing teams, the array should always be an even number
    // of teams.
    
    func createNewRoundForMatchmakedTeams(allRounds: NSMutableArray, selectedChampionship: Championship, selectedCategory: LMCategory) -> LMRound {
        
        let nextRound = LMRound.object()
        nextRound.roundNumber = NSNumber(int: allRounds.count + 1);
        nextRound.championshipId = selectedChampionship.objectId
        nextRound.categoryId = selectedCategory.objectId
        
        return nextRound
    }
    
    func createMatchesFromMatchmakedTeams(matchmakedTeams: NSArray!, currentRound: LMRound, selectedChampionship: Championship, selectedCategory: LMCategory) -> NSArray {
        
        
        let mutableArray = NSMutableArray()
        
        for var index = 0; index < matchmakedTeams.count; index = index + 2 {
            
            let firstTeam = matchmakedTeams.objectAtIndex(index) as! LMTeam
            let secondTeam = matchmakedTeams.objectAtIndex(index + 1) as! LMTeam
            
            let nextMatch = LMMatch()
            nextMatch.matchNumber = NSNumber(int: index + 1)
            nextMatch.teamOneId = firstTeam.objectId
            nextMatch.teamTwoId = secondTeam.objectId
            nextMatch.teamOneGoals = NSNumber(int: 0)
            nextMatch.teamTwoGoals = NSNumber(int: 0)
            nextMatch.roundId = currentRound.objectId
            nextMatch.categoryId = selectedCategory.objectId
            
            mutableArray.addObject(nextMatch)
        }
        
        return NSArray(array: mutableArray)
    }
    
    // MARK: Matchmaking teams
    
    func matchmakeTeams(theTeamsLeft: NSMutableArray!, theMatchmakedTeams: NSMutableArray!, allMatches: NSArray!, allTeams: NSArray!) -> NSArray? {
        
        // Need to instantiate new arrays so that we don't modify any of the other arrays
        // sent as parameters for future recursive loops if it doesn't terminate in the first run.
        var teamsLeft: NSMutableArray? = NSMutableArray(array: self.sortTeams(theTeamsLeft))
        var matchmakedTeams: NSMutableArray? = NSMutableArray(array: theMatchmakedTeams)
        
        
        if teamsLeft!.count == 0 {
            print("no teams left, returning matchmaked teams")
            return matchmakedTeams
        }
        
        let teamToMatchmake = teamsLeft!.firstObject as! LMTeam
        
        let availableTeamsToMatchmake = self.teamsAvailableForMatchmakingForTeam(teamToMatchmake, inAvailableTeams: teamsLeft!, withMatchmakedTeams: matchmakedTeams!, allMatches: allMatches, allTeams: allTeams)
        
        if availableTeamsToMatchmake == nil {
            print("No available teams to matchmake")
            teamsLeft = nil
            matchmakedTeams = nil
            
            return nil
        }
        
        for var index = 0; index < availableTeamsToMatchmake!.count; ++index {
            
            let opposingTeam = availableTeamsToMatchmake!.objectAtIndex(index) as! LMTeam
            
            teamsLeft!.removeObject(teamToMatchmake)
            teamsLeft!.removeObject(opposingTeam)
            matchmakedTeams!.addObject(teamToMatchmake)
            matchmakedTeams!.addObject(opposingTeam)
            
            var matchmakingResult: NSArray? = self.matchmakeTeams(teamsLeft, theMatchmakedTeams: matchmakedTeams, allMatches: allMatches, allTeams: allTeams)
            
            if matchmakingResult != nil {
                return matchmakingResult
            }
            else {
                teamsLeft!.addObject(teamToMatchmake)
                teamsLeft!.addObject(opposingTeam)
                matchmakedTeams!.removeObject(teamToMatchmake)
                matchmakedTeams!.removeObject(opposingTeam)
                
                matchmakingResult = nil
                
                teamsLeft = NSMutableArray(array: self.sortTeams(teamsLeft))
            }
            
        }
        
        return nil
    }
    
    // gets the available teams not yet competed against
    func teamsAvailableForMatchmakingForTeam(teamToMatchmake: LMTeam, inAvailableTeams: NSMutableArray, withMatchmakedTeams: NSMutableArray, allMatches: NSArray!, allTeams: NSArray!) -> NSArray? {
        
        let teamsFaced = self.teamsAlreadyCompetedAgains(teamToMatchmake, matchmakedTeams: withMatchmakedTeams, allMatches: allMatches)
        
        print("teams already competed against \(teamsFaced)")
        
        let listOfAllTeams = NSMutableArray(array: inAvailableTeams)
        listOfAllTeams.removeObject(teamToMatchmake)
        
        print("list of all teams \(listOfAllTeams)")
        
        var teamsToReturn = NSMutableArray()
        
        for teamFaced: AnyObject in teamsFaced! {
            let currentTeamFaced = teamFaced as! String
            
            for var index = 0; index < listOfAllTeams.count; ++index {
                
                let currentTeam = listOfAllTeams.objectAtIndex(index) as! LMTeam
                
                if currentTeam.objectId == currentTeamFaced {
                    listOfAllTeams.removeObjectAtIndex(index)
                    break
                }
                
                
                /*
                var currentTeam = allTeamObj as! LMTeam
                
                if currentTeam.objectId != currentTeamFaced && currentTeam.objectId != teamToMatchmake.objectId {
                    println("current team to return \(currentTeam) for team to matchmake \(teamToMatchmake)")
                    teamsToReturn.addObject(currentTeam)
                }*/
            }
            
        }
        
        if listOfAllTeams.count == 0 {
            listOfAllTeams.removeAllObjects()
            return nil
        }
        
        return listOfAllTeams
    }
    
    func teamsAlreadyCompetedAgains(theTeam: LMTeam, matchmakedTeams: NSMutableArray, allMatches: NSArray!) -> NSArray! {
        
        let teamsFaced = NSMutableArray()
        
        for matchObj: AnyObject in allMatches {
            
            let currentMatch = matchObj as! LMMatch
            
            
            if currentMatch.teamOneId == theTeam.objectId {
                teamsFaced.addObject(currentMatch.teamTwoId)
            }
            else if currentMatch.teamTwoId == theTeam.objectId {
                teamsFaced.addObject(currentMatch.teamOneId)
            }
            
        }
        
        return teamsFaced
        
    }
    
    // MARK: Sort teams based on goal difference and points
    func sortTeams(allTeams: NSMutableArray!) -> NSArray {
        let sortedArray = allTeams.sort {
            (obj1, obj2) in
            
            let teamOne = obj1 as! LMTeam
            let teamTwo = obj2 as! LMTeam
            
            return teamOne.points.intValue == teamTwo.points.intValue ? teamOne.goalDifference.intValue > teamTwo.goalDifference.intValue : teamOne.points.intValue > teamTwo.points.intValue
            
            //return teamOne.goalDifference.intValue > teamTwo.goalDifference.intValue && teamOne.points.intValue > teamTwo.points.intValue;
            
        }
        
        print("sorted array is \(sortedArray)")
        
        return sortedArray
    }
    
    func sortMatchesByNumber(allMatches: NSArray!) -> NSArray {
        let sortedArray = allMatches.sort {
            (obj1, obj2) in
            
            let matchOne = obj1 as! LMMatch
            let matchTwo = obj2 as! LMMatch
            
            return matchOne.matchNumber.intValue < matchTwo.matchNumber.intValue
        }
        
        return sortedArray
    }
    
    func sortRounds(allRounds: NSMutableArray!) -> NSArray {
        let sortedArray = allRounds.sort {
            (obj1, obj2) in
            
            let roundOne = obj1 as! LMRound
            let roundTwo = obj2 as! LMRound
            
            return roundOne.roundNumber.intValue < roundTwo.roundNumber.intValue
        }
        
        return sortedArray
    }
    
    // MARK: Updating team values based on prior matches with entire history
    
    func updateTeamValuesForCategory(category: LMCategory!, allMatches: NSArray!, allTeams: NSArray!) {
        
        for obj: AnyObject in allTeams {
            
            let currentTeam = obj as! LMTeam
            currentTeam.goalsScored = NSNumber(int: 0)
            currentTeam.goalsTaken = NSNumber(int: 0)
            currentTeam.points = NSNumber(int: 0)
            
            for matchobj: AnyObject in allMatches {
                
                let currentMatch = matchobj as! LMMatch
                
                if teamInMatch(currentMatch, theTeam: currentTeam) {
                    print("found match")
                    addPointsForTeam(currentTeam, theMatch: currentMatch, theCategory: category)
                }
            }
            
            currentTeam.goalDifference = NSNumber(int: currentTeam.goalsScored.intValue - currentTeam.goalsTaken.intValue)
        }
        
        
    }
    
    func addPointsForTeam(theTeam: LMTeam, theMatch: LMMatch, theCategory: LMCategory) {
        
        if theTeam.objectId == theMatch.teamOneId {
            
            theTeam.goalsScored = NSNumber(int: theTeam.goalsScored.intValue + theMatch.teamOneGoals.intValue)
            theTeam.goalsTaken = NSNumber(int: theTeam.goalsTaken.intValue + theMatch.teamTwoGoals.intValue)
            
            if theMatch.teamOneGoals.intValue > theMatch.teamTwoGoals.intValue {
                theTeam.points = NSNumber(int: theTeam.points.intValue + theCategory.pointsForWin.intValue)
            }
            else if theMatch.teamOneGoals.intValue == theMatch.teamTwoGoals.intValue {
                theTeam.points = NSNumber(int: theTeam.points.intValue + theCategory.pointsForTie.intValue)
            }
            
        }
        else if theTeam.objectId == theMatch.teamTwoId {
            
            theTeam.goalsScored = NSNumber(int: theTeam.goalsScored.intValue + theMatch.teamTwoGoals.intValue);
            theTeam.goalsTaken = NSNumber(int: theTeam.goalsTaken.intValue + theMatch.teamOneGoals.intValue);
            
            if theMatch.teamTwoGoals.intValue > theMatch.teamOneGoals.intValue {
                theTeam.points = NSNumber(int: theTeam.points.intValue + theCategory.pointsForWin.intValue)
            }
            else if theMatch.teamTwoGoals.intValue == theMatch.teamOneGoals.intValue {
                theTeam.points = NSNumber(int: theTeam.points.intValue + theCategory.pointsForTie.intValue)
            }
            
        }
        
    }
    
    func findTeamWithId(teamId: String, inTeams: NSArray) -> LMTeam? {
        
        for teamOjb: AnyObject in inTeams {
            let currentTeam = teamOjb as! LMTeam
            
            if currentTeam.objectId == teamId {
                return currentTeam
            }
            
        }
        
        print("ERROR: didn't find team with id")
        
        return nil
        
    }
    
    func teamInMatch(theMatch: LMMatch, theTeam: LMTeam) -> Bool {
        
        if theMatch.teamOneId == theTeam.objectId {
            return true
        }
        else if theMatch.teamTwoId == theTeam.objectId {
            return true
        }
        
        return false
        
    }
    
    // MARK: Get the array of values from all the matches based on the round
    
}

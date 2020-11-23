//
//  Model.swift
//  Olympics
//
//  Created by Daniel Dang on 10/4/20.
//

import Foundation
import SwiftUI

struct OlympicModel {
    var eventsList: [Event] = [
//        Event(name: "Chubby Bunny", points: 10, description: "Marshmallows in mouth"),
//        Event(name: "Typing Test", points: 40)
    ]
    
    var team1: Team = Team(number: 1, name: "", players: [], color: Color.red)
    var team2: Team = Team(number: 2, name: "", players: [], color: Color.blue)

    struct Event: Identifiable {
        var name: String
        var points: Int
        var description: String?
//        var stopwatchRequested: Bool = false
//        var counterRequested: Bool = false
//        var notepadRequested: Bool = false
        var id: String {
            name
        }
        var winner: Team?
        var completed: Bool = false
        var times = [Double]()
        var counts = [Int]()
        var notes = [String]()
        
    }
    
    struct Team: Hashable {
        var number: Int
        var name: String
        var players: [String]
        var color: Color
//        var mascot: String
        var points: Int = 0
    }
    
    mutating func addEvent(name: String, points: Int, description: String) {//, stopwatchRequested: Bool, counterRequested: Bool, notepadRequested: Bool) {
        let newEvent: Event = Event(name: name, points: points, description: description)//, stopwatchRequested: stopwatchRequested, counterRequested: counterRequested, notepadRequested: notepadRequested)
        eventsList.append(newEvent)
        
    }
    
    mutating func removeEvent(at offsets: IndexSet) {
        // TODO - find index and remove at index
        eventsList.remove(atOffsets: offsets)
    }
    
    mutating func changeTeamName(number: Int, name: String) {
        if number == 1 {
            team1.name = name
        } else if number == 2 {
            team2.name = name
        }
    }
    
    mutating func addPlayer(name: String, to number: Int) {
        if number == 1 {
            team1.players.append(name)
        } else if number == 2 {
            team2.players.append(name)
        }
    }
    
    mutating func removePlayer(at offsets: IndexSet, from number: Int) {
        if number == 1 {
            team1.players.remove(atOffsets: offsets)
        } else if number == 2 {
            team2.players.remove(atOffsets: offsets)
        }
    }
    
    mutating func shuffleTeams() {
        var combined: [String] = team1.players + team2.players
        let team1size: Int = team1.players.count
        team1.players = []
        team2.players = []
        combined.shuffle()
        for player in 0..<team1size {
            team1.players.append(combined[player])
        }
        for player in team1size ..< combined.count {
            team2.players.append(combined[player])
        }
    }
    
    mutating func sendToTeam2(_ name: String) {
        if let index = team1.players.firstIndex(of: name) {
            team1.players.remove(at: index)
            team2.players.append(name)
        }
    }
    
    mutating func sendToTeam1(_ name: String) {
        if let index = team2.players.firstIndex(of: name) {
            team2.players.remove(at: index)
            team1.players.append(name)
        }
    }
    
    mutating func assignWinner(teamNumber: Int, eventIndex: Int) {
        eventsList[eventIndex].winner = (teamNumber == 1 ? team1 : team2)

    }
    
    mutating func markEventCompleted(eventIndex: Int) {
        eventsList[eventIndex].completed = true
    }
    
    mutating func addScoreToTeam(points: Int, team: Team) {
        if team.number == 1 {
            team1.points += points
        } else if team.number == 2 {
            team2.points += points
        }
    }
    
    mutating func saveEventTime(eventIndex: Int, time: Double) {
        eventsList[eventIndex].times.append(time)
    }
    
    mutating func saveEventCount(eventIndex: Int, count: Int) {
        eventsList[eventIndex].counts.append(count)
    }
    
    mutating func saveEventNote(eventIndex: Int, note: String) {
        eventsList[eventIndex].notes.append(note)
    }

}



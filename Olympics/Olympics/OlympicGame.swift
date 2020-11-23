//
//  OlympicGame.swift
//  Olympics
//
//  Created by Daniel Dang on 10/4/20.
//

import SwiftUI

class OlympicGame: ObservableObject, Identifiable {
    @Published private var model: OlympicModel = OlympicGame.createOlympicGame()
    var id = Date()
    var eventsList: [OlympicModel.Event] { model.eventsList }
    var winner: OlympicModel.Team? {
        if team1.points > team2.points {
            return team1
        } else if team2.points > team1.points {
            return team2
        } else {
            return nil
        }
    }
    
    private static func createOlympicGame() -> OlympicModel {
        return OlympicModel()
        
    }
    
    var team1: OlympicModel.Team {model.team1}
    var team2: OlympicModel.Team {model.team2}
    var isTeam1Created: Bool {
        team1.name != "" && !team1.players.isEmpty
    }
    var isTeam2Created: Bool {
        team2.name != "" && !team2.players.isEmpty
    }
    
    
    // MARK - User Intents
    func addEvent(name: String, points: String, description: String) {//, stopwatchRequested: Bool, counterRequested: Bool, notepadRequested: Bool) {
        let points_int = Int(points) ?? 999
        model.addEvent(name: name, points: points_int, description: description)//, stopwatchRequested: stopwatchRequested, counterRequested: counterRequested, notepadRequested: notepadRequested)
    }
    
    func removeEvent(at offsets: IndexSet) {
        // TODO - find index and remove at index
        model.removeEvent(at: offsets)
    }
    
    func renameTeam(team: OlympicModel.Team, to name: String) {
        model.changeTeamName(number: team.number, name: name)
    }
    
    func addPlayer(name: String, to team: OlympicModel.Team) {
        if name != "" && !team.players.contains(name) {
            model.addPlayer(name: name, to: team.number)
        }
        
    }
    
    func removePlayer(at offsets: IndexSet, from team: OlympicModel.Team) {
        model.removePlayer(at: offsets, from: team.number)
    }
    
    func shuffleTeams() {
        model.shuffleTeams()
    }
    
    func swapTeams(player name: String, from team: OlympicModel.Team) {
        if team.number == 1 {
            model.sendToTeam2(name)
        } else {
            model.sendToTeam1(name)
        }
    }
    
    private func assignWinner(team: OlympicModel.Team, event: OlympicModel.Event) {
        let eventIndex = eventsList.firstIndex(matching: event)!
        model.assignWinner(teamNumber: team.number, eventIndex: eventIndex)
    }
    
    private func markEventCompleted(event: OlympicModel.Event) {
        let eventIndex = eventsList.firstIndex(matching: event)!
        model.markEventCompleted(eventIndex: eventIndex)
    }
    
    func addScoreToTeam(points: Int, team: OlympicModel.Team) {
        model.addScoreToTeam(points: points, team: team)
    }
    
    func saveEventTime(event: OlympicModel.Event, time: Double) {
        let eventIndex = eventsList.firstIndex(matching: event)!
        model.saveEventTime(eventIndex: eventIndex, time: time)
    }
    
    
    
    func saveEventCount(event: OlympicModel.Event, count: Int) {
        let eventIndex = eventsList.firstIndex(matching: event)!
        model.saveEventCount(eventIndex: eventIndex, count: count)
    }
    
    func saveEventNote(event: OlympicModel.Event, note: String) {
        let eventIndex = eventsList.firstIndex(matching: event)!
        model.saveEventNote(eventIndex: eventIndex, note: note)
    }
    
    func finishEvent(team: OlympicModel.Team, event: OlympicModel.Event) {
        markEventCompleted(event: event)
        if event.winner != nil && event.winner != team {
            if team == team1 {
                addScoreToTeam(points: event.points, team: team1)
                addScoreToTeam(points: -event.points, team: team2)
            } else if team == team2 {
                addScoreToTeam(points: -event.points, team: team1)
                addScoreToTeam(points: event.points, team: team2)
            }
            assignWinner(team: team, event: event)
        }
        else if event.winner == nil {
            assignWinner(team: team, event: event)
            addScoreToTeam(points: event.points, team: team)
        }
        
        
    }
    
}

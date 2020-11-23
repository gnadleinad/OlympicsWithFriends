//
//  TeamCreateView.swift
//  Olympics
//
//  Created by Daniel Dang on 10/7/20.
//

import Combine
import SwiftUI

struct TeamCreateView: View {
    @EnvironmentObject var viewModel: OlympicGame
    
    var teamsCreated: Bool {
        viewModel.isTeam1Created && viewModel.isTeam2Created
    }
    
    @State var showTeam1EditView: Bool = false
    @State var showTeam2EditView: Bool = false
    
    var body: some View {
//        NavigationView {
        ZStack {
//                Color.green.opacity(0.1).edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                VStack {
                    teamView(viewModel.team1).padding()//.cardify(corner: 25, shadow: 10)
                        .frame(height: geometry.size.height * 0.50)
                    
                    .sheet(isPresented: $showTeam1EditView) {
                        TeamEditView(team: viewModel.team1, isShowing: $showTeam1EditView).environmentObject(viewModel)
                    }

                    teamView(viewModel.team2).padding()//.cardify(corner: 25, shadow: 10)
                        .frame(height: geometry.size.height * 0.50)
                    .sheet(isPresented: $showTeam2EditView) {
                        TeamEditView(team: viewModel.team2, isShowing: $showTeam2EditView).environmentObject(viewModel)
                    }
                }
                .navigationBarTitle("Team Select")
                .navigationBarItems(
                    trailing:
                        HStack {
                            shuffleButton.padding()
                            NavigationLink(destination: EventsListView().environmentObject(viewModel)) {
                                Text("Next")
                            }
                            .disabled(!teamsCreated)
                            
                        }
                )
            }
        }
    }
    
    @ViewBuilder
    func teamListView(_ team: OlympicModel.Team) -> some View {
        ScrollView {
            ForEach(team.players, id: \.self) { name in
                HStack {
                    Text(name)
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut) {
                            viewModel.swapTeams(player: name, from: team)
                        }
                    }) {
                        Image(systemName: "arrow.up.arrow.down").padding()
                    }.buttonStyle(PlainButtonStyle())
                }
            }
        }
//        .listStyle(PlainListStyle())
    }
    
    @ViewBuilder
    func teamView(_ team: OlympicModel.Team) -> some View {
        let isTeamCreated: Bool = !team.players.isEmpty
        
        GeometryReader { geometry in
            VStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        teamColorCircleView(team.color, size: geometry.size)
                        Text(team.name == "" ? (team.number == 1 ? "Team 1" : "Team 2") : team.name)
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        Button(action: {
                            if team.number == 1 {
                                self.showTeam1EditView.toggle()
                            } else {
                                self.showTeam2EditView.toggle()
                            }
                            
                        }) {
                            Image(systemName: (isTeamCreated ? "ellipsis" : "plus")).imageScale(.large).padding()
                        }                .foregroundColor(Color.black)

                    }
                }
                VStack(alignment: .center) {
                    if isTeamCreated {
                        teamListView(team)
                            .padding()
                    } else {
                        noTeamCreatedView(team: team)
                    }
                }
            }
            
        }
    }
    
    @ViewBuilder
    func noTeamCreatedView(team: OlympicModel.Team) -> some View {
        if team == viewModel.team1 {
            Image("team1")
                .resizable()
                .aspectRatio(contentMode: .fit)
//                .frame(width: geometry.size.width, height: geometry.size.height / 2)
//                .padding(.vertical, geometry.size.height / 8)
        } else {
            Image("team2")
                .resizable()
                .aspectRatio(contentMode: .fit)
//                .frame(width: geometry.size.width, height: geometry.size.height / 2)
//                .padding(.vertical, geometry.size.height / 8)
        }
    }
    
    @ViewBuilder
    func teamColorCircleView(_ color: Color, size: CGSize) -> some View {
        Circle()
            .fill(color)
            .frame(width: size.width/teamColorRadius, height: size.height/teamColorRadius)
            .shadow(radius: 2)
    }
    
    var shuffleButton: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                viewModel.shuffleTeams()

            }
        }) {
            Image(systemName: "shuffle").imageScale(.large)
        }
    }
    
    
    
    //  MARK: - Drawing Constants
    var teamColorRadius: CGFloat = 10
    
    
}


struct TeamEditView: View {
    @EnvironmentObject var viewModel: OlympicGame
    @State var team: OlympicModel.Team
    
    
    var teamRoster: [String] {
        if self.team.number == 1 {
            return viewModel.team1.players
        } else {
            return viewModel.team2.players
        }
    }
    
    
    @Binding var isShowing: Bool
    @State var playerNameToAdd: String = ""

    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Edit Team").font(.headline).padding()
                HStack {
                    Spacer()
                    Button(action: {
                        if team.name == "" {
                            viewModel.renameTeam(team: team, to: (team.number == 1 ? "Team 1" : "Team 2"))
                        }
                        self.isShowing = false
                        
                    }, label: {Text("Done")}).padding()
                    .foregroundColor(Color.blue)
                }
            }
            
            Divider()
            Form {
                Section(header: Text("Team Attributes")) {
                    TextField("Team Name", text: $team.name, onEditingChanged: { began in
                        if !began {
//                            teamNameToAdd =
                            viewModel.renameTeam(team: team, to: team.name)
                        }
                    }).onReceive(Just(team.name)) { newValue in
                        if team.name.count > 20 {
                            team.name = String(team.name.prefix(20))
                        }
                    }
                }
                
                Section(header: Text("Team Roster")) {
                    HStack {
                        TextField("Add Player", text: $playerNameToAdd, onCommit: {
                            viewModel.addPlayer(name: playerNameToAdd, to: team)
                            playerNameToAdd = ""
                        }).onReceive(Just(playerNameToAdd)) { newValue in
                            if playerNameToAdd.count > 20 {
                                playerNameToAdd = String(playerNameToAdd.prefix(20))
                            }
                        }
                        Button(action: {
                                viewModel.addPlayer(name: playerNameToAdd, to: team)
                                playerNameToAdd = ""
                            
                        }, label: {
                            Image(systemName: "plus").imageScale(.large)
                        })
                        .foregroundColor(Color.blue)
                    }
                    
                    List {
                        ForEach(teamRoster, id: \.self) { name in
                            Text(name)
                        }
                        .onDelete(perform: delete)
                    }
                    
                }
                
            }

        }
        
    }
    
    func delete(at offsets: IndexSet) {
        viewModel.removePlayer(at: offsets, from: team)
    }
}













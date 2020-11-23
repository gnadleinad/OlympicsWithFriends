//
//  EventsListView.swift
//  Olympics
//
//  Created by Daniel Dang on 10/4/20.
//

import SwiftUI
import Combine

struct EventsListView: View {
    @EnvironmentObject var viewModel: OlympicGame
    
    @State var showEditEvent: Bool = false
    @State var showAddCustomPoints: Bool = false
    
    var body: some View {
//        VStack {
            GeometryReader { geometry in
                VStack {
                    List {
                        Section {
                            ForEach(self.viewModel.eventsList) { event in
                                if event.completed == false {
                                    NavigationLink(destination: EventInProgressView(event: event) .environmentObject(viewModel)) {
                                        EventsListItemView(event: event)
                                            .environmentObject(viewModel)
                                    }
                                }
                            }.onDelete(perform: delete)
                        }
                        if self.viewModel.eventsList.filter { $0.completed == true }.count > 0 {
                            Section(header: VStack(alignment: .leading) {
                                Text("Completed:").font(.headline)
                            }) {
                                ForEach(self.viewModel.eventsList.filter { $0.completed == true }) { event in
                                    NavigationLink(destination: EventInProgressView(event: event).environmentObject(viewModel)) {
                                        EventsListItemView(event: event)
                                        .foregroundColor(Color.black)
                                            .environmentObject(viewModel)
                                    }
                                }
                            }.textCase(nil)
                        }
                    }.listStyle(PlainListStyle())
                    VStack {
                        if self.viewModel.eventsList.isEmpty {
                            
//                                Spacer()
                                Image("events")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width, height: geometry.size.height*0.8)
                            
                        }
                        if self.viewModel.eventsList.filter { $0.completed == false }.isEmpty && self.viewModel.eventsList.filter { $0.completed == true }.count > 0 && self.viewModel.winner != nil {
                            finishView()
                        } else if (self.viewModel.eventsList.filter { $0.completed == true }.count > 0 && self.viewModel.winner == nil) {
                            Text("There is a tie! Create a new event to break the tie!").padding().font(.subheadline)
                        }
                        pointsView(for: geometry.size)

                    }
                }
            }
//        }
        .navigationBarTitle("Events")
        .navigationBarItems(
            trailing:
                Button(action: { self.showEditEvent.toggle() }) {
                    EventsListNewItemView()
                }
                .padding()
                .sheet(isPresented: $showEditEvent) {
                    NewEventView(isShowing: $showEditEvent)
                        .environmentObject(viewModel)
                }
                
        )
    }
    func finishView() -> some View {
        NavigationLink(destination: EndScreenView().environmentObject(viewModel)) {
            Text("🏅 Tap here to finish! Or create more events!").foregroundColor(.accentColor).padding()
        }
    }
    
    func pointsView(for size: CGSize) -> some View {
        VStack(alignment: .leading) {
            Text("Point Totals").font(.headline).padding(.horizontal, 30)
            HStack {
                HStack {
                    Circle()
                        .fill(viewModel.team1.color)
                        .frame(width: teamScoreCircleRadius(for: size), height: teamScoreCircleRadius(for: size))
                        .shadow(radius: 1)
                    Text(String(viewModel.team1.points))
                        .font(.system(size: teamScoreFontSize(for: size)))
                }.padding()
                HStack {
                    Circle()
                        .fill(viewModel.team2.color)
                        .frame(width: teamScoreCircleRadius(for: size), height: teamScoreCircleRadius(for: size))
                        .shadow(radius: 1)
                    Text(String(viewModel.team2.points))
                        .font(.system(size: teamScoreFontSize(for: size)))
                }.padding()
                Spacer()
                Button(action: { self.showAddCustomPoints.toggle() }) {
                    Image(systemName: "plus").imageScale(.large).padding(.horizontal)
                }
                .foregroundColor(.accentColor)
                .padding()
                .sheet(isPresented: $showAddCustomPoints) {
                    AddCustomPoints(isShowing: $showAddCustomPoints) // TODO - What vars go in here?
                        .environmentObject(viewModel)
                }.buttonStyle(PlainButtonStyle())
            }.padding(.horizontal)
        }
        
    }
    //MARK: Drawing Constants
    func teamScoreCircleRadius(for size: CGSize) -> CGFloat {
        let x = min(size.height, size.width)
        return x/15
    }
    
    func teamScoreFontSize(for size: CGSize) -> CGFloat {
        let x = min(size.height, size.width)
        return x/20
    }
    
    //MARK: Intents
    
    func delete(at offsets: IndexSet) {
        print(offsets)
        viewModel.removeEvent(at: offsets)
    }
}

struct NewEventView: View {
    @EnvironmentObject var viewModel: OlympicGame
    @Binding var isShowing: Bool
    @State var name: String = ""
    @State var points = ""
    @State var description: String = ""
//    @State var stopwatchRequested: Bool = false
//    @State var counterRequested: Bool = false
//    @State var notepadRequested: Bool = false

    
    var isFilledOut: Bool {
        return (name != "") && (description != "") && (points != "")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Add Event").font(.headline).padding()
                HStack {
                    Button(action: {
                        self.isShowing = false
                    }, label: {Text("Cancel")}).padding()
                    Spacer()
                    Button(action: {
                        self.viewModel.addEvent(name: name, points: points,
                                                description: description) //, stopwatchRequested: stopwatchRequested, counterRequested: counterRequested, notepadRequested: notepadRequested)
                        self.isShowing = false
                    }, label: {Text("Done")}).padding()
                    .disabled(!isFilledOut)
                }
            }
            
            Divider()
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Event Name", text: $name)
                        .onReceive(Just(name)) { newValue in
                            if name.count > 20 {
                                self.name = String(points.prefix(20))
                            }
                        }
                    TextField("Description", text: $description)
                        .onReceive(Just(name)) { newValue in
                            if name.count > 40 {
                                self.name = String(points.prefix(40))
                            }
                        }
                }
                
                Section(header: Text("Event Points")) {
                    TextField("Points", text: $points)
                        .keyboardType(.decimalPad)
                        .onReceive(Just(points)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.points = filtered
                            }
                            if points.count > 9 {
                                self.points = String(points.prefix(9))
                            }
                        }
                    }
//                Section(header: Text("Tools Required")) {
//                    Toggle(isOn: $stopwatchRequested) {
//                        Text("Stopwatch").font(.body)
//                    }
//                    Toggle(isOn: $counterRequested) {
//                        Text("Counter").font(.body)
//                    }
//                    Toggle(isOn: $notepadRequested) {
//                        Text("Notepad").font(.body)
//                    }
//                }
            }
        }
    }
}

struct EventsListItemView: View {
    var event: OlympicModel.Event
    var name: String {
        event.name
    }
    var points: Int {
        event.points
    }
    var description: String? {
        event.description
    }
    var winner: OlympicModel.Team? {
        event.winner
    }
    
//    var backgroundColor: Color? can be replaced with the winner color
    
    var body: some View {
        HStack {
            if winner != nil {
                Image(systemName: "checkmark.seal.fill").imageScale(.large)
                    .foregroundColor(winner?.color)
            }
            VStack(alignment: .leading) {
                Text(name)
                    .font(Font.system(.headline))
                if let descriptionText = description {
                    if descriptionText == "" {
                        EmptyView()
                    } else {
                        Text(descriptionText)
                            .font(Font.system(.subheadline))
                    }

                }
            }.padding(.horizontal)
            Spacer()
            VStack {
                Text(String(points))
                    .font(Font.system(.title))
                    
                Text("points")
                    .font(Font.system(.caption))
                    
            }
            .padding()

            
            
        } // cardify
    }
    
    var teamColorCircleRadius: CGFloat = 15
    
}

struct EventsListNewItemView: View {
    var body: some View {
        HStack {
            Image(systemName: "square.and.pencil").imageScale(.large)
        }
    }
}

struct AddCustomPoints: View {
    @EnvironmentObject var viewModel: OlympicGame
    @Binding var isShowing: Bool
    @State var selectedTeam = 0
    var teams: [OlympicModel.Team] { [viewModel.team1, viewModel.team2] }
    @State var points = ""

    
    var body: some View {
        VStack {
            ZStack {
                Text("Add Custom Points").font(.headline).padding()
                HStack {
                    Button(action: {
                        self.isShowing = false
                    }, label: {Text("Cancel")}).padding()
                    Spacer()
                    Button(action: {
                        viewModel.addScoreToTeam(points: Int(points) ?? 999, team: teams[selectedTeam])
                        self.isShowing = false
                    }, label: {Text("Done")}).padding()
                }
            }

            Form {
                Section {
                    Picker(selection: $selectedTeam, label: Text("Give points to:")) {
                        ForEach(0 ..< teams.count) { index in
                            Text(self.teams[index].name)
                        }
                    }.pickerStyle(SegmentedPickerStyle()).padding()
                }
                
                TextField("Points to add", text: $points)
                    .keyboardType(.decimalPad)
                    .onReceive(Just(points)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.points = filtered
                        }
                        if points.count > 9 {
                            self.points = String(points.prefix(9))
                        }
                    }
            }
        }


    }
    
}

struct EventsListView_Previews: PreviewProvider {

    static var previews: some View {
        EventsListView()
            .environmentObject(OlympicGame())
    }
}

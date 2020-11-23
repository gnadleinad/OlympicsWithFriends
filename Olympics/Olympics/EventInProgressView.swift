//
//  EventInProgressView.swift
//  Olympics
//
//  Created by Daniel Dang on 10/18/20.
//

import SwiftUI

struct EventInProgressView: View {
    @EnvironmentObject var viewModel: OlympicGame
    @State var event: OlympicModel.Event
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var stopWatchManager = StopWatchManager()
    @ObservedObject var counterManager = CounterManager()
    @State private var showingActionSheet = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
//                ScrollView {
//                    VStack {
                        if let winner = event.winner {
                            Text("Winner: \(winner.name)")
                                .font(.headline)
                                .foregroundColor(winner.color)
//                                .padding()
                        }
                        if let description = event.description {
                            Text(description)
                                .font(.headline)
                                .opacity(0.70)
//                                .padding()
                        }
                Divider()
                TabView {
                    stopwatchView(for: geometry.size).tabItem {
                        Image(systemName: "stopwatch")
                        Text("Stopwatch").padding(.vertical)
                    }
                    counterView(for: geometry.size).tabItem {
                        Image(systemName: "plus.circle")
                        Text("Counter").padding(.vertical)
                        
                    }
                    notepadView(size: geometry.size, event: event).tabItem {
                        Image(systemName: "pencil")
                        Text("Notepad").padding(.vertical)
                    }
                }
//                        Toggle(isOn: $event.stopwatchRequested) {
//                            Text("Stopwatch").font(.body)
//                        }.padding(.horizontal, togglePadding(for: geometry.size))
//
//                        Toggle(isOn: $event.counterRequested) {
//                            Text("Counter").font(.body)
//                        }.padding(.horizontal, togglePadding(for: geometry.size))
//
//                        Toggle(isOn: $event.notepadRequested) {
//                            Text("Notepad").font(.body)
//                        }.padding(.horizontal, togglePadding(for: geometry.size))
                        
//                    }
//                    .padding()
                    //.cardify(corner: 25, shadow: 10)
//                    if event.stopwatchRequested {
                        
//                            .transition(AnyTransition.slide.combined(with: .opacity).animation(.easeInOut(duration: 0.4)))
//                    }
//                    if event.counterRequested {
//                            .transition(AnyTransition.slide.combined(with: .opacity).animation(.easeInOut(duration: 0.4)))
//                    }
//                    if event.notepadRequested {
//                            .transition(AnyTransition.slide.combined(with: .opacity).animation(.easeInOut(duration: 0.4)))
//                    }
//                }
                .navigationTitle(event.name)
                .navigationBarItems(trailing: finishButton())
            }
            
        }
    }
    
    @ViewBuilder
    func stopwatchView(for size: CGSize) -> some View {
        if let eventIndex = viewModel.eventsList.firstIndex(matching: event) {
            let eventTimes = viewModel.eventsList[eventIndex].times
            VStack {
                ScrollView {
//                    finishButton(for: size)
                    VStack(spacing: 0) {
                        HStack {
                            Text("Stopwatch").padding(.vertical)
                            Image(systemName: "stopwatch")
                        }
                        timer(for: size)
                        Divider()
                        ScrollView {
                            ForEach(eventTimes.indices, id: \.self) { index in
                                HStack {
                                    Text(String(index + 1) + ".")
                                    Spacer()
                                    Text(String(format: "%.2f", eventTimes[index]))
                                }.padding(.horizontal, savedItemsHorPadding(for: size))
                            }
                        }.padding().frame(height: savedItemsHeight(for: size))
                    }
//                    .cardify(corner: 15, shadow: 2)
                }
                
            }
            

        }
    }
    
    
    func timer(for size: CGSize) -> some View {
            VStack {
                Text(String(format: "%.2f", stopWatchManager.secondsElapsed))
                    .font(.custom("Avenir", size: size.width / 8))
                    .padding(.vertical, timerVerticalPadding(for: size))
                
                if stopWatchManager.mode == .stopped {
                    Button(action: {self.stopWatchManager.start()}) {
                        timerButton(for: size, label: "Start", buttonColor: .blue)
                    }
                    Button(action: {
                        stopAndSave()
                    }) {
                        timerButton(for: size, label: "Save and Reset", buttonColor: .red)
                    }.padding()
                    .disabled(true)
                    .opacity(0.0)
                }
                if stopWatchManager.mode == .running {
                    Button(action: {self.stopWatchManager.pause()}) {
                        timerButton(for: size, label: "Pause", buttonColor: .orange)
                    }
                    Button(action: {
                        stopAndSave()
                    }) {
                        timerButton(for: size, label: "Save and Reset", buttonColor: .red)
                    }.padding()
                    .disabled(true)
                    .opacity(0.0)
                }
                if stopWatchManager.mode == .paused {
                    Button(action: {self.stopWatchManager.start()}) {
                        timerButton(for: size, label: "Resume", buttonColor: .blue)
                    }
                    Button(action: {
                        stopAndSave()
                    }) {
                        timerButton(for: size, label: "Save and Reset", buttonColor: .red)
                    }
                    .padding()
                }
            }
    }
    
    func timerButton(for size: CGSize, label: String, buttonColor: Color) -> some View {
            Text(label)
                .font(.headline)
                .foregroundColor(buttonColor == Color.white ? Color.accentColor : Color.white)
                .padding(.vertical, timerButtonHeight(for: size))
                .frame(width: timerButtonWidth(for: size))
                .background(buttonColor)
                .cornerRadius(100)
                .shadow(radius: 3)
        
        
    }
    @ViewBuilder
    func counterView(for size: CGSize) -> some View {
        if let eventIndex = viewModel.eventsList.firstIndex(matching: event) {
            let eventCounts = viewModel.eventsList[eventIndex].counts
            VStack {
                ScrollView {
                    VStack(spacing: 0) {
                        HStack {
                            Text("Counter").padding(.vertical)
                            Image(systemName: "plus.circle")
                        }
                        
                        counter(for: size)
                        Divider()
                        ScrollView {
                            ForEach(eventCounts.indices, id: \.self) { index in
                                HStack {
                                    Text(String(index + 1) + ".")
                                    Spacer()
                                    Text(String(eventCounts[index]))
                                }
                                .padding(.horizontal, savedItemsHorPadding(for: size))
                            }
                        }.padding().frame(height: savedItemsHeight(for: size))
                    }
//                    .cardify(corner: 15, shadow: 2)
                }
            }
            
        }
    }
    
    func counter(for size: CGSize) -> some View {
            VStack {
                Text(String(counterManager.currentCount))
                    .font(.custom("Avenir", size: size.width / 8))
                    .padding(.vertical, counterVerticalPadding(for: size))
                HStack {
                    Button(action: {
                        counterManager.decrement()
                    }) {
                        ZStack {
                            Circle().fill(Color.white).frame(width: counterButtonSize(for: size), height: counterButtonSize(for: size) ).shadow(radius: 3)
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .foregroundColor(.red)
    //                            .padding()
    //                            .background(Color.red)
    //                            .clipShape(Circle())
                                .frame(width: counterButtonSize(for: size), height: counterButtonSize(for: size) )
                        }
                        
                    }
                    .padding(30)
                    Button(action: {
                        counterManager.increment()
                    }) {
                        ZStack {
                            Circle().fill(Color.white).frame(width: counterButtonSize(for: size), height: counterButtonSize(for: size) ).shadow(radius: 3)
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .foregroundColor(.blue)
    //                            .padding()
    //                            .background(Color.red)
    //                            .clipShape(Circle())
                                .frame(width: counterButtonSize(for: size), height: counterButtonSize(for: size) )
                        }
                    }
                    .padding(30)
                    
                }
                Button(action: {
                    viewModel.saveEventCount(event: event, count: counterManager.currentCount)
                    counterManager.reset()
                }) {
                    Text("Save & Reset")
                }.padding(.bottom)
                
            }
    }
    


    
    struct notepadView: View {
        @EnvironmentObject var viewModel: OlympicGame
        var size: CGSize
        var event: OlympicModel.Event
        var eventNotesOptional: [String]? {
            if let eventIndex = viewModel.eventsList.firstIndex(matching: event) {
                return viewModel.eventsList[eventIndex].notes
            }
            return nil
        }
        
        @State var noteToAdd: String = ""
        
        var body: some View {
            if let eventNotes = eventNotesOptional { //This was a fix for crashing after deleting an event that had notepad open
                VStack {
                    ScrollView {
                        VStack {
                            HStack {
                                Text("Notepad").padding(.vertical)
                                Image(systemName: "pencil")

                            }
                            List { // Used list instead of scrollview because it aligns to left and puts dividers between
                                ForEach(eventNotes.indices, id: \.self) { index in
                                        Text(eventNotes[index])
                                    .padding()
                                }
                                
                            }.frame(height: savedItemsHeight(for: size))
                            Divider()
                                HStack {
                                    TextField("Write in here!", text: $noteToAdd, onCommit: {
                                              viewModel.saveEventNote(event: event, note: noteToAdd)
                                              noteToAdd = ""
                                    }).padding()
                                    Button("Enter") {
                                        viewModel.saveEventNote(event: event, note: noteToAdd)
                                        noteToAdd = ""
                                    }
                                    .foregroundColor(Color.accentColor)
                                    .padding()
                                }
                        }
//                        .cardify(corner: 15, shadow: 2)
                    }
                }

            }
            
        }
        
        func savedItemsHeight(for size: CGSize) -> CGFloat {
            return size.width
        }
    }
    
    func stopAndSave() {
        viewModel.saveEventTime(event: event, time: self.stopWatchManager.secondsElapsed)
        self.stopWatchManager.stop()
        
    }
    
    func finishButton() -> some View { //for size used to be here
//        Group {
            Button(action: {
                self.showingActionSheet = true
            }) {
//                timerButton(for: size, label: "Finish", buttonColor: Color.white)
                Text("Finish ✓")
            }
                .actionSheet(isPresented: $showingActionSheet) {
                    ActionSheet(title: Text("Declare Winner for \(event.name)"), message: Text("Who was victorious this round?"), buttons: [
                        .default(Text(viewModel.team1.name)) {
                            viewModel.finishEvent(team: viewModel.team1, event: event)
                            self.presentationMode.wrappedValue.dismiss()
                        },
                        .default(Text(viewModel.team2.name)) {
                            viewModel.finishEvent(team: viewModel.team2, event: event)

                            self.presentationMode.wrappedValue.dismiss()
                        },
                        .cancel()
                    ])
                }
//            .foregroundColor(.blue)
//            .padding(.vertical, timerButtonHeight(for: size) * (0.1))
//            .frame(width: timerButtonWidth(for: size))
//            .background(Color.white)
//            .cornerRadius(100)
//            .shadow(radius: 2)
//        }
        .padding()
        
    }
    
    
    
    
    //MARK: Drawing Constants
    
    func timerVerticalPadding(for size: CGSize) -> CGFloat {
        let vertPadding: CGFloat = 25
        return size.height / vertPadding
    }
    
    func timerButtonHeight(for size: CGSize) -> CGFloat {
        let vertPadding: CGFloat = 25
        return size.height / vertPadding
    }
    
    func timerButtonWidth(for size: CGSize) -> CGFloat {
        let width: CGFloat = 2.5
        return size.height / width
    }
    
    func counterVerticalPadding(for size: CGSize) -> CGFloat {
        let vertPadding: CGFloat = 25
        return size.height / vertPadding
    }
    
    func savedItemsHeight(for size: CGSize) -> CGFloat {
        return size.height / 5
    }
    
    func savedItemsHorPadding(for size: CGSize) -> CGFloat {
        return size.height / 10
    }
    func counterButtonSize(for size: CGSize) -> CGFloat {
        return size.height / 7
    }
}



struct EventInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EventInProgressView(event: OlympicModel.Event(name: "afdsafdsa", points: 54))
            //.environmentObject(OlympicGame())
        }
        
    }
}

//
//  ContentView.swift
//  Olympics
//
//  Created by Daniel Dang on 10/2/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: OlympicGame = OlympicGame()
    var body: some View {
        LandingPageView().environmentObject(viewModel).environment(\.colorScheme, .light)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() //viewModel: OlympicGame())
    }
}

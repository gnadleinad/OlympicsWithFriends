//
//  LandingPageView.swift
//  Olympics
//
//  Created by Daniel Dang on 10/28/20.
//

import SwiftUI

struct LandingPageView: View {
    @EnvironmentObject var viewModel: OlympicGame 
    
    var body: some View {
        NavigationView {
            NavigationLink(destination: TeamCreateView()) {
                VStack {
                    GeometryReader { geometry in
                        VStack {
                            Image("title")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.vertical)
                            Text("Tap to Begin!")
                                .foregroundColor(.accentColor)
                                .font(.title3)
                                .padding(.vertical, 20)
                        }
                    }
                }
            }
        }
        .environmentObject(viewModel)
        .navigationViewStyle(StackNavigationViewStyle())
        
        
        
    }
}

struct LandingPageView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPageView()
    }
}

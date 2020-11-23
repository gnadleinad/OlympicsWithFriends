//
//  EventListify.swift
//  Olympics
//
//  Created by Daniel Dang on 10/4/20.
//

import SwiftUI

struct Cardify: ViewModifier {
    var corner: CGFloat
    var shadow: CGFloat
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: corner)
                .foregroundColor(.white)
                .shadow(radius: shadow)
                .padding()
            content.padding()
        }
    }
    
}

extension View {
    func cardify(corner: CGFloat, shadow: CGFloat) -> some View {
        self.modifier(Cardify(corner: corner, shadow: shadow))
    }
}

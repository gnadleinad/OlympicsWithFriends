//
//  EventListify.swift
//  Olympics
//
//  Created by Daniel Dang on 10/4/20.
//

import SwiftUI

struct EventListify: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            Group {
//                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
//                RoundedRectangle(cornerRadius: cornerRadius).stroke(Color.gray)

                content
                Divider()
            }
        }
    }
    
    private let cornerRadius: CGFloat = 0
}

extension View {
    func eventListify() -> some View {
        self.modifier(EventListify())
    }
}

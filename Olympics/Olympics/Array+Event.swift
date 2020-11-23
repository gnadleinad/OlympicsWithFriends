//
//  Array + Identifiable.swift
//  Olympics
//
//  Created by Daniel Dang on 10/4/20.
//

import Foundation

extension Array where Element == OlympicModel.Event {
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
    
    
}

//
//  Item.swift
//  Veritas v1
//
//  Created by Katelyn Mikheev on 3/29/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

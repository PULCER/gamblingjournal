//
//  Item Model.swift
//  gamblingjournal
//
//  Created by Anthony Howell on 9/19/23.
//

import Foundation

struct CodableItem: Codable {
    var notes: String?
    var profitLoss: String?
    var timestamp: Date?
}


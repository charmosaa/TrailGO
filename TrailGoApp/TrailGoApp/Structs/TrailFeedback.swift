//
//  TrailFeedback.swift
//  TrailGoApp
//
//  Created by Martyna Lopianiak on 28/12/2024.
//
import Foundation


struct TrailFeedback: Decodable {
    var userId: String
    var trailId: String
    var startDate: Date
    var endDate: Date
    var difficulty: Int
    var grade: Int
    var comment: String
}

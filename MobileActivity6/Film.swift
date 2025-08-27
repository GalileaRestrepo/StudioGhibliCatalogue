//
//  Film.swift
//  MobileActivity6
//
//  Created by AGRM  on 25/08/25.
//
//  Model: Plain Codable struct, no UI / networking logic (Clean MVVM separation).
//

import Foundation

struct Film: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let original_title: String?
    let original_title_romanised: String?
    let description: String?
    let director: String?
    let producer: String?
    let release_date: String?
    let running_time: String?
    let rt_score: String?
    let image: String? // URL string
    let movie_banner: String? // URL string
}




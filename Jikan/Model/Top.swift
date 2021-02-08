//
//  Top.swift
//  Jikan
//
//  Created by William Liao on 2021/2/7.
//  Copyright © 2021 William Liao. All rights reserved.
//

import Foundation

struct Top: Codable {
	let mal_id: Int
	let rank: Int
	let title: String
	let url: String
	let image_url: String
	let type: String
	let episodes: Int?
	let start_date: String?
	let end_date: String?
	let members: Int
	let score: Double
    let volumes: Int?
}

extension Top: Hashable {
//    static func == (lhs: Top, rhs: Top) -> Bool {
//        return lhs.mal_id == rhs.mal_id && lhs.rank == rhs.rank && lhs.title == rhs.title && lhs.url == rhs.url
//    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(mal_id)
        hasher.combine(rank)
        hasher.combine(title)
        hasher.combine(url)
        hasher.combine(image_url)
        hasher.combine(type)
        hasher.combine(episodes)
        hasher.combine(start_date)
        hasher.combine(end_date)
        hasher.combine(members)
        hasher.combine(score)
    }
}

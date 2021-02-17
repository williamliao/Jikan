//
//  Animeography.swift
//  Jikan
//
//  Created by 雲端開發部-廖彥勛 on 2021/2/17.
//  Copyright © 2021 William Liao. All rights reserved.
//

import Foundation

struct Animeography: Codable {
    let mal_id: Int
    let type: String
    let name: String
    let url: String
}

struct Mangaography: Codable {
    let mal_id: Int
    let type: String
    let name: String
    let url: String
}


extension Animeography: Hashable {
    func Animeography(into hasher: inout Hasher) {
        hasher.combine(mal_id)
        hasher.combine(type)
        hasher.combine(name)
        hasher.combine(url)
    }
}

extension Mangaography: Hashable {
    func Animeography(into hasher: inout Hasher) {
        hasher.combine(mal_id)
        hasher.combine(type)
        hasher.combine(name)
        hasher.combine(url)
    }
}

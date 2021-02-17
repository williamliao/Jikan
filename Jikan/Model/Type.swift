//
//  Type.swift
//  Jikan
//
//  Created by 雲端開發部-廖彥勛 on 2021/2/9.
//  Copyright © 2021 William Liao. All rights reserved.
//

import Foundation
import UIKit

class SearchItem: Codable {
    let type : ScopeTypeSection
    let subType : ScopeSubTypeSection
    
    enum CodingKeys: String, CodingKey {
        case type
        case subType
    }
    
    init(type: ScopeTypeSection, subType: ScopeSubTypeSection) {
        self.type = type
        self.subType = subType
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(ScopeTypeSection.self, forKey: .type)
        subType = try container.decode(ScopeSubTypeSection.self, forKey: .subType)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let type = aDecoder.decodeObject(forKey: "type") as! ScopeTypeSection
        let subType = aDecoder.decodeObject(forKey: "subType") as! ScopeSubTypeSection
        self.init(type: type, subType: subType)
    }
    
    enum ScopeTypeSection: Int, CaseIterable, Codable {
        case anime
        case manga
        case people
        case characters
    }
}

extension SearchItem.ScopeTypeSection: RawRepresentable {
    typealias RawValue = String
  
    init?(rawValue: RawValue) {
        switch rawValue {
            case "Anime": self = .anime
            case "Manga": self = .manga
            case "People": self = .people
            case "Characters": self = .characters
            default: return nil
        }
    }
  
    var rawValue: RawValue {
            switch self {
            case .anime: return "Anime"
            case .manga: return "Manga"
            case .people: return "People"
            case .characters: return "Characters"
        }
    }
}

struct ScopeSubTypeSection : Codable {
    let anime: ScopeSubTypeAnimeSection
    let manga: ScopeSubTypeMangaSection
    let commonSection : ScopeSubTypeCommonSection
    
    enum ScopeSubTypeAnimeSection: Codable {
        case airing
        case upcoming
        case tv
        case movie
        case ova
        case special
    }
    
    enum ScopeSubTypeMangaSection: Codable {
        case manga
        case novels
        case oneshots
        case doujin
        case manhwa
        case manhua
    }
    
    enum ScopeSubTypeCommonSection: Codable {
        case bypopularity
        case favorite
    }

}

extension ScopeSubTypeSection.ScopeSubTypeAnimeSection: CaseIterable { }

extension ScopeSubTypeSection.ScopeSubTypeAnimeSection: RawRepresentable {
  typealias RawValue = String
  
  init?(rawValue: RawValue) {
    switch rawValue {
    case "Airing": self = .airing
    case "Upcoming": self = .upcoming
    case "TV": self = .tv
    case "Movie": self = .movie
    case "OVA": self = .ova
    case "Special": self = .special
    default: return nil
    }
  }
  
  var rawValue: RawValue {
    switch self {
    case .airing: return "Airing"
    case .upcoming: return "Upcoming"
    case .tv: return "TV"
    case .movie: return "Movie"
    case .ova: return "OVA"
    case .special: return "Special"
    }
  }
}

extension ScopeSubTypeSection.ScopeSubTypeMangaSection: CaseIterable { }

extension ScopeSubTypeSection.ScopeSubTypeMangaSection: RawRepresentable {
  typealias RawValue = String
  
  init?(rawValue: RawValue) {
    switch rawValue {
    case "Manga": self = .manga
    case "Novels": self = .novels
    case "Oneshots": self = .oneshots
    case "Doujin": self = .doujin
    case "Manhwa": self = .manhwa
    case "Manhua": self = .manhua
    default: return nil
    }
  }
  
  var rawValue: RawValue {
    switch self {
    case .manga: return "Manga"
    case .novels: return "Novels"
    case .oneshots: return "Oneshots"
    case .doujin: return "Doujin"
    case .manhwa: return "Manhwa"
    case .manhua: return "Manhua"
    }
  }
}

extension ScopeSubTypeSection.ScopeSubTypeCommonSection: CaseIterable { }

extension ScopeSubTypeSection.ScopeSubTypeCommonSection: RawRepresentable {
  typealias RawValue = String
  
  init?(rawValue: RawValue) {
    switch rawValue {
    case "Bypopularity": self = .bypopularity
    case "Favorite": self = .favorite
    default: return nil
    }
  }
  
  var rawValue: RawValue {
    switch self {
    case .bypopularity: return "Bypopularity"
    case .favorite: return "Favorite"
    }
  }
}

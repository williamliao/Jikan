//
//  Type.swift
//  Jikan
//
//  Created by 雲端開發部-廖彥勛 on 2021/2/9.
//  Copyright © 2021 William Liao. All rights reserved.
//

import Foundation
import UIKit

class CurrentTypeAndSubType {
    var state: SearchItem.ScopeTypeSection = SearchItem.ScopeTypeSection.anime(.airing)
    func set(state: SearchItem.ScopeTypeSection) { self.state = .anime(.airing) }
}

class SearchItem: Codable {
    
    
   /* init(type: ScopeTypeSection, subType: ScopeSubTypeSection) {
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
    }*/
    
    enum ScopeTypeSection {
        case anime (_ subType: ScopeSubTypeAnimeSection)
        case manga (_ subType: ScopeSubTypeMangaSection)
        case people
        case characters
    }
    
    enum ScopeSubTypeAnimeSection {
        case airing
        case upcoming
        case tv
        case movie
        case ova
        case special
        case bypopularity
        case favorite
    }
    
    enum ScopeSubTypeMangaSection {
        case manga
        case novels
        case oneshots
        case doujin
        case manhwa
        case manhua
        case bypopularity
        case favorite
    }
}

extension SearchItem.ScopeTypeSection: RawRepresentable, Codable, CaseIterable, Equatable {
    
    static var allCases: [SearchItem.ScopeTypeSection] {
        return [.anime(.airing), .manga(.manga), .people, .characters]
    }
  
    typealias RawValue = String
  
    init?(rawValue: RawValue) {
        switch rawValue {
            case "anime": self = .anime(.airing)
            case "manga": self = .manga(.manga)
            case "people": self = .people
            case "characters": self = .characters
            default: return nil
        }
    }
  
    var rawValue: RawValue {
            switch self {
            case .anime: return "anime"
            case .manga: return "manga"
            case .people: return "people"
            case .characters: return "characters"
        }
    }
}

extension SearchItem.ScopeSubTypeAnimeSection : RawRepresentable, Codable, CaseIterable, Equatable {
    
    static var allCases: [SearchItem.ScopeSubTypeAnimeSection] {
        return [.airing, .upcoming, .tv, .movie, .ova, .special, .bypopularity, .favorite]
    }
    
    typealias RawValue = String
    
    init?(rawValue: RawValue) {
      switch rawValue {
      case "airing": self = .airing
      case "upcoming": self = .upcoming
      case "tv": self = .tv
      case "movie": self = .movie
      case "ova": self = .ova
      case "special": self = .special
      case "bypopularity": self = .bypopularity
      case "favorite": self = .favorite
      default: return nil
      }
    }
    
    var rawValue: RawValue {
      switch self {
      case .airing: return "airing"
      case .upcoming: return "upcoming"
      case .tv: return "tv"
      case .movie: return "movie"
      case .ova: return "ova"
      case .special: return "special"
      case .bypopularity:
        return "bypopularity"
      case .favorite:
        return "favorite"
      }
    }
}

extension SearchItem.ScopeSubTypeMangaSection: RawRepresentable, Codable, CaseIterable {
    
    static var allCases: [SearchItem.ScopeSubTypeMangaSection] {
        return [.manga, .novels, .oneshots, .doujin, .manhwa, .manhua, .bypopularity, .favorite]
    }
    
  typealias RawValue = String
  
  init?(rawValue: RawValue) {
    switch rawValue {
    case "manga": self = .manga
    case "novels": self = .novels
    case "oneshots": self = .oneshots
    case "doujin": self = .doujin
    case "manhwa": self = .manhwa
    case "manhua": self = .manhua
    case "bypopularity": self = .bypopularity
    case "favorite": self = .favorite
    default: return nil
    }
  }
  
  var rawValue: RawValue {
    switch self {
    case .manga: return "manga"
    case .novels: return "novels"
    case .oneshots: return "oneshots"
    case .doujin: return "doujin"
    case .manhwa: return "manhwa"
    case .manhua: return "manhua"
    case .bypopularity:
      return "bypopularity"
    case .favorite:
      return "favorite"
    }
  }
}

/*
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
*/

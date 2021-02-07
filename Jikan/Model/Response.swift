//
//  Response.swift
//  Jikan
//
//  Created by William Liao on 2021/2/7.
//  Copyright © 2021 William Liao. All rights reserved.
//

struct Response: Codable {
	var request_hash: String
	var request_cached: Bool
	var request_cache_expiry: Int
	var top: [Top]
}

extension Response: Hashable {
    static func == (lhs: Response, rhs: Response) -> Bool {
        return lhs.request_hash == rhs.request_hash && lhs.request_cached == rhs.request_cached && lhs.request_cache_expiry == rhs.request_cache_expiry && lhs.top == rhs.top
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(request_hash)
        hasher.combine(request_cached)
        hasher.combine(request_cache_expiry)
        hasher.combine(top)
    }
}

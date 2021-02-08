//
//  FakeData.swift
//  JikanTests
//
//  Created by 雲端開發部-廖彥勛 on 2021/2/8.
//  Copyright © 2021 William Liao. All rights reserved.
//

import Foundation
@testable import Jikan

class FakeData {
    func getTopFakeData() -> Response {
      guard
        let url = Bundle.main.url(forResource: "top", withExtension: "json"),
        let data = try? Data(contentsOf: url)
        else {
          return Response(request_hash: "request:top:3506eaba6445f7ad5cc2f78417bf6ed916b6aaad", request_cached: true, request_cache_expiry: 30307, top: [])
      }
      
      do {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
      } catch {
        return Response(request_hash: "request:top:3506eaba6445f7ad5cc2f78417bf6ed916b6aaad", request_cached: true, request_cache_expiry: 30307, top: [])
      }
    }
}

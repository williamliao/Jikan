//
//  ServiceHelper.swift
//  Jikan
//
//  Created by William Liao on 2021/2/7.
//  Copyright © 2021 William Liao. All rights reserved.
//

import UIKit

public struct Route {
    let endpoint: String
}

public struct Routes {
    static let upcoming = Route(endpoint: "/top/anime/1/upcoming")
    static let manga = Route(endpoint: "/top/manga/1/manga")
}

class ServiceHelper: NSObject, APIClient {
    var cacheAnime: URLCache = URLCache()
    
    var cacheManga: URLCache = URLCache()

    let baseURL: String
    
    init(withBaseURL baseURL: String) {
        self.baseURL = baseURL
    }
    
    lazy var session: URLSession = { [weak self] in
        
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let diskCacheURL = cachesURL.appendingPathComponent("DownloadCache")
        let cache = URLCache(memoryCapacity: 10_000_000, diskCapacity: 1024 * 1024 * 100, directory: diskCacheURL)
        
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = cache
        configuration.timeoutIntervalForResource = 60
        if #available(iOS 11, *) {
            configuration.waitsForConnectivity = true
        }
        let session = URLSession(
            configuration: configuration,
            delegate: self,
            delegateQueue: nil)
        return session
    }()
    
    func getFeed(fromRoute route: Route,  parameters: Any?, completion: @escaping (APIResult<Response, Error>) -> Void) {
        guard let url = URL(string: self.baseURL+route.endpoint) else {
            let errorTemp = NSError(domain:"", code:999, userInfo:["error": "badURL"])
            completion(.failure(errorTemp))
            return
        }
               
        fetch(with: clientURLRequest(url: url, method: .get) as URLRequest, decode: { json -> Response? in
               guard let feedResult = json as? Response else { return  nil }
               return feedResult
           }, completion: completion)
    }
    
    func nextPage(page: String, parameters: Any?, completion: @escaping (APIResult<Response, Error>) -> Void) {
        guard let url = URL(string: self.baseURL+"/top/anime/\(page)/upcoming") else {
            let errorTemp = NSError(domain:"", code:999, userInfo:["error": "badURL"])
            completion(.failure(errorTemp))
            return
        }
               
        fetch(with: clientURLRequest(url: url, method: .get) as URLRequest, decode: { json -> Response? in
               guard let feedResult = json as? Response else { return  nil }
               return feedResult
           }, completion: completion)
    }
}

extension ServiceHelper: URLSessionDelegate {
  
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("Error: \(String(describing: error?.localizedDescription))")
        task.cancel()
    }
}

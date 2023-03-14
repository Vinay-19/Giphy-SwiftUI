//
//  URL+Extensions.swift
//  Giphy
//
//  Created by Vinay Kumar Thapa on 2023-03-13.
//

import Foundation

extension URL {
    
    static func forTrendingGifs() -> URL?{
        return URL(string: "\(Constants.baseUrl)trending?api_key=\(Constants.API_KEY)&q=se&limit=25&offset=0&rating=g&lang=en")
    }
    
    static func forSearchGifs(searchName: String) -> URL? {
        return URL(string: "\(Constants.baseUrl)search?api_key=\(Constants.API_KEY)&q=\(searchName)&limit=25&offset=0&rating=g&lang=en")
    }
    
}

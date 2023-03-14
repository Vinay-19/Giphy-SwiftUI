//
//  Protocols.swift
//  Giphy
//
//  Created by Vinay Kumar Thapa on 2023-03-13.
//

import Foundation

// Protocol defining the behavior of a HTTP client
protocol HttpClientProtocol {
    func fetch<T: Codable>(url: URL, completion: @escaping (Result<T, Error>) -> Void)
}

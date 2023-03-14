//
//  HttpClient.swift
//  Giphy
//
//  Created by Vinay Kumar Thapa on 2023-03-14.
//

import Foundation


enum HttpError: Error {
    case badURL, badResponse, errorDecodingData, invalidURL
}

class HttpClient: HttpClientProtocol {
    
    // URLSession to be used for making the network requests
    private var urlSession: URLSession
    
    init(urlsession: URLSession) {
        self.urlSession = urlsession
    }
    
    // Makes a network request to fetch the Codable object of type Generics, to handle all models
    func fetch<T: Codable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        
        self.urlSession.dataTask(with: url, completionHandler: { data, response, error in

            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion(.failure(HttpError.badResponse))
                return
            }
            // Checking if the data was received and can be decoded to the given type T
            guard let data = data,
                  let object = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(HttpError.errorDecodingData))
                return
            }
            // If everything is successful, return the decoded object of type T
            completion(.success(object))
        })
        .resume()
    }
}


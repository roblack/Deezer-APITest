//
//  ApiRequest.swift
//  DeezerAPITest
//
//  Created by Emin Roblack on 04/02/2020.
//  Copyright © 2020 Emin Roblack. All rights reserved.
//

import Foundation

extension ApiService {
    
static func fetchResources<T: Decodable>(urlString: String, completion: @escaping (Result<T, APIError>) -> Void) {
    
    guard let finalString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let url = URL(string: finalString) else {
        completion(.failure(.InvalidURL))
        return
    }

    let session = URLSession.shared
    session.dataTask(with: url) { (result) in
        switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                        completion(.failure(.NoDataError))
                        return
                    }
                    completion(.failure(.ServerError(statusCode: statusCode)))
                    return
                }
                do {
                    let values = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.BadDataError(error: error)))
                }
            case .failure(let error):
                completion(.failure(.ConnectionError(error: error)))
            }
     }.resume()
}
}


extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
    return dataTask(with: url) { (data, response, error) in
        if let error = error {
            result(.failure(error))
            return
        }
        guard let response = response, let data = data else {
            let error = NSError(domain: "error", code: 0, userInfo: nil)
            result(.failure(error))
            return
        }
        result(.success((response, data)))
    }
}
}

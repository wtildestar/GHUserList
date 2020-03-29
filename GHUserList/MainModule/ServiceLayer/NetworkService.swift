//
//  NetworkService.swift
//  GHUserList
//
//  Created by wtildestar on 28/03/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func getUsers(completion: @escaping (Result<[User]?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    func getUsers(completion: @escaping (Result<[User]?, Error>) -> Void) {
//        let urlString = "https://api.github.com/search/users?q=page&s=updated"
        let urlString = "https://jsonplaceholder.typicode.com/comments"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                let obj = try JSONDecoder().decode([User].self, from: data!)
                completion(.success(obj))
                print(obj)
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

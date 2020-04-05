//
//  NetworkService.swift
//  GHUserList
//
//  Created by wtildestar on 28/03/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import UIKit
import CoreData

protocol NetworkServiceProtocol {
    func getSearchUsers(url: String, completion: @escaping (Result<Data, NSError>) -> Void, completion2: @escaping (([String: String]) -> Void))
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    let cache = NSCache<NSString, UIImage>()
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completed(nil)
                    return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
    
    func getSearchUsers(url: String, completion: @escaping (Result<Data, NSError>) -> Void, completion2: @escaping (([String: String]) -> Void)) {
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Failed to download users:", error)
                return
            }
            
            if response != nil {
                let httpResponse = response as! HTTPURLResponse
                let field = httpResponse.allHeaderFields["Link"] as? String
                guard let linkHeader = field else { return }
                let links = linkHeader.components(separatedBy: ",")
                
                var dictionary: [String: String] = [:]
                
                links.forEach({
                    let components = $0.components(separatedBy: "; ")
                    let cleanPath = components[0].trimmingCharacters(in: CharacterSet(charactersIn: "< >"))
                    dictionary[components[1]] = cleanPath
                })
                completion2(dictionary)
            }
            
            if let data = data {
                
                completion(.success(data))

            }
            
        }.resume()
    }
}

//
//  Service.swift
//  MVVM
//
//  Created by LanceMacBookPro on 11/3/22.
//

import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

final class Service {
    
    static let shared = Service()
    
    private init() { }
    
    enum SessionIssue: Error {
        case errorIssue(Error)
        case responseStatusCodeIssue(Int)
        case dataIsNil
        case malformedData(Error)
    }
}

// MARK: - Data Fetch
extension Service {
    
    static func fetchData(with url: URL, completion: @escaping (Result<Data, SessionIssue>)->Void) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(.errorIssue(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                
                guard 200..<300 ~= response.statusCode else {
                    completion(.failure(.responseStatusCodeIssue(response.statusCode)))
                    return
                }
            }
            
            guard let data = data else {
                completion(.failure(.dataIsNil))
                return
            }
            
            completion(.success(data))
            
        }.resume()
    }
}

// MAEK: - API Fetch
extension Service {
    
    static func fetchAPIObject(with url: URL, completion: @escaping (Result<[Card], SessionIssue>)->Void) {
        
        fetchData(with: url) { (result) in
            
            switch result {
            
            case .failure(let sessionIssue):
                
                completion(.failure(sessionIssue))
                
            case .success(let data):
                
                do {
                    
                    let deck = try JSONDecoder().decode(Deck.self, from: data)
                    
                    let cards = deck.cards
                    
                    completion(.success(cards))
                    
                } catch {
                    
                    completion(.failure(.malformedData(error)))
                }
            }
        }
    }
}

// MARK: - Cell Image Fetch
extension Service {
    
    static func fetchCellImage(with url: URL, and task: inout URLSessionTask?, completion: @escaping (Result<UIImage, SessionIssue>)->Void) {
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            completion(.success(cachedImage))
            return
        }
        
        task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let error = error {
                completion(.failure(.errorIssue(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                guard 200 ..< 300 ~= response.statusCode else {
                    completion(.failure(.responseStatusCodeIssue(response.statusCode)))
                    return
                }
            }
            
            guard let data = data, let downloadedImage = UIImage(data: data) else {
                completion(.failure(.dataIsNil))
                return
            }
            
            imageCache.setObject(downloadedImage, forKey: url.absoluteString as AnyObject)
            
            completion(.success(downloadedImage))
        })
        task?.resume()
    }
}

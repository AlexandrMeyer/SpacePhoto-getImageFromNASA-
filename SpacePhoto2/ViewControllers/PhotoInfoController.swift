//
//  PhotoInfoController.swift
//  SpacePhoto2
//
//  Created by Александр on 1.07.21.
//
import UIKit
import Foundation

class PhotoInfoController {
    func fetchPotoInfo(completion: @escaping (Result<PhotoInfo, Error>) -> Void) {
    var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
    urlComponents.queryItems = ["api_key" : "DEMO_KEY"].map { URLQueryItem(name: $0.key, value: $0.value)}

        // Обработчик завершения (Completion Handler)
    let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
        let jsonDecoder = JSONDecoder()
        if let data = data {
    // Использую do/catch чтобы уловить ошибку от JSONDecoder.decode(_:from:)
            do {
                let photoInfo = try jsonDecoder.decode(PhotoInfo.self, from: data)
                completion(.success(photoInfo))
            } catch {
                completion(.failure(error))
            }
        } else if let error = error {
            completion(.failure(error))
        }
    }

    task.resume()
    }
    
    enum PhotoInfoError: Error, LocalizedError {
        case imageDataMissing
    }
    
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
    //обновляю url что использовать более безопасный https
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.scheme = "https"
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(PhotoInfoError.imageDataMissing))
            }
        }
        task.resume()
    }
    
}

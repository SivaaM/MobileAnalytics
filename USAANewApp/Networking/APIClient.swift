//
//  APiClient.swift
//  Covid19Awarness
//
//  Created by Fahath Rajak on 03/04/20.
//  Copyright © 2020 Fahath. All rights reserved.
//
import Foundation

// TODO: - Move to the separated file Resource.swift
struct Resource {
    let url: URL
    let method: String
    let additionHeaders: [AdditionalHeader]?
    let httpBody: String?
}

struct AdditionalHeader {
    let name: String
    let value: String
}

// TODO: - Move to the separated file GenericResult.swift
enum Result<T> {
    case success(T)
    case failure(Error)
}

enum APIClientError: Error {
    case noData
}

// TODO: - Move to the separated file URLRequest+Resource.swift
extension URLRequest {
    
    init(_ resource: Resource) {
        self.init(url: resource.url)
        self.httpMethod = resource.method
        if let httpBody = resource.httpBody {
            let data = Data(httpBody.utf8)
            self.httpBody = data
        }
        if let additionalHeaders = resource.additionHeaders {
            for header in additionalHeaders {
                self.addValue(header.value, forHTTPHeaderField: header.name)
            }

        }
        
    }
    
}

final class APIClient {
    
    func load(_ resource: Resource, result: @escaping ((Result<Data>) -> Void)) {
        let request = URLRequest(resource)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let `data` = data else {
                result(.failure(APIClientError.noData))
                return
            }
            if let `error` = error {
                result(.failure(error))
                return
            }
            result(.success(data))
        }
        task.resume()
    }
    
}

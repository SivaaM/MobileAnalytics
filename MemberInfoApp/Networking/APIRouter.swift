//
//  APiRouter.swift
//  Covid19Awarness
//
//  Created by Fahath Rajak on 03/04/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import Foundation



final class APIRouter {
    
    private let apiClient: APIClient!
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getDialougueFlow(for question: String, completion: @escaping ((Result<DialogueResponse>) -> Void)) {
        
        let resource = Resource(url: URL(string: "https://dialogflow.googleapis.com/v2/projects/askthiprototype-niiehd/agent/sessions/3ad89ca5-7e42-41c6-4c82-d991e0ee1da3:detectIntent")!, method: "GET", additionHeaders: [AdditionalHeader(name: "Authorization", value: "")], httpBody: "{\"queryInput\":{\"text\":{\"text\":\"\(question)\",\"languageCode\":\"en\"}},\"queryParams\":{\"timeZone\":\"America/Chicago\"}}")
        apiClient.load(resource) { (result) in
            switch result {
            case .success(let data):
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                        print(json)
                        if let result = json["queryResult"] as? DialogueResponse {
                            completion(.success(result))
                        }
                    }
                }catch let error {
                    completion(.failure(error))
                }
//                do {
//                    let items = try JSONDecoder().decode(LatestCase.self, from: data)
//                    completion(.success(items))
//                } catch {
//                    completion(.failure(error))
//                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMemberInfoData<T>(for dialogueResponse: T, completion: @escaping ((Result<MemberInfoResponse>) -> Void)) {
        let urlString = "https://dialogflow.googleapis.com/v2/projects/askthiprototype-niiehd/agent/sessions/3ad89ca5-7e42-41c6-4c82-d991e0ee1da3:detectIntent"
        var resource: Resource?
        if let dialogueRes = dialogueResponse as? DialogueMockResponse {
            let paramterHandler = ParameterHandler(response: dialogueRes)
            resource = Resource(url: URL(string: urlString)!, method: "GET", additionHeaders: [AdditionalHeader(name: "Authorization", value: "")], httpBody: paramterHandler.parameter)
        } else if let dialogueRes = dialogueResponse as? DialogueResponse {
            let paramterHandler = ParameterHandler(response: dialogueRes)
            resource = Resource(url: URL(string: urlString)!, method: "GET", additionHeaders: [AdditionalHeader(name: "Authorization", value: "")], httpBody: paramterHandler.parameter)
        }
            
        guard let rsorc = resource else { return }
            apiClient.load(rsorc) { (result) in
                switch result {
                case .success(let data):
                    
                    do {
                        let items = try JSONDecoder().decode(MemberInfoResponse.self, from: data)
                        completion(.success(items))
                    } catch {
                        if let dialogueRes = dialogueResponse as? DialogueMockResponse {
                            completion(.success(MemberInfoResponse(responseImage: dialogueRes.responseImage)))
                        } else {
                            completion(.failure(error))
                        }                    }
                case .failure(let error):
                    if let dialogueRes = dialogueResponse as? DialogueMockResponse {
                        completion(.success(MemberInfoResponse(responseImage: dialogueRes.responseImage)))
                    } else {
                        completion(.failure(error))
                    }
                }
        }
    }
}

//
//  ContainerViewModel.swift
//  MemberInfoApp
//
//  Created by Fahath Rajak on 27/03/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import Foundation

struct ContainerViewMidel {
    let isMock = true
    let confirmationTexts = ["Ok", "ok", "Yes", "yes"]

    let router = APIRouter(apiClient: APIClient())

    var mockResponses: [MockResponse] {
        return fetchProperties()
    }
    
    private func fetchProperties() -> [MockResponse] {
        guard let path = Bundle.main.path(forResource: "mockresponse", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path),
            let data = (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String: Any],
            let queries = data["mocks"] as? [Any] else {
            fatalError("Unable to read data")
        }
        var mockresponses = [MockResponse]()
        for query in queries {
            guard let query = query as? Dictionary<String, AnyObject>, let jsonData = query.json.data(using: .utf8) else {
                fatalError("Unable to read data")
            }
            
            if let result = try? JSONDecoder().decode(MockResponse.self, from: jsonData) {
                mockresponses.append(result)
            }
        }
        
        return mockresponses
    }
    
    fileprivate func processMockResponse(for question: String, completion: @escaping ((VoiceResponse)-> ())) {
        let response = mockResponses.filter { (mockResponse) -> Bool in
            question == mockResponse.resolvedQuery
        }.first
        if let response = response {
            completion(.respose(response.speech, response.responseImage))
        }
    }
    
    func fetchMemberInfo(_ question: String, completion: @escaping ((VoiceResponse)-> ())) {
        router.getMemberInfoData(for: question) { (result) in
            switch result {
                case .success(let response):
                    print("\(self) response: \(response.fulfillmentText)")
                    completion(.respose(response.fulfillmentText, ""))
                case .failure(let error):
                    print("\(self) error: \(error)")
            }
        }
    }
    
    func fetchInfoforQuestion(_ question: String, completion: @escaping ((VoiceResponse)-> ())) {
        
        guard !isMock else {
            processMockResponse(for: question) { (response) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    completion(response)
                }
            }
            return
        }
        
        let dialogueOperation = DialogueOperation(question: question)
        let memberInfoOperation = MemberInfoOperation()
        let connection = BlockOperation {
          memberInfoOperation.dialogueResponse = dialogueOperation.dialogueResponse
          memberInfoOperation.error = dialogueOperation.error
        }
        memberInfoOperation.addDependency(connection)
        connection.addDependency(dialogueOperation)

        memberInfoOperation.completionBlock = {
            if memberInfoOperation.isFinished {
                if let response = memberInfoOperation.memberInfoResponse {
                    completion(.respose(response.fulfillmentText, ""))
                }
            }
        }
        let queue = OperationQueue()
        queue.addOperations([dialogueOperation, memberInfoOperation, connection], waitUntilFinished: false)
        /*
        router.getDialougueFlow(for: question) { (result) in
            switch result {
                case .success(let response):
                    print("\(self) response: \(response.fulfillmentText)")
                    self.fetchMemberInfo(response.fulfillmentText) { (dataResponse) in
                            completion(dataResponse)
                    }
                case .failure(let error):
                    print("\(self) error: \(error)")
            }
        }*/
    
    }
}

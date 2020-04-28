//
//  DialogueMockReqHandler.swift
//  MemberInfoApp
//
//  Created by Fahath Rajak on 27/04/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import Foundation


struct DialogueMockReqHandler {
    let question: String
    private(set) var mockResponses: [DialogueMockResponse]?

//    var mockResponses: [MockResponse] {
//        return fetchProperties()
//    }
    init(question: String) {
        self.question = question
        self.mockResponses = fetchProperties()
    }
    
    func processMockResponse(completion: @escaping ((DialogueMockResponse)-> ())) {
        let response = mockResponses?.filter { (mockResponse) -> Bool in
            checkConditions(for: mockResponse)
        }.first
        if let response = response {
            completion(response)
        }
    }
    
    private func checkConditions(for mockResponse: DialogueMockResponse) -> Bool {
        return question == mockResponse.resolvedQuery
    }
    
    private func fetchProperties() -> [DialogueMockResponse] {
        guard let path = Bundle.main.path(forResource: "mockresponse", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path),
            let data = (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String: Any],
            let queries = data["mocks"] as? [Any] else {
            fatalError("Unable to read data")
        }
        var mockresponses = [DialogueMockResponse]()
        for query in queries {
            guard let query = query as? Dictionary<String, AnyObject>, let jsonData = query.json.data(using: .utf8) else {
                fatalError("Unable to read data")
            }
            
            if let result = try? JSONDecoder().decode(DialogueMockResponse.self, from: jsonData) {
                mockresponses.append(result)
            }
        }
        
        return mockresponses
    }
}

//
//  ParameterHandler.swift
//  MemberInfoApp
//
//  Created by Fahath Rajak on 27/04/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import Foundation

struct ParameterHandler<T> {
    let response: T
    init(response: T) {
        self.response = response
    }
    
    var parameter: String {
        if let response = response as? DialogueMockResponse, let dict = fetchParams(response: response) {
            
                return dict.json
        } else if let response = response as? DialogueResponse, let _ = fetchParams(response: response) {
            return ""
        }
        
        return ""
    }
    
    private func fetchParams(response: DialogueMockResponse) -> [String: Any]? {
        var parsedDict: [String: Any]? = ["fact":"\(response.intentName)"]
        
        if let filterMilitaryRank = response.filter_militaryRank, !filterMilitaryRank.isEmpty {
            parsedDict?["filter_militaryRank"] = "\(filterMilitaryRank)"
        }
        
        if let filter_memberStatus = response.filter_memberStatus, !filter_memberStatus.isEmpty {
            parsedDict?["filter_memberStatus"] = "\(filter_memberStatus)"
        }
        
        if let filter_date = response.filter_date, !filter_date.isEmpty {
            parsedDict?["filter_date"] = "\(filter_date)"
        }
        
        if let group = response.group, !group.isEmpty {
            parsedDict?["group"] = ["\(group)"]
        }

        return parsedDict
    }
    
    private func fetchParams(response: DialogueResponse) -> [String: Any]? {
        let parsedDict: [String: Any]? = nil

        return parsedDict
    }
}

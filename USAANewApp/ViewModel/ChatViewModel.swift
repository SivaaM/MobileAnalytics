//
//  ChatViewModel.swift
//  USAANewApp
//
//  Created by Fahath Rajak on 27/03/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import Foundation

struct ChatViewModel {
    var currentData: [Detail] = []

    mutating func injectChat(_ detail: Detail?) {
        if let detail = detail {
            currentData.append(detail)
        }
    }
    
    func fetchParam(for rawString: String, completion: @escaping (String) -> ()) {
        completion("sampleParam")
    }
    
}

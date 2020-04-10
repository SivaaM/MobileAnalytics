//
//  ParseOperation.swift
//  OperationDependency
//
//  Created by Fahath Rajak on 09/04/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import Foundation

final class MemberInfoOperation: Operation {

    override var isAsynchronous: Bool {
        return true
    }

    private var _isExecuting = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    override var isExecuting: Bool {
        return _isExecuting
    }

    private var _isFinished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    override var isFinished: Bool {
        return _isFinished
    }
    
    var memberInfoResponse: DialogueResponse?
    var dialogueResponse: DialogueResponse?
    var error: Error?
    let router = APIRouter(apiClient: APIClient())

    override func start() {
        guard !isFinished, let dialogueResponse = dialogueResponse, error == nil else { return }
        _isExecuting = true
        
        router.getMemberInfoData(for: dialogueResponse.fulfillmentText) { [weak self](result) in
            switch result {
            case .success(let response):
                self?.memberInfoResponse = response
                self?._isFinished = true
            case .failure(let error):
                self?.error = error
            }
        }

    }

    override func cancel() {
        _isFinished = true
    }
}

//
//  ParseOperation.swift
//  OperationDependency
//
//  Created by Fahath Rajak on 09/04/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import Foundation

final class MemberInfoOperation<T>: Operation {

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
    
    var memberInfoResponse: MemberInfoResponse?
    var dialogueResponse: T?

    var error: Error?
    let router = APIRouter(apiClient: APIClient())

    override func start() {
        _isExecuting = true
        
        if !isFinished, let dialogueResponse = dialogueResponse, error == nil {
            router.getMemberInfoData(for: dialogueResponse) { [weak self](result) in
                guard let _self = self else { return }
                defer {
                    _self._isExecuting = false
                    _self._isFinished = true
                }

                switch result {
                case .success(let response):
                    _self.memberInfoResponse = response
                case .failure(let error):
                    self?.error = error
                }
            }
        } else {
            self._isExecuting = false
            self._isFinished = true
        }
        
    }

    override func cancel() {
        _isFinished = true
    }
}

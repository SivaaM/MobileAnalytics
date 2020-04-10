//
//  FetchOperation.swift
//  OperationDependency
//
//  Created by Fahath Rajak on 09/04/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import Foundation

final class DialogueOperation: Operation {

  override var isAsynchronous: Bool {
    return true
  }

  // Let our backing variables emit KVO notifications
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

  private(set) var dialogueResponse: DialogueResponse?
  private(set) var error: Error?
  private let question: String
  private var task: URLSessionTask?

  init(question: String) {
    self.question = question
    super.init()
  }
    
  let router = APIRouter(apiClient: APIClient())


  override func start() {
    // For asynchronous operations, check the isCancelled state before performing work
    guard !isCancelled else { return }
    _isExecuting = true
    router.getDialougueFlow(for: question) { [weak self](result) in
        switch result {
            case .success(let response):
                self?.dialogueResponse = response
                self?._isFinished = true
            case .failure(let error):
                self?.error = error
        }
    }
  }

  override func cancel() {
    task?.cancel()
    _isFinished = true
  }

}

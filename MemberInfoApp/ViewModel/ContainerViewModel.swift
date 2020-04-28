//
//  ContainerViewModel.swift
//  MemberInfoApp
//
//  Created by Fahath Rajak on 27/03/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import Foundation

struct ContainerViewModel {
    let isMock = true
    let confirmationTexts = ["Ok", "ok", "Yes", "yes"]

    let router = APIRouter(apiClient: APIClient())
    typealias VoiceResponseBlock = ((VoiceResponse<DialogueMockResponse, MemberInfoResponse>) -> ())
    
    func handleMockReq(for question: String, completion: @escaping VoiceResponseBlock) {
        let dlgOprn = DialogueOperation(question: question, isMock: isMock)
        let mbrOprn = MemberInfoOperation<DialogueMockResponse>()
        let connection = BlockOperation {
            if let response = dlgOprn.dialogueMockResponse {
                mbrOprn.dialogueResponse = response
            }
            mbrOprn.error = dlgOprn.error
        }
        mbrOprn.addDependency(connection)
        connection.addDependency(dlgOprn)
        
        mbrOprn.completionBlock = {
            if let response = dlgOprn.dialogueMockResponse, let memberInfoResponse = mbrOprn.memberInfoResponse  {
                completion(.respose(response, memberInfoResponse))
            }
        }
        let queue = OperationQueue()
        queue.addOperations([dlgOprn, mbrOprn, connection], waitUntilFinished: false)
    }
    
    func handleReq(for question: String, completion: @escaping VoiceResponseBlock) {
        let dialogueOperation = DialogueOperation(question: question, isMock: isMock)
        let mbrOprn = MemberInfoOperation<DialogueResponse>()

    }
    
    func fetchInfoforQuestion(_ question: String, completion: @escaping VoiceResponseBlock) {
        
        if isMock {
            handleMockReq(for: question) { (response) in
                completion(response)
            }
        }
        
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
        }*/
    
    }
}

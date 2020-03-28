//
//  ContainerViewModel.swift
//  USAANewApp
//
//  Created by Fahath Rajak on 27/03/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import Foundation

struct ContainerViewMidel {
    let confirmationTexts = ["Ok", "ok", "Yes", "yes"]
    var networkManager = NetworkManager()

    func fetchInfoforQuestion(_ question: String, completion: @escaping ((VoiceResponse)-> ())) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let confirm = self.confirmationTexts.contains(where: question.contains)
            if question.contains("members") {
                completion(.respose("Do you want info about members?"))
            } else if confirm {
                completion(.confirm)
            }
        }
        
//        networkManager.getVoiceResponse(param: question) { (response, error) in
//            print(response ?? "")
//            print(error ?? "")
//            completion(.respose("Do you want info about members?"))

//        }
        
    }
    
}

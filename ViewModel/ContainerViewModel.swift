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
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let confirm = self.confirmationTexts.contains(where: question.contains)
//            if question.contains("members") {
//                completion(.respose("Do you want info about members?"))
//            } else if confirm {
//                completion(.confirm)
//            }
//        }
        
//        networkManager.getVoiceResponse(param: question) { (response, error) in
//            print(response ?? "")
//            print(error ?? "")
//            completion(.respose(response?.description ?? "Sorry can you repeat"))
//        }
        
        if confirm {
            completion(.confirm)
        }else {
        
            let url = URL(string: "https://dialogflow.googleapis.com/v2/projects/askthiprototype-niiehd/agent/sessions/3ad89ca5-7e42-41c6-4c82-d991e0ee1da3:detectIntent")!

            let session = URLSession.shared

            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            let str = "{\"queryInput\":{\"text\":{\"text\":\"\(question)\",\"languageCode\":\"en\"}},\"queryParams\":{\"timeZone\":\"America/Chicago\"}}"
            let data = Data(str.utf8)
            request.httpBody = data

            request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer ya29.c.Ko8BxAducZ85Pp9nMfBQVhinwZChdz1bcZ8aEQsZYSZ4u5-_IVyj3aHlssvqoiGVhoRGxgS5XRMm9aRZdOKoSevhzXUhjG2ptMhu4Iif8LJOK-uxq2rFfup2rEQOBogh1xckRDWI0qCGqASslemJKzdoz-b45s-R8l6zv_G2QxYhm6Q4S1zsB594iy4BWEW0aoY", forHTTPHeaderField: "Authorization")

            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error in
                
                guard error == nil else {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                        print(json)
                        if let result = json["queryResult"]?["fulfillmentText"] as? String {
                            completion(.respose(result))
                        }
                    }
                }catch let error {
                    print(error)
                }
            })
            task.resume()
        }
    }
}

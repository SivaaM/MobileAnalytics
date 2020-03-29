//
//  EndPoint.swift
//  USAANewApp
//
//  Created by Fahath Rajak on 27/03/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case production
    case development
}

public enum VoiceApi {
    case voiceInput(string:String)
    case processInput(page:String)
}

extension VoiceApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://dialogflow.googleapis.com/"
        case .development: return "https://dialogflow.cloud.google.com/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .voiceInput:
            return "v2/projects/askthiprototype-niiehd/agent/sessions/3ad89ca5-7e42-41c6-4c82-d991e0ee1da3:detectIntent"
        case .processInput:
            return "/v2/projects/askthiprototype-niiehd/agent/sessions/js-12345:detectIntent"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var task: HTTPTask {
        switch self {
            case .voiceInput(let _):
                let headers = ["Authorization" : "Bearer ya29.c.Ko8BxAducZ85Pp9nMfBQVhinwZChdz1bcZ8aEQsZYSZ4u5-_IVyj3aHlssvqoiGVhoRGxgS5XRMm9aRZdOKoSevhzXUhjG2ptMhu4Iif8LJOK-uxq2rFfup2rEQOBogh1xckRDWI0qCGqASslemJKzdoz-b45s-R8l6zv_G2QxYhm6Q4S1zsB594iy4BWEW0aoY", "Content-Type" : "application/json"]
                let bodyParams = ["queryInput" : [
                    "text" : [
                        "text" : "new members",
                        "languageCode" : "en",
                        "queryParams" : [
                            "timeZone" : "America/Chicago"
                        ]
                      ]
                ]]
                return .requestParametersAndHeaders(bodyParameters: bodyParams, bodyEncoding: .urlEncoding, urlParameters: [:], additionHeaders: headers)
            default:
                return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}



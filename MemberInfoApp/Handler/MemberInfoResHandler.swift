//
//  MemberInfoResHandler.swift
//  MemberInfoApp
//
//  Created by Fahath Rajak on 20/05/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import Foundation

struct MemberInfoResHandler<T> {
    private(set) var result: Result<FinalResponse>?
    private let dialogueResponse: T
    private let data: Data?

    init(data: Data?, dialogueRes: T) {
        self.data = data
        self.dialogueResponse = dialogueRes
        self.result = processResponse()
    }
    
    enum ParseError: Error {
        case wrongProperties
        case errorData
        case mockDataUnAvailable
    }
    
    private func handleFailure() -> Result<FinalResponse> {
        if let dialogueRes = dialogueResponse as? DialogueMockResponse {
            let intentType = dialogueRes.intentType
            if intentType == "by_gender" {
                let response: ChartInfoResponse = FileLoader.load(intentType + ".json")
                let finalRes = FinalResponse(chartResponse: response)
                return .success(finalRes)
            } else if intentType == "by_members" {
                let response: MemberInfoResponse = FileLoader.load(intentType + ".json")
                let finalRes = FinalResponse(memberResponse: response)
                return .success(finalRes)
            } else {
                return .failure(ParseError.mockDataUnAvailable)
            }
        } else {
            return .failure(ParseError.wrongProperties)
        }
    }

    private func processMemberResponse() throws -> Result<FinalResponse> {
        guard let data = data else {  return handleFailure() }
        do {
            let response = try JSONDecoder().decode(MemberInfoResponse.self, from: data)
            let finalRes = FinalResponse(memberResponse: response)
            return .success(finalRes)
        } catch {
            return handleFailure()
        }
    }
    
    private func processChartResponse() throws -> Result<FinalResponse> {
        guard let data = data else {  return handleFailure() }

        do {
            let response = try JSONDecoder().decode(ChartInfoResponse.self, from: data)
            let finalRes = FinalResponse(chartResponse: response)
            return .success(finalRes)
        } catch {
            return handleFailure()
        }
    }

    func getFirstSuccessfulResponse<T>(_ values: (() throws -> T)...) -> T? {
        return values.lazy.compactMap({ (throwingFunc) -> T? in
            return try? throwingFunc()
        }).first
    }

    private func processResponse() -> Result<FinalResponse> {
        return getFirstSuccessfulResponse(processMemberResponse, processChartResponse) ?? .failure(ParseError.wrongProperties)
    }
}

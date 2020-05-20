//
//  ChatViewModel.swift
//  MemberInfoApp
//
//  Created by Fahath Rajak on 27/03/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import UIKit

//struct ChatViewModel {
//    var currentData: [Detail] = []
//
//    mutating func injectChat(_ detail: Detail?) {
//        if let detail = detail {
//            currentData.append(detail)
//        }
//    }
//
//    func fetchParam(for rawString: String, completion: @escaping (String) -> ()) {
//        //TODO - response handle
//        if rawString.contains("November") || rawString.contains("november") {
//            completion("nov-chart")
//        } else {
//            completion("year-chart")
//        }
//    }
//
//}

class ChatViewModel {
    let rowViewModel = Observable<[RowViewModel]>(value: [])
    
    func cellIdentifier(for viewModel: RowViewModel) -> String {
        switch viewModel {
        case is UserQuestionViewModel:
            return UserQuestionCell.cellIdentifier()
        case is BotResponseMembersViewModel:
            return BotResponseMembersCell.cellIdentifier()
        case is BotResponseChartViewModel:
            return BotResponseChartCell.cellIdentifier()
        default:
            fatalError("Unexpected view model type: \(viewModel)")
        }
    }
    
    func injectQuestion(question: String) {
        if !question.isEmpty {
            let vm = buildUserQuestionModel(question: question)
            rowViewModel.value.append(vm)
        }
    }
    
    func injectBotResponse(dialogueRes: DialogueMockResponse, finalResponse: FinalResponse?, parentVC: UIViewController) {
        
        if let finalResponse = finalResponse, 
            let vm =  buildBotModel(dialogueRes: dialogueRes, finalResponse: finalResponse, on: parentVC) {
            DispatchQueue.global().async {
                sleep(1) 
                DispatchQueue.main.async {
                    self.rowViewModel.value.append(vm)
                }
            }
        }
    }
    
    private func buildBotModel(dialogueRes: DialogueMockResponse, finalResponse: FinalResponse, on parentVC: UIViewController) -> RowViewModel? {
        if let mbrInfoRes = finalResponse.memberResponse {
            let members = mbrInfoRes.data.map { (dataSec) -> Int in
                dataSec.c1
                }.first
            let membersCount = Int(members ?? 0)
            return BotResponseMembersViewModel(response: dialogueRes.speech, title: "Total Members", totalMbrs: membersCount)

        } else if let chartInfoRes = finalResponse.chartResponse {
            let members = chartInfoRes.data.map { (dataSec) -> Int in
                (Int(dataSec.c2) ?? 0)
            }
            return BotResponseChartViewModel(response: dialogueRes.speech, chartInfo: members, parentVC: parentVC)
        }
        return nil
    }
    
    private func buildUserQuestionModel(question: String) -> RowViewModel {
        return UserQuestionViewModel(question: question)
    }
}

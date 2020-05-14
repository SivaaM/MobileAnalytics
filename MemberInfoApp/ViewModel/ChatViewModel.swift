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
    
    func injectBotResponse(dialogueRes: DialogueMockResponse,mbrInfoRes: MemberInfoResponse?, parentVC: UIViewController) {
        
        if let mbrInfoRes = mbrInfoRes {
            let vm =  buildBotModel(dialogueRes: dialogueRes, mbrInfoRes: mbrInfoRes, on: parentVC)
            DispatchQueue.global().async {
                sleep(1) 
                DispatchQueue.main.async {
                    self.rowViewModel.value.append(vm)
                }
            }
        }
    }
    
    private func buildBotModel(dialogueRes: DialogueMockResponse, mbrInfoRes: MemberInfoResponse, on parentVC: UIViewController) -> RowViewModel {
        if mbrInfoRes.data.count == 1 {
            let members = mbrInfoRes.data.map { (dataSec) -> String in
                dataSec.c1
                }.first
            let membersCount = Int(members ?? "0")!
            return BotResponseMembersViewModel(response: dialogueRes.speech, title: "Total Members", totalMbrs: membersCount)

        } else {
            let members = mbrInfoRes.data.map { (dataSec) -> Int in
                (Int(dataSec.c2!) ?? 0)
                }
            return BotResponseChartViewModel(response: dialogueRes.speech, chartInfo: members, parentVC: parentVC)
        }
    }
    
    private func buildUserQuestionModel(question: String) -> RowViewModel {
        return UserQuestionViewModel(question: question)
    }
}

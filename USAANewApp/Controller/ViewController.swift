//
//  ViewController.swift
//  USAANewApp
//
//  Created by Fahath Rajak on 3/25/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import UIKit





class ViewController: UIViewController {
    @IBOutlet weak var containerChatFlow: UIView!
    @IBOutlet weak var containerSpeech: UIView!

    let containerVM = ContainerViewMidel()
    private lazy var chatVC: ChatFlowVC? = {
        guard let childVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatFlowVC") as? ChatFlowVC else {
                     return nil
        }
        
        addChild(childVC)
        childVC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        childVC.view.frame = containerChatFlow.bounds
        containerChatFlow.addSubview(childVC.view)
        childVC.didMove(toParent: self)
        return childVC
    }()
    
    private lazy var speechVC: SpeechVC? = {
        guard let childVC = self.storyboard?.instantiateViewController(withIdentifier: "SpeechVC") as? SpeechVC else {
                     return nil
        }
        
        addChild(childVC)
        childVC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        childVC.view.frame = containerSpeech.bounds
        containerSpeech.addSubview(childVC.view)
        childVC.didMove(toParent: self)
        return childVC
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        addChatVC()
        addSpeechVC()
    }
    
    private func addChatVC() {
        if let childVC = chatVC {
            childVC.injectChat(nil)
        }
    }
    
    private func addSpeechVC() {
        if let childVC = speechVC {
            childVC.speechDataDelegate = self
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "speechVC" {
            if let vc = segue.destination as? SpeechVC {
                vc.speechDataDelegate = self
            }
        }
    }
    
    fileprivate func navigateToDetail() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC else { return }
        navigationController?.pushViewController(vc, animated: true)
        vc.title = "Ask Thi"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
}

extension ViewController: SpeechDataDelegate {
    func voiceInput(_ string: String?) {
        
        if let childVC = chatVC, let question = string {
            print(question)
            let detail = Detail(question: question, isMemebr: true)
            childVC.injectChat(detail)

            containerVM.fetchInfoforQuestion(question) { (response) in
                switch response {
                case .respose(let info):
                    let detail = Detail(question: info, isMemebr: false)
                    childVC.injectChat(detail)
                case .confirm:
                    self.navigateToDetail()
                }
            }
        }
    }
}



//
//  DetailVC.swift
//  USAANewApp
//
//  Created by Fahath Rajak on 3/25/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import UIKit



class ChatFlowVC: UITableViewController, ChatFlowDelegate {
    
    var currentData: [Detail] {
        return chatVM.currentData
    }
    lazy var chatVM: ChatViewModel = {
        return ChatViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
    }
    
    func injectChat(_ detail: Detail?) {
        if let detail = detail {
            chatVM.injectChat(detail)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if self.currentData.count > 1 {
                    self.tableView.scrollToRow(at: IndexPath(row: self.currentData.count - 1, section: 0), at: .bottom, animated: true)

                }
           }
        }
    }
    
    func showReport(for string: String?) {
        guard let rawString = string else {
            return
        }
        chatVM.fetchParam(for: rawString) { [weak self] (param) in
            print(param)
            self?.navigateToDetail()
        }
    }
    
    fileprivate func navigateToDetail() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC else { return }
        navigationController?.pushViewController(vc, animated: true)
        vc.title = "Ask Thi"
    }
}

extension ChatFlowVC {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentData.count == 0 {
            self.tableView.setEmptyMessage("Hi, How Can I Help You?")
        } else {
            self.tableView.restore()
        }
        return currentData.count
    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return currentData.count
//    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
        cell.detail = currentData[indexPath.row]
        cell.delegate = self
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let info = currentData[indexPath.row]
        let defHeight = info.question.estimateFrameForText().height
        //return  defHeight + 30.0

        return !info.isMemebr && info.isFinalResponse ? defHeight + 90.0 : defHeight + 50.0
    }

}

class ChatCell: UITableViewCell {
    
    var reportConstraints: [NSLayoutConstraint]?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    var bubbleHeightAnchor: NSLayoutConstraint?
    var bubbleWidthAnchor: NSLayoutConstraint?
    var infoHeightAnchor: NSLayoutConstraint?

    weak var delegate: ChatFlowDelegate?
    var detail: Detail? {
        didSet {
            if let detail = detail {
                
                question.text = detail.question
                question.textColor = .white
                question.textAlignment = .left
                bubbleView.backgroundColor = detail.isMemebr ? .appLightBlue : .appDarkBlue
                performUpdateConstarints()

            }
        }
    }
    
    private func performUpdateConstarints() {
        if let detail = detail {
            let textHeight = detail.question.estimateFrameForText().height + 30
            let chatHeight = !detail.isMemebr && detail.isFinalResponse ? textHeight + 40 : textHeight
            let isMember = detail.isMemebr
            bubbleLeftAnchor?.isActive = isMember
            bubbleRightAnchor?.isActive = !isMember
            bubbleHeightAnchor?.constant = chatHeight
            bubbleWidthAnchor?.constant = detail.question.estimateFrameForText().width + 40
            infoHeightAnchor?.constant = textHeight
            if !detail.isMemebr && detail.isFinalResponse {
                performAddingReportAction()
            }
        }
    }
    
    let question: UITextView = {
            let tv = UITextView()
            tv.text = "message"
            tv.font = UIFont(name: "TrebuchetMS", size: 20)
            tv.translatesAutoresizingMaskIntoConstraints = false
            tv.backgroundColor = UIColor.clear
            tv.textColor = .white
            tv.isUserInteractionEnabled = false
            return tv
        }()
    
//    let goToReport: UITextView = {
//        let tv = UITextView()
//        tv.text = "message"
//        tv.font = UIFont(name: "TrebuchetMS", size: 20)
//        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.backgroundColor = UIColor.clear
//        tv.textColor = .white
//        tv.isUserInteractionEnabled = false
//        return tv
//    }()
    
    lazy var goToReport: UIButton = {
           let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.tintColor = .appLightBlue
        button.titleLabel?.font = UIFont(name: "TrebuchetMS", size: 20)
        button.backgroundColor = .white
        button.setTitle("Show Report >", for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(goToCurrentReport), for: .touchUpInside)
        return button
    }()
        
        let bubbleView: UIView = {
            let view = UIView()
            view.backgroundColor = .appDarkBlue
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 8
            view.layer.masksToBounds = true
            return view
        }()
        
    
    override func awakeFromNib() {
                
        addSubview(bubbleView)
        addSubview(question)
        //x,y,w,h
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50)
        //bubbleRightAnchor?.isActive = false
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15)
        //bubbleLeftAnchor?.isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        //bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        bubbleHeightAnchor = bubbleView.heightAnchor.constraint(equalToConstant: 100)
        bubbleHeightAnchor?.isActive = true
        
        question.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        question.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        question.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
    //       question.widthAnchor.constraintEqualToConstant(200).active = true
        
        infoHeightAnchor = question.heightAnchor.constraint(equalToConstant: 0)
        infoHeightAnchor?.isActive = true

    }
    
    private func performAddingReportAction() {
        addSubview(goToReport)

        goToReport.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        //goToReport.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -8).isActive = true
        goToReport.topAnchor.constraint(equalTo: question.bottomAnchor).isActive = true
        goToReport.heightAnchor.constraint(equalToConstant: 30).isActive = true
        goToReport.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    @objc func goToCurrentReport() {
        print("New")
        delegate?.showReport(for: detail?.question)
    }
    
}

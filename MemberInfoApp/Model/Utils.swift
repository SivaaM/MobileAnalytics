//
//  Utils.swift
//  MemberInfoApp
//
//  Created by Fahath Rajak on 27/03/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import Foundation
import UIKit

enum Child {
    case speech
    case chat
}

enum VoiceResponse {
    case respose(String, String?)
    case confirm
}

protocol SpeechDataDelegate: class {
    func voiceInput(_ string: String?)
}

protocol ChatFlowDelegate: class {
    func showReport(for param: String?)
}

struct Detail {
    let question: String
    let isMemebr: Bool
    var isFinalResponse: Bool = false
    var hasChartResponse: Bool = true
    var chartImage: String?
    var parentVC: UIViewController?
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
    
    func estimateFrameForText() -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: self).boundingRect(with: size, options: options, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "TrebuchetMS", size: 20)!]), context: nil)
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    private func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
        guard let input = input else { return nil }
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
    }

    // Helper function inserted by Swift 4.2 migrator.
    private func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
        return input.rawValue
    }
}


extension UIColor {
    static let appDarkBlue = UIColor(red: 18/255.0, green: 56/255.0, blue: 92/255.0, alpha: 1.0)
    static let appLightBlue = UIColor(red: 16/255.0, green: 153/255.0, blue: 189/255.0, alpha: 1.0)
    static let appLightGray = UIColor(red: 233/255.0, green: 233/255.0, blue: 225/255.0, alpha: 1.0)

}

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 25)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}


extension UIViewController {
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
}

struct MockResponse: Codable {
    let resolvedQuery: String
    let intentName: String
    let responseImage: String
    let speech: String
}

struct DialogueResponse {
    let fulfillmentText: String
}


extension Dictionary {

    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }

}

struct MockItem {
    static func calculateWidth(for item: String) -> CGFloat {
        var height: CGFloat = 0.0
        if item.contains("table") {
            height = 480.0
        } else if item.contains("number") {
            height = 140.0
        } else {
            height = 375.0
        }
        return height
    }
}

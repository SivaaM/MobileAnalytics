//
//  SpeechVC.swift
//  USAANewApp
//
//  Created by Fahath Rajak on 3/25/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import UIKit
import Speech

class SpeechVC: UIViewController, SFSpeechRecognizerDelegate {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
       private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
       private var recognitionTask: SFSpeechRecognitionTask?
       private let audioEngine = AVAudioEngine()

    weak var speechDataDelegate: SpeechDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        microphoneButton.isEnabled = false
        
        speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            default:
                isButtonEnabled = false
                print("User denied access to speech recognition")
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
    }
     func startRecording() {
            
            if recognitionTask != nil {
                recognitionTask?.cancel()
                recognitionTask = nil
            }
            
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.record)
                try audioSession.setMode(AVAudioSession.Mode.measurement)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                print("audioSession properties weren't set because of an error.")
            }
            
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            
            let inputNode = audioEngine.inputNode
            
            guard let recognitionRequest = recognitionRequest else {
                fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
            }
            
            recognitionRequest.shouldReportPartialResults = true
            
            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
                
                var isFinal = false
                var formattedString: String?
                if result != nil {
                    formattedString = result?.bestTranscription.formattedString
                    self.textView.text = formattedString
                    isFinal = (result?.isFinal)!
                    
                }
                
                if error != nil || isFinal {
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    
                    self.microphoneButton.isEnabled = true
                    
                    
                }
            })
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
                self.recognitionRequest?.append(buffer)
            }
            
            audioEngine.prepare()
            
            do {
                try audioEngine.start()
            } catch {
                print("audioEngine couldn't start because of an error.")
            }
            
            textView.text = "Say something, I'm listening!"
            
        }
     
        @IBAction func microphoneTapped(_ sender: AnyObject) {
            if audioEngine.isRunning {
                audioEngine.stop()
                recognitionRequest?.endAudio()
                microphoneButton.isEnabled = false
                microphoneButton.setImage(#imageLiteral(resourceName: "mic"), for: .normal)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.speechDataDelegate?.voiceInput(self.textView.text)
                }
            } else {
                startRecording()
                let image = #imageLiteral(resourceName: "micRecording").withRenderingMode(.alwaysTemplate)
                microphoneButton.tintColor = .appDarkBlue
                microphoneButton.setImage(image, for: .normal)

            }
        }
     
        func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
            if available {
                microphoneButton.isEnabled = true
            } else {
                microphoneButton.isEnabled = false
            }
        }
}

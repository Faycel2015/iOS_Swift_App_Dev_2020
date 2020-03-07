//
//  ViewController.swift
//  Quiz Game
//
//  Created by Faycel on 2/16/20.
//  Copyright © 2020 Faycel Ayech. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var judgement: UILabel!
    @IBOutlet weak var ans1: UIButton!
    @IBOutlet weak var ans2: UIButton!
    @IBOutlet weak var ans3: UIButton!
    @IBOutlet weak var ans4: UIButton!
    
    var score = 0
    var timer:Timer?
    var seconds = 60
    var question = ""
    var CorAns = 0
    
    var audioPlayer:AVAudioPlayer?
    
    var quizData: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        playSound(soundFilename: "StartGame")
        loadJsonFile()
        updateQA()
        updateScoreLabel()
        updateTimerLabel()
    
    }
    
    func updateQA() {
        if quizData.count == 0 { print("No data loaded") ; return }
        let index = Int.random(in: 0 ..< quizData.count)
        
        let quizObject = quizData[index] as! Dictionary<String,Any>
        question = quizObject["question"] as! String
        questionTextView.text = question
        
        let correctAns: String = quizObject["correct_answer"] as! String
        let wrongAns: [String] = quizObject["incorrect_answers"] as! [String]
        
        let correctIndex: Int = Int.random(in: 0...3)
        
        switch correctIndex {
        case 0:
            CorAns = 0
            ans1.setTitle(correctAns, for: .normal)
            
            ans2.setTitle(wrongAns[0], for: .normal)
            ans3.setTitle(wrongAns[1], for: .normal)
            ans4.setTitle(wrongAns[2], for: .normal)
            
            case 1:
            CorAns = 1
            ans2.setTitle(correctAns, for: .normal)
            
            ans1.setTitle(wrongAns[0], for: .normal)
            ans3.setTitle(wrongAns[1], for: .normal)
            ans4.setTitle(wrongAns[2], for: .normal)
            
            case 2:
            CorAns = 2
            ans3.setTitle(correctAns, for: .normal)
            
            ans2.setTitle(wrongAns[0], for: .normal)
            ans1.setTitle(wrongAns[1], for: .normal)
            ans4.setTitle(wrongAns[2], for: .normal)
            
            case 3:
            CorAns = 3
            ans4.setTitle(correctAns, for: .normal)
            
            ans2.setTitle(wrongAns[0], for: .normal)
            ans3.setTitle(wrongAns[1], for: .normal)
            ans1.setTitle(wrongAns[2], for: .normal)
            
        default:
            print("Error")
        }
        
        judgement.text = "Select Any One"
        judgement.textColor = UIColor.white
    }
    
    private func loadJsonFile() {
        do {
            if let file = Bundle.main.url(forResource: "quiz", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    print("As Dictionary \(object)")
                } else if let object = json as? [Any] {
                    // json is an array
                    print("As Array \(object)")
                    quizData = object
                    
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateScoreLabel() {
        scoreLabel?.text = String(score)
    }
    
    func updateTimerLabel() {
        let min = (seconds / 60) % 60
        let sec = seconds % 60
        
        timeLabel?.text = String(format: "%02d", min) + ":" + String(format: "%02d", sec)
    
    if timer == nil {
    timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
    
    if self.seconds == 0 {
        self.finishGame()
  } else if self.seconds <= 60 {
    self.seconds -= 1
    self.updateTimerLabel()
       }
    }
 }
        
    }
    
    
    func correctAns() {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.judgement.alpha = 0
        }) { (complete) in
            self.judgement.text = "Correct Answer"
            self.judgement.textColor = UIColor.green
            
        
            UIView.animate(withDuration: 0.5, animations: {
            self.judgement.alpha = 1
          }, completion: { (complete) in
        
            self.playSound(soundFilename: "WonMsg")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.updateQA()
                self.updateScoreLabel()
                
            })
         })
       }
    
    }
    
    func wrongAns() {
        
        UIView.animate(withDuration: 0.5, animations: {
             self.judgement.alpha = 0
         }) { (complete) in
             self.judgement.text = "Wrong Answer"
             self.judgement.textColor = UIColor.red
            
            UIView.animate(withDuration: 0.5, animations: {
             self.judgement.alpha = 1
           }, completion: { (complete) in
            
            self.playSound(soundFilename: "WrongMsg")
         
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                 self.updateQA()
                self.updateScoreLabel()
             })
          })
        }
    }
    
    @IBAction func ans1Pressed(_ sender: Any) {
        
        playSound(soundFilename: "AnsPressed")
        
        if (CorAns == 0) {
            correctAns()
            score += 5
        } else {
            wrongAns()
            score -= 2
            
        }
        

    }
    
    @IBAction func ans2Pressed(_ sender: Any) {
        
        playSound(soundFilename: "AnsPressed")
        
        if (CorAns == 1) {
                 correctAns()
            score += 5
             } else {
                 wrongAns()
            score -= 2
             }
    }
    
    @IBAction func ans3Pressed(_ sender: Any) {
        
        playSound(soundFilename: "AnsPressed")
        
        if (CorAns == 2) {
                 correctAns()
            score += 5
             } else {
                 wrongAns()
             }
    }
    
    @IBAction func ans4Pressed(_ sender: Any) {
        
        playSound(soundFilename: "AnsPressed")
        
        if (CorAns == 3) {
                 correctAns()
            score += 5
             } else {
                 wrongAns()
            score -= 2
             }
    }
    
    
    func finishGame() {
        
        timer?.invalidate()
        timer = nil
        
        let alert = UIAlertController(title: "Time's Up!", message: "Your time is up! You got a score of \(score) points. Awesome!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK, start new game", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        playSound(soundFilename: "AlertMsg")
        
        score = 0
        seconds = 60
        
        updateScoreLabel()
        updateTimerLabel()
    }
    
    func playSound(soundFilename:String) {
        
        // Get the path to the sound file inside the bundle
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        
        guard bundlePath != nil else {
            print("Couldn't find sound file \(soundFilename) in the bundle")
            return

          }
           // Greate a URL object from this string path
           let url = URL(fileURLWithPath: bundlePath!)
           let soundURL = URL(fileURLWithPath: bundlePath!)
           
           do {
               // Create audio player object
               audioPlayer = try! AVAudioPlayer(contentsOf: soundURL)
               audioPlayer = try! AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
               
               // Play the sound
               audioPlayer?.prepareToPlay()
               audioPlayer?.play()
               audioPlayer?.setVolume(0.8, fadeDuration: 0.2)
    }
    
 }

}

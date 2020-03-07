//
//  SoundManager.swift
//  Quiz Game
//
//  Created by Faycel on 3/5/20.
//  Copyright © 2020 Faycel Ayech. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
var audioPlayer:AVAudioPlayer?

  enum SoundEffect {
    
    case AlertMsg
    case AnsPressed
    case StartGame
    case WonMsg
    case WrongMsg
    
 }

func playSound(_ effect:SoundEffect) {
     
     var soundFilename = ""
     
     // Determine which sound effect we want to play
     // And set the appropriate filename
     switch effect {
         
        case .AlertMsg:
            soundFilename = "AlertMsg"
            
        case .AnsPressed:
            soundFilename = "AnsPressed"
            
        case .StartGame:
            soundFilename = "StartGame"
            
        case .WonMsg:
            soundFilename = "WonMsg"
        
        case .WrongMsg:
        soundFilename = "WrongMsg"
            
        }
     
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
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer = try! AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
            
            // Play the sound
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            audioPlayer?.setVolume(0.5, fadeDuration: 0.1)
        }
        catch {
            // Couldn't create audio player object, log the error
            print("Couldn't create the audio player object for sound file \(soundFilename)")
        }
    }
}

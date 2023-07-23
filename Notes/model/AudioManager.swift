//
//  AudoManager.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-06-12.
//

import Foundation
import AVKit

class AudioManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isPlaying = false
    var session: AVAudioSession
    var recorder = AVAudioRecorder()
    var audioPlayer = AVAudioPlayer()
    var approved = false
    var fileUrl: URL?
    
    override init() {
        session = AVAudioSession.sharedInstance()
        super.init()
    }
    
    func requestPermissionAndSetUp() {
        do {
            
            try self.session.setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetooth])
            try self.session.setActive(true)
            
            self.session.requestRecordPermission {
                status in
                if !status {
                } else {
                    self.approved = true
                }
                
                
            }
        } catch {
        }
    }
    func startPlaying(url: URL) {
        if !approved {
            return
        }
        guard let correctUrl = getCorrectUrlFrom(url: url) else {
            return
        }
        
       
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: correctUrl)
            audioPlayer.delegate = self
            audioPlayer.volume = 1.0
            audioPlayer.play()
        } catch {
        }
    }
    
    func stopPlaying() {
        if !approved {
            return
        }
        
        audioPlayer.pause()
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if !approved {
            return
        }
        isPlaying = false
        
    }
    
    func startRecording(title: String) {
        do {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileName = url.appendingPathComponent("\(UUID())_\(title).m4a")
            
            fileUrl = fileName
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVLinearPCMBitDepthKey: 24,
                AVSampleRateKey: 48000,
                AVNumberOfChannelsKey: 2,
                AVEncoderBitRateKey: 128000,
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue]
            recorder = try AVAudioRecorder(url: fileName, settings: settings)
            recorder.record()
        } catch {
            return
        }
    }
    
    func stopRecording() {
        recorder.stop()
    }
    
    
    func deleteRecordingFromDirectory(url: URL, onComplete: ()-> Void) {
        guard let correctUrl = getCorrectUrlFrom(url: url) else {
            return
        }
        
        do {
            try FileManager.default.removeItem(at: correctUrl)
            onComplete()
        } catch {
          
        }
    }
    
    func getCorrectUrlFrom(url: URL)-> URL? {
        guard let audio = getAuidos().first(where: {$0.lastPathComponent == url.lastPathComponent}) else {
            return nil
        }
        
        return audio
    }
    
    func getAuidos()-> [URL] {
        do {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            let res = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .producesRelativePathURLs)
            return res
            
        } catch {
        }
        
        return []
    }
    
    func updateFileName(url: URL, newFileName: String)-> URL? {
      do {
          let newURL  = url.deletingLastPathComponent().appendingPathComponent(newFileName)
            
            try FileManager.default.moveItem(at: url, to: newURL)
          
          return newURL
        } catch {
            return nil
        }
    }
    
    func fileNameExtits(fileName: String)-> Bool {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let newURL  = url.appendingPathComponent(fileName)
   
        if let exstingUrl = getCorrectUrlFrom(url: newURL) {
            return true
        } else {
            return false
        }
    }
}

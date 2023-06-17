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
            
            try self.session.setCategory(.playAndRecord, options: .defaultToSpeaker)
            try self.session.setActive(true)
            
            self.session.requestRecordPermission {
                status in
                if !status {
                    print("permisiion denied")
                } else {
                    self.approved = true
                }
                
                
            }
        } catch {
            print(error.localizedDescription, "when")
        }
    }
    func startPlaying(url: URL) {
        if !approved {
            print("Need permisiion for mic")
            return
        }
       
        let fileName = url.lastPathComponent
        do {
            guard let audio = getAuidos().first(where: {$0.lastPathComponent == fileName}) else {
                print("No maches")
                return
            }
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.volume = 1.0
            audioPlayer.play()
        } catch {
            print("errrrr")
            print(error.localizedDescription, "play")
        }
    }
    
    func stopPlaying() {
        if !approved {
            print("Need permisiion for mic")
            return
        }
        
        audioPlayer.pause()
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if !approved {
            print("Need permisiion for mic")
            return
        }
        isPlaying = false
        print("called")
        
    }
    
    func startRecording(title: String) {
        do {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileName = url.appendingPathComponent("\(title).m4a")
            
//            let res = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .producesRelativePathURLs)
            
            
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
            print(error.localizedDescription, "when record")
        }
    }
    
    func stopRecording() {
        recorder.stop()
    }
    
    func getAuidos()-> [URL] {
        do {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            print(url)
            
            let res = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .producesRelativePathURLs)
            return res
            
        } catch {
            print(error.localizedDescription, "when get audios")
        }
        
        return []
    }
}

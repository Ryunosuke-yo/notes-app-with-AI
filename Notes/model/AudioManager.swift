//
//  AudioManager.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-25.
//

import Foundation
import AVFoundation

class AudioManager: NSObject, ObservableObject, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder?
    private var audioSession: AVAudioSession
    
    @Published var isRecording = false
    @Published var recordedURL: URL?
    
    override init() {
        audioSession = AVAudioSession.sharedInstance()
        super.init()
        
        setupAudioSession()
    }
    
    func setupAudioSession() {
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            try audioSession.setActive(true, options: [])
        } catch {
            print("Failed to setup audio session: \(error.localizedDescription)")
        }
    }
    
    func startRecording() {
        let fileName = "recording.wav"
        // get url to save
        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentPath.appendingPathComponent(fileName)
        
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            AVEncoderBitRateKey: 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            isRecording = true
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordedURL = recorder.url
        } else {
            print("Recording failed.")
        }
    }
}


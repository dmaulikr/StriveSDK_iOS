//
//  SessionHandler.swift
//  StriveCameraSwift
//
//  Created by Nightman on 7/24/17.
//  Copyright © 2017 Strive Technologies, Inc. All rights reserved.
//

import AVFoundation
import UIKit

class SessionHandler: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate {
    let layer = AVSampleBufferDisplayLayer()
    var selectedIndex = 0
    var captureSession : AVCaptureSession = AVCaptureSession()
    let captureSessionQueue = DispatchQueue(label: "capture_session_queue")
    var setupCamera = false
    
    // tutorial marker 2.a - add line that creates and initializes the StriveInstance property
    
    func openSession() {
        let deviceDiscoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [AVCaptureDeviceType.builtInDualCamera, AVCaptureDeviceType.builtInTelephotoCamera,AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.front)
        var device : AVCaptureDevice? = nil
        for deviceCandidate in (deviceDiscoverySession?.devices)! {
            if(deviceCandidate.position == AVCaptureDevicePosition.front){
                device = deviceCandidate
            }
        }
        
        var input : AVCaptureDeviceInput? = nil
        do{
            input = try AVCaptureDeviceInput(device: device)
        }catch{
            print("exception!");
            return
        }
        
        let videoDataOutput = AVCaptureVideoDataOutput();
        
        videoDataOutput.alwaysDiscardsLateVideoFrames=true
        
        // tutorial marker 2.b - add lines that configure the 32BGRA pixel format here
        
        
        videoDataOutput.setSampleBufferDelegate(self, queue: captureSessionQueue)
        captureSession.beginConfiguration()
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        if(captureSession.canAddInput(input)){
            captureSession.addInput(input);
        }
        if(captureSession.canAddOutput(videoDataOutput)){
            captureSession.addOutput(videoDataOutput);
            
            let cnx : AVCaptureConnection? = videoDataOutput.connections.first as? AVCaptureConnection
            cnx?.videoOrientation = AVCaptureVideoOrientation.portrait
            cnx?.isVideoMirrored = true
        }
        captureSession.commitConfiguration()
        captureSession.startRunning()
        setupCamera = true
    }

    func start() {
        if setupCamera {
            self.captureSession.startRunning()
        } else {
            self.openSession()
        }
    }

    func stop() {
        if setupCamera {
            self.captureSession.stopRunning()
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!,
                       didOutputSampleBuffer sampleBuffer: CMSampleBuffer!,
                       from connection: AVCaptureConnection!) {
        
        // tutorial marker 2.c - replace the next line with the Strive filtering code!
        self.layer.enqueue(sampleBuffer) // replace this line
    }
    
}

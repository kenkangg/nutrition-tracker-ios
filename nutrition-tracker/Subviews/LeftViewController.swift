//
//  LeftViewController.swift
//  calorie-tracker
//
//  Created by Kenny Kang on 10/16/17.
//  Copyright © 2017 Kenny Kang. All rights reserved.
//

import UIKit
import AVFoundation

class LeftViewController: UIViewController {
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var photoView: UIImageView!

    @IBOutlet weak var cameraView: UIView!
    
    let model = Food101()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer?.frame = cameraView.bounds
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        
        let backCamera = AVCaptureDevice.default(for: AVMediaType.video)!
        print("Here")
        var input: AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch {
        }
        captureSession?.addInput(input!)
        stillImageOutput = AVCapturePhotoOutput()
        if (captureSession?.canAddOutput(stillImageOutput!) != nil) {
            captureSession?.addOutput(stillImageOutput!)
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
            previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            cameraView.layer.addSublayer(previewLayer!)
            captureSession?.startRunning()
            
            
            self.view.addSubview(captureButton)
        
        
        }
        
        
    
    }
    
    @IBAction func takePicture(_ sender: Any) {
        print("pressed")
        let settings = AVCapturePhotoSettings()
//        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
//        let previewFormat = [
//            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
//            kCVPixelBufferWidthKey as String: 160,
//            kCVPixelBufferHeightKey as String: 160
//        ]
//        settings.previewPhotoFormat = previewFormat
        stillImageOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    
    

    
    
}




extension LeftViewController: AVCapturePhotoCaptureDelegate {
    
    public func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                        resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
        if let error = error { self.photoCaptureCompletionBlock?(nil, error) }
            
        else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
            let image = UIImage(data: data) {
                /* Start Prediction */
                UIGraphicsBeginImageContextWithOptions(CGSize(width: 299, height: 299), true, 2.0)
                //        Place actual image into that rectancle
                image.draw(in: CGRect(x: 0, y: 0, width: 299, height: 299))
                //        Return the result of drawing the uiimage into the rectangle
                let newImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                
                let pixelBuffer:CVPixelBuffer = ImageProcessor.pixelBuffer(forImage: newImage.cgImage!)!
                //            imageView.image = newImage
                guard let prediction = try? model.prediction(image: pixelBuffer) else {
                    return
                }
                print(prediction.classLabel)
                /* End Prediction */
                self.photoCaptureCompletionBlock?(image, nil)
            } else {
            self.photoCaptureCompletionBlock?(nil, Swift.Error.self as? Error)
            }
        
       
        
        
        
    }
}


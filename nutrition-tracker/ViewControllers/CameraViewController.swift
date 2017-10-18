//
//  CameraViewController.swift
//  nutrition-tracker
//
//  Created by Kenny Kang on 10/17/17.
//  Copyright © 2017 Kenny Kang. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
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
    
    func showPrediction(food: String) {
        let predictAlert = UIAlertController(title: food.capitalized, message: "Is this prediction correct?", preferredStyle: UIAlertControllerStyle.alert)
        
        predictAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            let parent = self.parent as! ViewController
            let foodController = parent.VFood
            
            var calories: Int?
            
            let callback = {
                let foodObj = foodController?.foodArray![0] as? Food
                calories = (foodObj?.calories!)!
                
                let statsController = parent.VStats
                statsController?.calorieCount! += calories!
                DispatchQueue.main.async{
                    statsController?.calorieLabel.text = String(describing: (statsController?.calorieCount!)!)
                }
            }
            
            foodController?.getData(foodChoice: food, completion: callback)
            
            
            
            
        
        }))
        
        predictAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        
        
        present(predictAlert, animated: true, completion: nil)
        
    }
    
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?

    
    
}




extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    public func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                            resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
        if let error = error { self.photoCaptureCompletionBlock?(nil, error) }
            
        else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
            let image = UIImage(data: data) {
            /* Start Prediction */
            let newImage = ImageProcessor.cropImage(image: image, width: 299, height: 299)
            let pixelBuffer:CVPixelBuffer = ImageProcessor.pixelBuffer(forImage: newImage.cgImage!)!
            //            imageView.image = newImage
            guard let prediction = try? model.prediction(image: pixelBuffer) else {
                return
            }
            /* End Prediction */
            let predict_string = prediction.classLabel.replacingOccurrences(of: "_", with: " ")
            
            /* Access FoodViewController, replace search bar text, and initiate food search */
            let parent = self.parent as! ViewController
            let foodController = parent.VFood
            foodController?.searchBar?.text = predict_string
            
            
            showPrediction(food: predict_string)

            
            self.photoCaptureCompletionBlock?(image, nil)
        } else {
            self.photoCaptureCompletionBlock?(nil, Swift.Error.self as? Error)
        }
        
    }
    

}



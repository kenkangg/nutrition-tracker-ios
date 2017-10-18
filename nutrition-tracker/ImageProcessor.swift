//
//  ImageProcessor.swift
//  CalorieTracker
//
//  Created by Kenny Kang on 10/16/17.
//  Copyright © 2017 Kenny Kang. All rights reserved.
//

import CoreVideo
import UIKit

struct ImageProcessor {
    static func pixelBuffer (forImage image:CGImage) -> CVPixelBuffer? {
        
        
        let frameSize = CGSize(width: 299, height: 299)
        
        var pixelBuffer:CVPixelBuffer? = nil
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(frameSize.width), Int(frameSize.height), kCVPixelFormatType_32BGRA , nil, &pixelBuffer)
        
        if status != kCVReturnSuccess {
            return nil
            
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags.init(rawValue: 0))
        let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        let context = CGContext(data: data, width: Int(frameSize.width), height: Int(frameSize.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        
        context?.draw(image, in: CGRect(x: 0, y: 0, width: 299, height: 299))
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
        
    }
    
    static func cropImage(image: UIImage, width: Int, height: Int) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), true, 2.0)
        //        Place actual image into that rectancle
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        //        Return the result of drawing the uiimage into the rectangle
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}

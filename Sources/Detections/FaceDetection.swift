//
//  FaceDetection.swift
//  facedetectionexample
//
//  Created by Saeed Rahmatolahi on 15/11/2564 BE.
//

import Foundation
import UIKit

public class FaceDetection {
    public static func imageProcessing(_ inputImage : UIImage,_ completion : @escaping (Result<String, faceErrors>) -> Void) {
        guard let cgImage = inputImage.cgImage else {
            completion(.failure(.noCGImage))
            return
        }
        let ciImage = CIImage(cgImage: cgImage)
        
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)!
        let faces = faceDetector.features(in: ciImage)
        
        switch faces.count {
        case 0:
            completion(.failure(.noFace))
        case 1:
            completion(.success("Success"))
        default:
            completion(.failure(.moreThanOneFace))
        }
    }
}

public enum faceErrors: Error {
    case noFace
    case moreThanOneFace
    case noCGImage
    
    public func errorMessage() -> String {
        switch self {
        case .noFace :
            return "No face detected"
        case .moreThanOneFace:
            return "More than one face detected"
        case .noCGImage:
            return "Some thing went wrong please try again"
        }
    }
}

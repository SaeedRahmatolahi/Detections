//
//  VisionWrapper.swift
//  facedetectionexample
//
//  Created by Saeed Rahmatolahi
//

import UIKit
import Vision

public class VisionWrapper {
    public static func recognizeText(_ image : UIImage?,recognitionLevel : VNRequestTextRecognitionLevel = .accurate ,autoCorrection : Bool = false, onSuccess : @escaping([String]) -> Void, onError : @escaping(Error?) -> Void) {
        guard let cgImage = image?.cgImage else {return}
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {return}
            let detectedData = observations.compactMap({$0.topCandidates(1).compactMap({$0.string})}).compactMap({$0.first})
            onSuccess(detectedData)
        }
        request.recognitionLevel = recognitionLevel
        request.usesLanguageCorrection = autoCorrection
        do {
            try handler.perform([request])
        } catch {
            onError(error)
        }
    }
}

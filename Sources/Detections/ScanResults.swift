//
//  ScanResults.swift
//  facedetectionexample
//
//  Created by Saeed Rahmatolahi
//

import Foundation
import UIKit

public struct ScanResults {
    public init(detectedTexts: [String]? = nil, scannedImage: UIImage? = nil, error: Error? = nil) {
        self.detectedTexts = detectedTexts
        self.scannedImage = scannedImage
        self.error = error
    }
    
    public var detectedTexts : [String]?
    public var scannedImage : UIImage?
    public var error : Error?
}

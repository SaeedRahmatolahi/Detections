//
//  Protocols.swift
//  facedetectionexample
//
//  Created by Saeed Rahmatolahi
//

import Foundation
import UIKit

protocol detectionViewProtocol : NSObjectProtocol {
    func detected(_ result : ScanResults)
    func scanFailed()
}

extension detectionViewProtocol {
    func scanFailed(){}
}

public protocol detectionProtocol : NSObjectProtocol {
    func scanResults(_ result : ScanResults)
    func scanFailed()
}

public extension detectionProtocol {
    func scanFailed() {}
}

protocol faceDetectionViewProtocol : NSObjectProtocol {
    func detected(_ error : faceErrors?,_ image : UIImage?)
    func scanFailed()
}

extension faceDetectionViewProtocol {
    func scanFailed() {}
}

public protocol faceDetectionProtocol : NSObjectProtocol {
    func faceDetected(_ error : faceErrors?,_ image : UIImage?)
    func scanFailed()
}

public extension faceDetectionProtocol {
    func scanFailed() {}
}

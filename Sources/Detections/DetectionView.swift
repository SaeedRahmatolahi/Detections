//
//  DetectionView.swift
//  facedetectionexample
//
//  Created by Saeed Rahmatolahi
//

import UIKit
import AVFoundation
import Photos

class DetectionView: UIView {

    var captureSession: AVCaptureSession!
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
    var stillImageOutput: AVCapturePhotoOutput!
    var stopAfterScan = true
    public weak var detectionViewDelegate : detectionViewProtocol?
    var fastRecognition : Bool = .no
    var autoCorrection : Bool = .no
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.initCamera()
        self.setMaskLayer(width: 310, height: 200)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.initCamera()
    }
    
    
    /// stop or resume scanner
    /// - Parameter isStop: stop scanner or resume scanner (true : stop scanner)
    func scanStopResume(_ isStop : Bool) {
        isStop ? captureSession.stopRunning():captureSession.startRunning()
    }
    
    /// capture image
    func getImage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            guard self.captureSession.isRunning else {
                self.captureSession.startRunning()
                self.getImage()
                return
            }
            self.stillImageOutput.capturePhoto(with: photoSettings, delegate: self)
        })
        
    }
    
    
    /// initialize the camera
    fileprivate func initCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd4K3840x2160

        stillImageOutput = AVCapturePhotoOutput()
        guard let videoCaptureDevice = AVCaptureDevice.default(for:.video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
            
        } else {
            failed()
            return
        }
        
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        self.previewLayer.connection?.videoOrientation = .portrait
        self.layer.addSublayer(previewLayer)
        
        DispatchQueue.main.async {
            self.captureSession.startRunning()
        }
        
        if (captureSession?.isRunning == .no) {
            DispatchQueue.main.async {
                self.captureSession.startRunning()
            }
        }
        self.didLunchScreen()
    }
    
    
    /// enable or disable the auto focus
    /// - Parameter isAutoFocus: isAutoFocus makes it enable
    func autoFocus(_ isAutoFocus : Bool = .yes) {
        guard let videoCaptureDevice = AVCaptureDevice.default(for:.video) else { return }
        if isAutoFocus {
            DispatchQueue.main.async {
                  try? videoCaptureDevice.lockForConfiguration()
                    videoCaptureDevice.autoFocusRangeRestriction = .near
            }
        } else {
            videoCaptureDevice.unlockForConfiguration()
        }
    }
    
    /// failed scan
    fileprivate func failed() {
        captureSession = nil
        self.detectionViewDelegate?.scanFailed()
    }
    
    fileprivate func didLunchScreen() {
        if self.previewLayer.connection != nil {
            self.previewLayer.connection?.videoOrientation = .portrait
        }
    }
    
    deinit {
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
        NotificationCenter.default.removeObserver(self)
    }
}

extension DetectionView: AVCapturePhotoCaptureDelegate {
    
    /// preparing the photo and using Vision to detect the texts
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {return}
                
        guard let imageData = photo.fileDataRepresentation() ,let dataProvider = CGDataProvider(data: imageData as CFData) else {
            return
        }
        
        let cgImageRef = CGImage(jpegDataProviderSource: dataProvider,
                                 decode: nil, shouldInterpolate: true,
                                 intent: .defaultIntent)
        let image = UIImage(cgImage: cgImageRef!)
        let outputImage = image.autoEnhance()
        let scaleX : CGFloat = (outputImage.size.height * 200) / .screenHeight
        let scaleY : CGFloat = (outputImage.size.width * 310) / .screenWidth
        let x : CGFloat = (outputImage.size.width - scaleX) / 2
        let y : CGFloat = (outputImage.size.height - scaleY)/2
        let croppedImage = outputImage.crop(CGRect(x: y, y: x, width: (outputImage.size.height * 200) / .screenHeight, height: (outputImage.size.width * 310) / .screenWidth))
        VisionWrapper.recognizeText(outputImage,recognitionLevel:fastRecognition ? .fast:.accurate,autoCorrection: autoCorrection) { [weak self] resultTexts in
            self?.detectionViewDelegate?.detected(ScanResults(detectedTexts: resultTexts, scannedImage: croppedImage, error: nil))
        } onError: { [weak self] error in
            self?.detectionViewDelegate?.detected(ScanResults(detectedTexts: nil, scannedImage: croppedImage, error: error))
        }
    }
    
}



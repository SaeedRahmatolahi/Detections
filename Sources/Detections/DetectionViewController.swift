//
//  DetectionViewController.swift
//  facedetectionexample
//
//  Created by Saeed Rahmatolahi
//

import UIKit

open class DetectionViewController: UIViewController, detectionViewProtocol {
    
    /// detected function will get called when the photo taken and there is results or error
    /// - Parameter result: ScanResults contains detectedTexts , scannedImage and error which can be handle to show error or results
    func detected(_ result : ScanResults) {
        self.detectionDelegate?.scanResults(result)
    }
    
    /// scan failed function will called
    func scanFailed() {
        self.detectionDelegate?.scanFailed()
    }

    private var getImage = UIButton(frame: CGRect(x: (.screenWidth - 50)/2, y: .screenHeight - .safeAreas - 150 , width: 50, height: 50))
    private var detectionView = DetectionView(frame: CGRect(x: 0, y: 0, width: .screenWidth, height: .screenHeight))
    weak public var detectionDelegate : detectionProtocol?
    public var fastRecognition : Bool = .no
    public var autoCorrection : Bool = .no
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.setSubViews()
        self.setupButton()
    }
    
    /// passing delegate to detectionView
    private func setDelegates() {
        self.detectionView.detectionViewDelegate = self
        self.detectionView.autoCorrection = self.autoCorrection
        self.detectionView.fastRecognition = self.fastRecognition
    }
    
    
    /// adding button and detection view to the view controller's view
    private func setSubViews() {
        self.view.addSubview(detectionView)
        self.view.addSubview(getImage)
        
    }
    
    /// setting button's attributes
    private func setupButton() {
        self.getImage.setBackgroundColor(.white)
        self.getImage.setButtonTitle("")
        self.getImage.circle()
        self.getImage.addTarget(self, action: #selector(gettingImage), for: .touchUpInside)
    }
    
    
    /// enabling the autoFocus on ViewDidAppear
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.detectionView.autoFocus()
    }
    
    
    /// take photo when getImage button tapped
    @objc private func gettingImage() {
        self.detectionView.getImage()
    }
}


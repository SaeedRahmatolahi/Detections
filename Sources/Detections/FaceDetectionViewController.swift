//
//  FaceDetectionViewController.swift
//  facedetectionexample
//
//  Created by Saeed Rahmatolahi
//

import UIKit

open class FaceDetectionViewController: UIViewController, faceDetectionViewProtocol {
    /// detected function will pass error if the error was nil it means the face detected successfully
    /// - Parameter error: if error was nil it means the image passed otherwise the image may have problems to pass
    func detected(_ error : faceErrors?,_ image : UIImage?) {
        self.faceDetectionDelegate?.faceDetected(error,image)
    }
    
    /// scan failed function will called
    func scanFailed() {
        self.faceDetectionDelegate?.scanFailed()
    }
    
    private var getImage = UIButton(frame: CGRect(x: (.screenWidth - 50)/2, y: .screenHeight - .safeAreas - 150 , width: 50, height: 50))
    private var faceDetectionView = FaceDetectionView(frame: CGRect(x: 0, y: 0, width: .screenWidth, height: .screenHeight))
    public weak var faceDetectionDelegate : faceDetectionProtocol?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.setSubViews()
        self.setupButton()
    }
    
    /// passing delegate to faceDetectionView
    private func setDelegates() {
        self.faceDetectionView.faceDetectionViewDelegate = self
    }
    
    
    /// adding button and detection view to the view controller's view
    private func setSubViews() {
        self.view.addSubview(faceDetectionView)
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
        self.faceDetectionView.autoFocus()
    }
    
    
    /// take photo when getImage button tapped
    @objc private func gettingImage() {
        self.faceDetectionView.getImage()
    }
}


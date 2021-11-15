//
//  UIExtensions.swift
//  facedetectionexample
//
//  Created by Saeed Rahmatolahi
//

import Foundation
import UIKit

extension UIImage {
    func autoEnhance() -> UIImage {
        
        guard var inputImage = CIImage(image: self) else {
            return self
        }
        
        let adjustments = inputImage.autoAdjustmentFilters()
        
        for filter in adjustments {
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            
            if let outputImage = filter.outputImage {
                inputImage = outputImage
            }
        }
        
        let context = CIContext.init(options: nil)
        
        guard let cgImage = context.createCGImage(inputImage, from: inputImage.extent) else {
            return self
        }
        
        let finalImage = UIImage(cgImage: cgImage, scale: self.scale, orientation: .right)
        
        return finalImage
    }
    
    func crop(_ rect: CGRect) -> UIImage {
        guard let imageRef = cgImage, let cropped = imageRef.cropping(to: rect) else {
            return self
        }
        return UIImage(cgImage: cropped, scale: self.scale, orientation: self.imageOrientation)
    }
}

extension UIView {
    var safeAreas: CGFloat {
        if #available(iOS 11.0, *) {
            guard let topNotch = UIApplication.shared.delegate?.window??.safeAreaInsets.top else {return 0}
            guard let bottomNotch = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom else {return 0}
            return topNotch > 20 ? topNotch + bottomNotch:0
        }
        return 0
    }
    
    /// adding mask to the camera view
    func setMaskLayer(width : CGFloat,height : CGFloat) {
        let cardLayer = CAShapeLayer()
        cardLayer.frame = .screenSize
        self.layer.insertSublayer(cardLayer, above: self.layer)
        
        let cardWidth = width as CGFloat
        let cardHeight = height as CGFloat
        let cardXlocation = (.screenWidth - cardWidth) / 2
        let cardYlocation = (.screenHeight / 2) - (cardHeight / 2) - (.screenHeight * 0.05)
        let path = UIBezierPath(roundedRect: CGRect(
                                    x: cardXlocation, y: cardYlocation, width: cardWidth, height: cardHeight),
                                cornerRadius: 10.0)
        cardLayer.path = path.cgPath
        cardLayer.strokeColor = UIColor.white.cgColor
        cardLayer.lineWidth = 8.0
        cardLayer.backgroundColor = UIColor.black.withAlphaComponent(0.7).cgColor
        
        let mask = CALayer()
        mask.frame = cardLayer.bounds
        cardLayer.mask = mask
        
        let r = UIGraphicsImageRenderer(size: mask.bounds.size)
        let im = r.image { ctx in
            UIColor.black.setFill()
            ctx.fill(mask.bounds)
            path.addClip()
            ctx.cgContext.clear(mask.bounds)
        }
        mask.contents = im.cgImage

    }
}

extension UIButton {
    func circle() {
        self.layer.cornerRadius = self.frame.height/2.0;
    }
    
    func setButtonTitle(_ title : String) {
        self.setTitle(title, for: .normal)
    }
    
    func setBackgroundColor(_ color : UIColor) {
        self.backgroundColor = color
    }
}

extension CGFloat {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static var safeAreas: CGFloat {
        if #available(iOS 11.0, *) {
            guard let topNotch = UIApplication.shared.delegate?.window??.safeAreaInsets.top else {return 0}
            guard let bottomNotch = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom else {return 0}
            return topNotch > 20 ? topNotch + bottomNotch:0
        }
        return 0
    }
}

extension CGRect {
    static let screenSize = UIScreen.main.bounds
}

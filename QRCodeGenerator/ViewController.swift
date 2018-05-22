//
//  ViewController.swift
//  QRCodeGenerator
//
//  Created by Phoenix Wu on H30/05/22.
//  Copyright © 平成30年 Phoenix Wu. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {
    
    @IBOutlet weak var txtField: UITextField!
    
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var qrCodeImgView: UIImageView!
    
    @IBOutlet weak var scaleSlider: UISlider!
    
    private func resetUI() {
        self.scaleSlider.isHidden = true
        self.scaleSlider.value = 1.0
        self.actionButton.setTitle("Generate", for: .normal)
        self.txtField.text = ""
        self.txtField.isEnabled = true
        self.qrCodeImgView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        self.qrCodeImgView.image = nil
    }
    
    var qrCodeCIImage: CIImage! {
        didSet {
            if qrCodeCIImage != nil {
                DispatchQueue.main.async { [unowned self] in
                    self.qrCodeImgView.image = self.getFitImageViewSizeQRCodeImg(srcImg: self.qrCodeCIImage)
                    self.actionButton.setTitle("Clear", for: .normal)
                    self.scaleSlider.isHidden = false
                    self.txtField.isEnabled = false
                }
            } else {
                DispatchQueue.main.async { [unowned self] in
                    self.resetUI()
                }
            }
        }
    }
    
    @IBAction func performButtonAction(_ sender: UIButton) {
        if qrCodeCIImage == nil {
            if let message = txtField.text, !message.isEmpty {
                // get data from string
                let data = message.data(using: .isoLatin1, allowLossyConversion: false)
                
                // create filter with specific name: CIQRCodeGenerator
                let filter = CIFilter(name: "CIQRCodeGenerator")
                
                filter?.setValue(data!, forKey: "inputMessage")
                filter?.setValue("Q", forKey: "inputCorrectionLevel")
                
                qrCodeCIImage = filter?.outputImage
                
                txtField.resignFirstResponder()
            }
        } else {
            qrCodeCIImage = nil
        }
    }
    
    @IBAction func scaleQRCodeImg(_ sender: UISlider) {
        qrCodeImgView.transform = CGAffineTransform(scaleX: CGFloat(sender.value), y: CGFloat(sender.value))
    }
    
    func getFitImageViewSizeQRCodeImg(srcImg ciImg: CIImage) -> UIImage {
        let scaleX = qrCodeImgView.frame.size.width / ciImg.extent.size.width
        let scaleY = qrCodeImgView.frame.size.height / ciImg.extent.size.height
        
        let transformedImage = ciImg.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        return UIImage(ciImage: transformedImage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scaleSlider.isHidden = qrCodeCIImage == nil
    }

}


//
//  FilterService.swift
//  CameraFilter
//
//  Created by MAHIMA on 15/07/20.
//  Copyright © 2020 MAHIMA. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

class FilterService {
    private var context: CIContext?
    
    init () {
        self.context = CIContext()
    }
    
    func applyFilter(to inputImage: UIImage, completion: @escaping ((UIImage) -> ())) {
        guard let filter = CIFilter(name: "CICMYKHalftone") else {return}
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        if let sourceImage = CIImage(image: inputImage) {
            filter.setValue(sourceImage, forKey: kCIInputImageKey)
            if let cgImage = self.context?.createCGImage(filter.outputImage!, from: filter.outputImage!.extent) {
                let processedImage = UIImage(cgImage: cgImage, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                completion(processedImage)
            }
        }
    }
}


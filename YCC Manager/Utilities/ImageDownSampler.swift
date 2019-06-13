//
//  ImageDownSampler.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 13/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa
import ImageIO

class ImageDownSampler {
    static func downsample(imageAt imageURL: URL, to maxDimension: CGFloat) -> NSImage? {
        let imageSourceOptions = [
            kCGImageSourceShouldCache: false // Don't decode immediately
            ] as CFDictionary
        let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions)!
        
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true, // When thumbnail is created, the image is decoded
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimension
            ] as CFDictionary
        
        // TODO: Force unwrapping leading to crash when the image is invalid
        if let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) {
            return NSImage(cgImage: cgImage, size: .zero)
        }
        return nil
    }
}


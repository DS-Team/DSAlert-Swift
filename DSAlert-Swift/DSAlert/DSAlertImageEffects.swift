//
//  DSAlertImageEffects.swift
//  DSAlert-Swift
//
//  Created by zeroLu on 16/9/1.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

import Foundation
import UIKit
import Accelerate

extension UIImage {
    func DSAlert_ApplyLightEffect() -> UIImage! {
        let tintColor = UIColor(white:0.3,alpha:0.4)
        return self.DSAlert_ApplyBlurWithRadius(blurRadius: 1.3, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    
    func DSAlert_ApplyExtraLightEffect() -> UIImage! {
        let tintColor = UIColor(white:0.97,alpha:0.82)
        return self.DSAlert_ApplyBlurWithRadius(blurRadius: 2, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    
    func DSAlert_ApplyDarkEffect() -> UIImage! {
        let tintColor = UIColor(white:0.11,alpha:0.73)
        return self.DSAlert_ApplyBlurWithRadius(blurRadius: 20, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    
    func DSAlert_ApplyTintEffectWithColor(tintColor : UIColor) -> UIImage! {
        let EffectColorAlpha : CGFloat = 0.45
        var effectColor : UIColor = tintColor
        
        let componentCount = CGColorGetNumberOfComponents(tintColor.CGColor)
        
        if (componentCount == 2) {
            var b : CGFloat = 0.0
            if ( tintColor.getWhite(&b, alpha: nil) ) {
                effectColor = UIColor(white:b,alpha:EffectColorAlpha)
            }
        }
        else {
            var r : CGFloat = 0.0
            var g : CGFloat = 0.0
            var b : CGFloat = 0.0
            
            if ( tintColor.getRed(&r, green: &g, blue: &b, alpha: nil) ) {
                
                effectColor = UIColor(red: r, green: g, blue: b, alpha: EffectColorAlpha)
                
            }
        }
        return self.DSAlert_ApplyBlurWithRadius(blurRadius: 10, tintColor: effectColor, saturationDeltaFactor: -1.0, maskImage: nil)
    }
    
    func DSAlert_ApplyBlurWithRadius(blurRadius blurRadius : Float, tintColor : UIColor?, saturationDeltaFactor : Double, maskImage : UIImage?) -> UIImage! {
        // Check pre-conditions.
        if (self.size.width < 1 || self.size.height < 1)
        {
            print("*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self)
            return nil
        }
        if ( self.CGImage == nil )
        {
            print("*** error: image must be backed by a CGImage: %@", self)
            return nil
        }
        if ( maskImage != nil && (maskImage!.CGImage == nil) )
        {
            print("*** error: maskImage must be backed by a CGImage: %@", maskImage)
            return nil
        }
        
        let imageRect = CGRect(origin: CGPointZero, size: self.size)
        var effectImage : UIImage = self
        
        let hasBlur : Bool = blurRadius > FLT_EPSILON
        
        let hasSaturationChange : Bool = fabs(Float(saturationDeltaFactor) - 1.0) > FLT_EPSILON
        
        let screenScale = UIScreen.mainScreen().scale
        
        
        if ( hasBlur || hasSaturationChange ) {
            
            UIGraphicsBeginImageContextWithOptions(self.size, false, screenScale)
            let effectInContext : CGContextRef = UIGraphicsGetCurrentContext()!
            CGContextScaleCTM(effectInContext, 1.0, -1.0)
            CGContextTranslateCTM(effectInContext, 0, -self.size.height)
            CGContextDrawImage(effectInContext, imageRect, self.CGImage)
            
            var effectInBuffer = vImage_Buffer()
            effectInBuffer.data     = CGBitmapContextGetData(effectInContext)
            effectInBuffer.width    = vImagePixelCount(CGBitmapContextGetWidth(effectInContext))
            effectInBuffer.height   = vImagePixelCount(CGBitmapContextGetHeight(effectInContext))
            effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext)
            
            UIGraphicsBeginImageContextWithOptions(self.size, false, screenScale)
            let effectOutContext : CGContextRef = UIGraphicsGetCurrentContext()!
            
            var effectOutBuffer = vImage_Buffer()
            effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext)
            effectOutBuffer.width    = vImagePixelCount(CGBitmapContextGetWidth(effectOutContext))
            effectOutBuffer.height   = vImagePixelCount(CGBitmapContextGetHeight(effectOutContext))
            effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext)
            
            if ( hasBlur ) {
                // A description of how to compute the box kernel width from the Gaussian
                // radius (aka standard deviation) appears in the SVG spec:
                // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
                //
                // For larger values of 's' (s >= 2.0), an approximation can be used: Three
                // successive box-blurs build a piece-wise quadratic convolution kernel, which
                // approximates the Gaussian kernel to within roughly 3%.
                //
                // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
                //
                // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
                //
                let inputRadius : Double = Double(blurRadius) * Double(screenScale)
                
                var radius = floor(inputRadius * 3.0 * sqrt(2 * M_PI) / 4 + 0.5)
                
                if (radius % 2 != 1) {
                    radius += 1 // force radius to be odd so that the three box-blur methodology works.
                }
                
                var unsafePointer : UInt8 = 0
                
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, UInt32(radius), UInt32(radius), &unsafePointer, UInt32(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, UInt32(radius), UInt32(radius), &unsafePointer, UInt32(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, UInt32(radius), UInt32(radius), &unsafePointer, UInt32(kvImageEdgeExtend))
            }
            
            var effectImageBuffersAreSwapped : Bool = false
            
            if ( hasSaturationChange ) {
                let s : Double = saturationDeltaFactor
                let floatingPointSaturationMatrix : [Double] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,  1,
                ]
                
                let divisor : Int32 = 256
                let matrixSize : Int = sizeofValue(floatingPointSaturationMatrix) / sizeofValue(floatingPointSaturationMatrix[0])
                
                var saturationMatrix = [Int16]()
                
                for _ in 0...matrixSize {
                    saturationMatrix.append(0)
                }
                
                for i in 0...matrixSize {
                    saturationMatrix[i] = Int16(roundf(Float(floatingPointSaturationMatrix[i]) * Float(divisor)))
                }
                
                if (hasBlur) {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, nil, nil, UInt32(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                }
                else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, nil, nil, UInt32(kvImageNoFlags))
                }
            }
            if ( !effectImageBuffersAreSwapped ) {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
            
            if ( effectImageBuffersAreSwapped ) {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
        }
        
        // 开启上下文 用于输出图像
        UIGraphicsBeginImageContextWithOptions(self.size, false, screenScale)
        let outputContext : CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextScaleCTM(outputContext, 1.0, -1.0)
        CGContextTranslateCTM(outputContext, 0, -self.size.height)
        
        // 开始画底图
        CGContextDrawImage(outputContext, imageRect, self.CGImage)
        
        // 开始画模糊效果
        if (hasBlur) {
            CGContextSaveGState(outputContext)
            if ( (maskImage) != nil) {
                CGContextClipToMask(outputContext, imageRect, maskImage!.CGImage)
            }
            CGContextDrawImage(outputContext, imageRect, effectImage.CGImage)
            CGContextRestoreGState(outputContext)
        }
        
        // 添加颜色渲染
        if ( tintColor != nil ) {
            CGContextSaveGState(outputContext)
            CGContextSetFillColorWithColor(outputContext, tintColor!.CGColor)
            CGContextFillRect(outputContext, imageRect)
            CGContextRestoreGState(outputContext)
        }
        
        // 输出成品,并关闭上下文
        let outputImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage
    }
    
    //MARK: - 纯颜色转图片
    static func DSAlert_ImageWithColor(color : UIColor) -> UIImage! {
        return self.DSAlert_ImageWithColor(color, size: CGSize(width: 1.0, height: 1.0))
    }
    
    static func DSAlert_ImageWithColor(color : UIColor, size : CGSize) -> UIImage! {
        let rect : CGRect          = CGRect(origin: CGPointZero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context : CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, color.CGColor)
        
        CGContextFillRect(context, rect)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    static func screenShotImage() -> UIImage! {
        
        let window : UIWindow = UIApplication.sharedApplication().windows.first!
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(window.frame), CGRectGetHeight(window.frame)), true, 1.0);
        //
        //    /*! 设置截屏大小 */
        
        window.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let viewImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return viewImage
    }
}
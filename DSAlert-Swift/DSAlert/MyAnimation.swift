//
//  MyAnimation.swift
//  DSAlert-Swift
//
//  Created by zeroLu on 16/9/1.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    /*!
     *  晃动动画
     *
     *  @param duration 一次动画用时
     *  @param radius   晃动角度0-180
     *  @param repeatCount   重复次数
     *  @param finish   动画完成
     */
    func shakeAnimationWithDuration(duration duration:NSTimeInterval, radius : Double, repeatCount : Float, finish : (Void -> Void)?) {
        let keyAnimation = CAKeyframeAnimation()
        keyAnimation.duration = duration
        keyAnimation.keyPath = "transform.rotation.z"
        keyAnimation.values = [NSNumber.init(double: (0) / 180.0 * M_PI),
                               NSNumber.init(double: (-radius) / 180.0 * M_PI),
                               NSNumber.init(double: (radius) / 180.0 * M_PI),
                               NSNumber.init(double: (-radius) / 180.0 * M_PI),
                               NSNumber.init(double: (0) / 180.0 * M_PI)]
        keyAnimation.repeatCount = repeatCount
        self .addAnimation(keyAnimation, forKey: nil)
        
        if (finish != nil) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(duration * Double(repeatCount) * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                finish!()
            })
        }
    }
    
    /*!
     *  根据路径执行动画
     *
     *  @param duration 一次动画用时
     *  @param path     路径CGPathRef
     *  @param repeat   重复次数
     *  @param finish   动画完成
     */
    func pathAnimationWithDuration(duration duration:NSTimeInterval, path : CGPathRef, repeatCount : Float, finish : (Void -> Void)?) {
        let keyAnimation = CAKeyframeAnimation()
        keyAnimation.duration = duration
        keyAnimation.keyPath = "position"
        keyAnimation.repeatCount = repeatCount
        keyAnimation.fillMode = kCAFillModeForwards
        self .addAnimation(keyAnimation, forKey: nil)
        
        if (finish != nil) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(duration * (Double(repeatCount) - 0.1) * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                finish!()
            })
        }
    }
    
    /*! 这两个动画只适合本项目 */
    /*! 天上掉下 */
    func fallAnimationWithDuration(duration duration:NSTimeInterval, finish : (Void -> Void)?) {
        let frame = UIScreen.mainScreen().bounds
        
        let center = CGPoint(x: CGRectGetWidth(frame) * 0.5, y: CGRectGetHeight(frame) * 0.5)
        
        let point = CGPoint(x: CGRectGetWidth(frame)*0.5, y: -(CGRectGetHeight(self.frame)))
        
        let path = UIBezierPath()
        
        path .moveToPoint(point)
        
        path.addLineToPoint(center)
        
        self.pathAnimationWithDuration(duration: duration, path: path.CGPath, repeatCount: 1.0) { () in
            if (finish != nil)
            {
                finish!()
            }
        }
    }
    
    /*! 上升 */
    func floatAnimationWithDuration(duration duration:NSTimeInterval, finish : (Void -> Void)?) {
        let frame = UIScreen.mainScreen().bounds
        
        let center = CGPoint(x: CGRectGetWidth(frame) * 0.5, y: CGRectGetHeight(frame) * 0.5)
        
        let point = CGPoint(x: CGRectGetWidth(frame)*0.5, y: -(CGRectGetHeight(self.frame)))
        
        let path = UIBezierPath()
        
        path .moveToPoint(center)
        
        path.addLineToPoint(point)
        
        self.pathAnimationWithDuration(duration: duration, path: path.CGPath, repeatCount: 1.0) { () in
            if (finish != nil)
            {
                finish!()
            }
        }
    }
    
}

extension UIView {
    /**
     缩放显示动画
     
     - parameter finish: 动画完成
     */
    func scaleAnimationShowFinishAnimation(finish : (Void -> Void)?) {
        transform = CGAffineTransformMakeScale(0.001, 0.001)
        UIView.animateWithDuration(0.35, animations: { 
            self.transform = CGAffineTransformMakeScale(1.18, 1.18)
            }) { (finished) in
                UIView.animateWithDuration(0.25, animations: { 
                    self.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    }, completion: { (finifhed) in
                        if finished {
                            finish!()
                        }
                })
        }
    }
    /**
     缩放隐藏动画
     
     - parameter finish:   动画完成
     */
    func scaleAnimationDismissFinishAnimation(finish : (Void -> Void)?) {
        UIView.animateWithDuration(0.15, animations: {
            self.transform = CGAffineTransformMakeScale(1.18, 1.18)
        }) { (finished) in
            UIView.animateWithDuration(0.25, animations: {
                self.transform = CGAffineTransformMakeScale(0.001, 0.001)
                }, completion: { (finifhed) in
                    if finished {
                        finish!()
                    }
            })
        }
    }
}
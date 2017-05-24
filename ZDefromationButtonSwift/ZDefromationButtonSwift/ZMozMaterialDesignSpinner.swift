//
//  ZMozMaterialDesignSpinner.swift
//  ZDefromationButtonSwift
//
//  Created by shmily on 2017/5/24.
//  Copyright © 2017年 freeTime.com. All rights reserved.
//

import Foundation
import UIKit
 class ZMozMaterialDesignSpinner: UIView {
    func zCGRECT (x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat) -> (CGRect){
        return CGRect(x:x ,y:y, width:width, height:height)
    }
    
    let kAnimationStrokeKey:String! = "animationStrokeKey"
    let kAnimationRotationKey:String! = "animationRotationKey"
    var _progressLayer:CAShapeLayer!
    var progressLayer:CAShapeLayer{
        set{_progressLayer = newValue}
        get{
            if _progressLayer == nil {
                _progressLayer = CAShapeLayer.init()
                _progressLayer.strokeColor = self.tintColor.cgColor
                _progressLayer.fillColor = nil
                _progressLayer.lineWidth = 2
            }
            
            return _progressLayer}
    }
    
    var isAnimating:Bool = false
    var _hidesWhenStopped:Bool = true
    let timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
    var lineWidth:CGFloat{
        set{ self.progressLayer.lineWidth = newValue
            updatePath()
        }
        get{ return self.progressLayer.lineWidth }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initiallize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initiallize()
//        fatalError("init(coder:) has not been implemented")
    }
    func initiallize(){
        self.layer.addSublayer(self.progressLayer)
        self.progressLayer.frame = zCGRECT(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        
         updatePath()
        NotificationCenter.default.addObserver(self, selector: #selector(ZMozMaterialDesignSpinner.resetAnimations), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    func updatePath()  {
        let aradius = min(self.bounds.width/2, self.bounds.height/2) - self.progressLayer.lineWidth/2
        let astartAngle = CGFloat(0)
        let aendAngle:CGFloat = (CGFloat(2 * M_PI))
        let path:UIBezierPath = UIBezierPath(arcCenter:center,radius:aradius,startAngle:astartAngle,endAngle:aendAngle,clockwise:true)
        self.progressLayer.path = path.cgPath
        self.progressLayer.strokeStart = 0.0
        self.progressLayer.strokeEnd = 0.0
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    func resetAnimations(){
        if self.isAnimating {
            stopAnimating()
            startAnimating()
        }
    }
    func setAnimating(_ animate:Bool) {
        animate ? startAnimating() : stopAnimating()
    }
    func startAnimating() {
        if self.isAnimating {
            return
        }
        
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.duration = 4.0
        animation.fromValue = 0
        animation.toValue = 2*M_PI
        animation.repeatCount = Float(NSIntegerMax)
        self.progressLayer.add(animation, forKey: kAnimationRotationKey)
        
        let headAnimation = CABasicAnimation()
        headAnimation.keyPath = "strokeStart";
        headAnimation.duration = 1.0
        headAnimation.fromValue = 0
        headAnimation.toValue = 0.25
        headAnimation.timingFunction = self.timingFunction
        
        let tailAnimation = CABasicAnimation()
        tailAnimation.keyPath = "strokeEnd"
        tailAnimation.duration = 1.0
        tailAnimation.fromValue = 0
        tailAnimation.toValue = 1.0
        tailAnimation.timingFunction = self.timingFunction
        
        let endHeadAnimation = CABasicAnimation()
        endHeadAnimation.keyPath = "strokeStart"
        endHeadAnimation.beginTime = 1.0
        endHeadAnimation.duration = 0.5
        endHeadAnimation.fromValue = 0.25
        endHeadAnimation.toValue = 1.0
        endHeadAnimation.timingFunction = self.timingFunction
        
        let endTailAnimation = CABasicAnimation()
        endTailAnimation.keyPath = "strokeEnd"
        endTailAnimation.beginTime = 1.0
        endTailAnimation.duration = 0.5
        endTailAnimation.fromValue = 1.0
        endTailAnimation.toValue = 1.0
        endTailAnimation.timingFunction = self.timingFunction
        
        let animations = CAAnimationGroup()
        animations.duration = 1.5
        animations.animations = [headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]
        animations.repeatCount = Float(NSIntegerMax)
        self.progressLayer.add(animations, forKey: kAnimationStrokeKey)
        
        self.isAnimating = true
        
        if _hidesWhenStopped {
            self.isHidden = false
        }
    }
    
    func stopAnimating() {
        if !self.isAnimating {
            return
        }
        
        self.progressLayer.removeAnimation(forKey: kAnimationRotationKey)
        self.progressLayer.removeAnimation(forKey: kAnimationStrokeKey)
        self.isAnimating = false
        
        if _hidesWhenStopped {
            self.isHidden = true
        }
        
    }
    
    func setHidesWhenStopped(_ hidesWhenStopped:Bool){
        _hidesWhenStopped = hidesWhenStopped
        self.isHidden = !self.isAnimating && hidesWhenStopped
    }
}

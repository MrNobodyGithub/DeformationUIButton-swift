//
//  ZDeformationButton.swift
//  ZDefromationButtonSwift
//
//  Created by shmily on 2017/5/24.
//  Copyright © 2017年 freeTime.com. All rights reserved.
//

import UIKit
class ZDeformationButton: UIControl {
    var defaultW:CGFloat!
    var defaultH:CGFloat!
    var defaultR:CGFloat!
    var scale:CGFloat!
    var bgView:UIView!
    
    var spinnerView:ZMozMaterialDesignSpinner!
    var forDisplayButton:UIButton!
    
    var btnBackgroundImage:UIImage?
    
    var _isLoading:Bool = false
    var isLoading:Bool{
        get{ return _isLoading }
        set{
            _isLoading = newValue
            if _isLoading {
                self.startLoading()
            }else{
                self.stopLoading()
            }
        }
    }
    
    var _contentColor:UIColor!
    var contentColor:UIColor {
        get{
            return _contentColor
        }
        set{
            _contentColor = newValue
        }
    }
    
    var _progressColor:UIColor!
    var progressColor:UIColor {
        get{
            return _progressColor
        }
        set{
            _progressColor = newValue
        }
    }
    
    override var frame: CGRect{
        set{
            super.frame = newValue
        }
        get{
            let _frame = super.frame
            return _frame
        }
    }

    override var isSelected: Bool{
        get{return super.isSelected}
        set{
            super.isSelected = newValue
            self.forDisplayButton.isSelected = newValue
        }
    }
    
    override var isHighlighted: Bool{
        get{return super.isHighlighted}
        set{
            super.isHighlighted = newValue
            self.forDisplayButton.isHighlighted = newValue
        }
    }
    init(frame: CGRect, color:UIColor) {
        super.init(frame: frame)
        initSettingWithColor(color)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSettingWithColor(self.tintColor)
    }
    func imageWithColor(_ color : UIColor,cornerRadius:CGFloat) -> UIImage{
        let rect = CGRect.init(x: 0, y: 0, width: cornerRadius*2+10, height: cornerRadius*2+10)
        let path = UIBezierPath.init(roundedRect: rect, cornerRadius: cornerRadius)
        path.lineWidth = 0
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        path.fill()
        path.stroke()
        path.addClip()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    func initSettingWithColor(_ color:UIColor) {
        self.scale = 1.2
        self.bgView = UIView(frame: self.bounds)
        self.bgView.backgroundColor = color
        self.bgView.isUserInteractionEnabled = false
        self.bgView.isHidden = true
        self.bgView.layer.cornerRadius = CGFloat(3)
        self.addSubview(self.bgView)
        
        defaultW = self.bgView.frame.width
        defaultH = self.bgView.frame.height
        defaultR = self.bgView.layer.cornerRadius
        
        self.spinnerView = ZMozMaterialDesignSpinner(frame: CGRect(x: 0 , y: 0, width: defaultH*0.8, height: defaultH*0.8))
        self.spinnerView.tintColor = UIColor.white
        self.spinnerView.lineWidth = 2
        self.spinnerView.center = CGPoint(x: self.layer.bounds.midX, y: self.layer.bounds.midY)
        self.spinnerView.translatesAutoresizingMaskIntoConstraints = false
        self.spinnerView.isUserInteractionEnabled = false
        
        self.addSubview(self.spinnerView)
        
        self.addTarget(self, action: #selector(ZDeformationButton.loadingAction), for: UIControlEvents.touchUpInside)
        
        self.forDisplayButton = UIButton(frame: self.bounds)
        self.forDisplayButton.isUserInteractionEnabled = false
        
        let image = imageWithColor(color, cornerRadius: 3)
        self.forDisplayButton.setBackgroundImage(image.resizableImage(withCapInsets: UIEdgeInsetsMake(10, 10, 10, 10)), for: UIControlState())
        
        self.addSubview(self.forDisplayButton)
        self.contentColor = color;
    }
    
    func loadingAction() {
        if (self.isLoading) {
            self.stopLoading()
        }else{
            self.startLoading()
        }
    }
    
    func startLoading(){
        if (btnBackgroundImage == nil) {
            btnBackgroundImage = self.forDisplayButton.backgroundImage(for: UIControlState())
        }
        
        _isLoading = true;
        self.bgView.isHidden = false
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = defaultR
        animation.toValue = defaultH*scale*0.5
        animation.duration = 0.3
        self.bgView.layer.cornerRadius = defaultH*scale*0.5
        self.bgView.layer.add(animation, forKey: "cornerRadius")
        
        self.forDisplayButton.setBackgroundImage(nil, for: UIControlState())
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            self.bgView.layer.bounds = CGRect(x: 0, y: 0, width: self.defaultW*self.scale, height: self.defaultH*self.scale)
        }) { (Bool) -> Void in
            if self._isLoading {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                    self.bgView.layer.bounds = CGRect(x: 0, y: 0, width: self.defaultH*self.scale, height: self.defaultH*self.scale)
                    self.forDisplayButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    self.forDisplayButton.alpha = 0
                }) { (Bool) -> Void in
                    if self._isLoading {
                        self.forDisplayButton.isHidden = true
                        self.spinnerView.startAnimating()
                    }
                }
                
            }
        }
    }
    
    func stopLoading(){
        _isLoading = false;
        self.spinnerView.stopAnimating()
        self.forDisplayButton.isHidden = false
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            self.forDisplayButton.transform = CGAffineTransform(scaleX: 1, y: 1);
            self.forDisplayButton.alpha = 1;
        }) { (Bool) -> Void in
        }
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = defaultH*scale*0.5
        animation.toValue = defaultR
        animation.duration = 0.3
        self.bgView.layer.cornerRadius = defaultR
        self.bgView.layer.add(animation, forKey: "cornerRadius")
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            self.bgView.layer.bounds = CGRect(x: 0, y: 0, width: self.defaultW*self.scale, height: self.defaultH*self.scale);
        }) { (Bool) -> Void in
            if !self._isLoading {
                let animation = CABasicAnimation(keyPath: "cornerRadius")
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                animation.fromValue = self.bgView.layer.cornerRadius
                animation.toValue = self.defaultR
                animation.duration = 0.2
                self.bgView.layer.cornerRadius = self.defaultR
                self.bgView.layer.add(animation, forKey: "cornerRadius")
                
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                    self.bgView.layer.bounds = CGRect(x: 0, y: 0, width: self.defaultW, height: self.defaultH);
                }) { (Bool) -> Void in
                    if !self._isLoading {
                        if (self.btnBackgroundImage != nil) {
                            self.forDisplayButton.setBackgroundImage(self.btnBackgroundImage, for: UIControlState())
                        }
                        self.bgView.isHidden = true
                    }
                }
            }
        }
    }
    
}

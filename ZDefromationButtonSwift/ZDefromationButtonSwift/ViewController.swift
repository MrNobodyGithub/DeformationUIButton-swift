//
//  ViewController.swift
//  ZDefromationButtonSwift
//
//  Created by shmily on 2017/5/24.
//  Copyright © 2017年 freeTime.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        func getColor(_ hexColor:String)->UIColor{
            var redInt:uint = 0
            var greenInt:uint = 0
            var blueInt:uint = 0
            var range = NSMakeRange(0, 2)
            
            Scanner(string: (hexColor as NSString).substring(with: range)).scanHexInt32(&redInt)
            range.location = 2
            Scanner(string: (hexColor as NSString).substring(with: range)).scanHexInt32(&greenInt)
            range.location = 4
            Scanner(string: (hexColor as NSString).substring(with: range)).scanHexInt32(&blueInt)
            
            return UIColor(red: (CGFloat(redInt)/255.0), green: (CGFloat(greenInt)/255.0), blue: (CGFloat(blueInt)/255.0), alpha: 1)
        }
        
      
            super.viewDidLoad()
            
            let deformationBtn = ZDeformationButton(frame: CGRect(x: 100, y: 100, width: 140, height: 36), color: getColor("e13536"))
            self.view.addSubview(deformationBtn)
            
            deformationBtn.forDisplayButton.setTitle("deformationBtn", for: UIControlState())
            deformationBtn.forDisplayButton.titleLabel?.font = UIFont.systemFont(ofSize: 15);
            deformationBtn.forDisplayButton.setTitleColor(UIColor.white, for: UIControlState())
            deformationBtn.forDisplayButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0)
            deformationBtn.forDisplayButton.setImage(UIImage(named:"logo.png"), for: UIControlState())
            
            deformationBtn.addTarget(self, action: #selector(ViewController.btnEvent), for: UIControlEvents.touchUpInside)
        }
        
        func btnEvent(){
            print("btnEvent", terminator: "")
        }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


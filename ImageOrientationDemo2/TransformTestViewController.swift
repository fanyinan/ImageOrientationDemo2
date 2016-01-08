//
//  TransformTestViewController.swift
//  ImageOrientationDemo2
//
//  Created by 范祎楠 on 16/1/7.
//  Copyright © 2016年 范祎楠. All rights reserved.
//

import UIKit

class TransformTestViewController: UIViewController {

  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var v1: UIView!
  
  var v2: UIView!
  
  var value1: CGFloat = 0
  var value2: CGFloat = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()

    v2 = UIView()
    v2.backgroundColor = UIColor.redColor()
    v2.alpha = 0.5
    
    containerView.addSubview(v2)
    
    v1.layer.anchorPoint = CGPoint(x: 0, y: -0.5)
    v2.frame = v1.frame
  }
  
  func doTransform() {
    
    v1.transform = getTransform()

  }
  
  func getTransform() -> CGAffineTransform {
    
    var transform = CGAffineTransformIdentity
    
    transform = CGAffineTransformRotate(transform, -CGFloat(M_PI_2) * value1)
    transform = CGAffineTransformTranslate(transform, -containerView.frame.height * value2 , 0)
    
    return transform
  }
  
  @IBAction func onChange(sender: UISlider) {

    value1 = CGFloat(sender.value)
    doTransform()
    
    v2.frame = v1.frame

  }
  
  @IBAction func onChange2(sender: UISlider) {
    
    value2 = CGFloat(sender.value)
    doTransform()
    print(v1.frame)
    v2.frame = v1.frame

  }
}

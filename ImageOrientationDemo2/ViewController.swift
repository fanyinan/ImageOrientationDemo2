//
//  ViewController.swift
//  ImageOrientationDemo2
//
//  Created by 范祎楠 on 16/1/6.
//  Copyright © 2016年 范祎楠. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var originImageView: UIImageView!
  @IBOutlet weak var rightCutImageView: UIImageView!
  @IBOutlet weak var falseCutImageView: UIImageView!
  @IBOutlet weak var originImageViewWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var originImageViewHeightConstraint: NSLayoutConstraint!

  @IBOutlet weak var originView: UIView!
  @IBOutlet weak var rightCutView: UIView!
  @IBOutlet weak var falseCutView: UIView!
  
  var maskView: UIView!

  var image: UIImage!
  var originImageScale: CGFloat!
  var value1: CGFloat = 0
  var value2: CGFloat = 0

  var imagePickerViewController: UIImagePickerController!

  var cutRectScale: (xScale: CGFloat, yScale: CGFloat, widthScale: CGFloat, heightScale: CGFloat) = (0, 0.11, 0.2, 0.3)
  var originImageViewStoreWidth: CGFloat!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    originImageViewStoreWidth = originImageView.frame.width
    
    maskView = UIView()
    maskView.backgroundColor = UIColor.yellowColor()
    maskView.alpha = 0.5
    originView.addSubview(maskView)
    
    let rect = CGRect(x: 10, y: 30, width: 50, height: 70)
    
    var rectTransform: CGAffineTransform = CGAffineTransformIdentity
    rectTransform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
    rectTransform = CGAffineTransformTranslate(rectTransform, 100, 0)
    let _rect = CGRectApplyAffineTransform(rect, rectTransform)
    print(_rect)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onStart() {
    
    if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
      
      imagePickerViewController = UIImagePickerController()
      imagePickerViewController.delegate = self
      navigationController?.presentViewController(imagePickerViewController, animated: true, completion: { () -> Void in
      })
    }
  }
  
  @IBAction func onSlider1(sender: UISlider) {
    value1 = CGFloat(sender.value)
    updataMaskView()
//    dealImage()
  }
  
  @IBAction func onSlider2(sender: UISlider) {
    value2 = CGFloat(sender.value)
    updataMaskView()
//    dealImage()
  }
  
  private func transformOrientationRect(originImage: UIImage, rect: CGRect) -> CGRect {
    
    var rectTransform: CGAffineTransform = CGAffineTransformIdentity
    
    switch originImage.imageOrientation {
    case .Left:
      rectTransform = CGAffineTransformMakeRotation(CGFloat(M_PI_2) * value1)
      rectTransform = CGAffineTransformTranslate(rectTransform, 0, -originImage.size.height * value2)
    case .Right:
      rectTransform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2) * value1)
      rectTransform = CGAffineTransformTranslate(rectTransform, -originImage.size.width * value2, 0)
    case .Down:
      rectTransform = CGAffineTransformMakeRotation(CGFloat(-M_PI) * value1)
      rectTransform = CGAffineTransformTranslate(rectTransform, -originImage.size.width * value2, -originImage.size.height * value2)
    default:
      break
    }
    
    let orientationRect = CGRectApplyAffineTransform(rect, CGAffineTransformScale(rectTransform, originImage.scale, originImage.scale))
    
    return orientationRect
    
  }
  
  private func dealImage() {
    
    let falseRect = getRectWithScals()
    print("falseRect \(falseRect)")
    let falseImageRef = CGImageCreateWithImageInRect(image.CGImage, getRectWithScals())
    falseCutImageView.image = UIImage(CGImage: falseImageRef!, scale: 1, orientation: image.imageOrientation)
    
    value1 = 1
    value2 = 1
    let rightRect = transformOrientationRect(image, rect: getRectWithScals())
    
    value1 = 0
    value2 = 0
    
    print("rightRect \(rightRect)")
    let rightImageRef = CGImageCreateWithImageInRect(image.CGImage, rightRect)
    rightCutImageView.image = UIImage(CGImage: rightImageRef!, scale: 1, orientation: image.imageOrientation)
  }
  
  private func getRectWithScals() -> CGRect {
    
    return CGRect(x: cutRectScale.xScale * image.size.width, y: cutRectScale.yScale * image.size.height, width: cutRectScale.widthScale * image.size.width, height: cutRectScale.heightScale * image.size.height)
  }
  
  private func updataMaskView() {
    
    var rectInImage = getRectWithScals()
    
    rectInImage = transformOrientationRect(image, rect: rectInImage)

    rectInImage = CGRect(x: rectInImage.origin.x * originImageScale, y: rectInImage.origin.y * originImageScale, width: rectInImage.size.width * originImageScale, height: rectInImage.size.height * originImageScale)
    
    print("rectInImage \(rectInImage)")
    let rectInSuperView = originView.convertRect(rectInImage, fromView: originImageView)
    
    maskView.frame = rectInSuperView
    originImageView.bringSubviewToFront(maskView)
  }
  
  private func getOrientation(image: UIImage) -> String {
    
    var imageOrientation = ""
    
    switch image.imageOrientation {
    case .Down:
      imageOrientation = "Down"
    case .Up:
      imageOrientation = "Up"
    case .Left:
      imageOrientation = "Left"
    case .Right:
      imageOrientation = "Right"
    case .DownMirrored:
      imageOrientation = "DownMirrored"
    case .UpMirrored:
      imageOrientation = "UpMirrored"
    case .RightMirrored:
      imageOrientation = "RightMirrored"
    case .LeftMirrored:
      imageOrientation = "LeftMirrored"
    }
    
    return imageOrientation
  }

  private func getImageCurrentSize(image: UIImage) -> CGSize {
    
    let length = min(image.size.height, image.size.width)
    
    originImageScale = originImageViewStoreWidth / length
    
    return CGSize(width: image.size.width * originImageScale, height: image.size.height * originImageScale)
    
  }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    let type : String = info[UIImagePickerControllerMediaType] as! String
    
    if type == "public.image" {
      
      
      image = info[UIImagePickerControllerOriginalImage] as! UIImage
      
      //为了模拟图片原来的方向
      let showImage = UIImage(CGImage: image.CGImage!, scale: image.scale, orientation: .Up)
      originImageView.image = showImage
      originImageViewWidthConstraint.constant = getImageCurrentSize(showImage).width
      originImageViewHeightConstraint.constant = getImageCurrentSize(showImage).height
      
      view.setNeedsLayout()
      view.layoutIfNeeded()
      
      print("image size \(image.size) ,  orientation \(getOrientation(image))")
      
      updataMaskView()
      
      dealImage()
      
      dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
}

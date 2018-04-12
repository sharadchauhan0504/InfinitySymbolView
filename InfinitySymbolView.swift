//
//  InfinitySymbolView.swift
//  Infinity
//
//  Created by Sharad on 27/11/17.
//  Copyright © 2017 Sharad. All rights reserved.
//

import UIKit

class InfinitySymbolView: UIView, CAAnimationDelegate {

    var path: UIBezierPath!
    
    let circleLayer = CAShapeLayer()
    var circlePathSize:CGSize?
    let circleView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)


    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code

        let context      = UIGraphicsGetCurrentContext()

        let height       = self.frame.height
        let width        = self.frame.width
        let heightFactor = height/4
        let widthFactor  = width/4

        path             = UIBezierPath()
        path.lineWidth   = 3.0

        path.move(to: CGPoint(x:widthFactor, y: heightFactor * 3))
        path.addCurve(to: CGPoint(x:widthFactor, y: heightFactor), controlPoint1: CGPoint(x:0, y: heightFactor * 3), controlPoint2: CGPoint(x:0, y: heightFactor))
        
        path.move(to: CGPoint(x:widthFactor, y: heightFactor))
        path.addCurve(to: CGPoint(x:widthFactor * 3, y: heightFactor * 3), controlPoint1: CGPoint(x:widthFactor * 2, y: heightFactor), controlPoint2: CGPoint(x:widthFactor * 2, y: heightFactor * 3))
        
        path.move(to: CGPoint(x:widthFactor * 3, y: heightFactor * 3))
        path.addCurve(to: CGPoint(x:widthFactor * 3, y: heightFactor), controlPoint1: CGPoint(x:widthFactor * 4 + 5, y: heightFactor * 3), controlPoint2: CGPoint(x:widthFactor * 4 + 5, y: heightFactor))
        
        path.move(to: CGPoint(x:widthFactor * 3, y: heightFactor))
        path.addCurve(to: CGPoint(x:widthFactor, y: heightFactor * 3), controlPoint1: CGPoint(x:widthFactor * 2, y: heightFactor), controlPoint2: CGPoint(x:widthFactor * 2, y: heightFactor * 3))
        
        context!.saveGState()
        context?.setShadow(offset: CGSize.init(width: 1.0, height: 1.0), blur: 0.0)
        
        UIColor.white.setStroke()
        path.stroke()
        context!.restoreGState()
        
       
        circleLayer.path      = path.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(circleLayer)

        animateCircleOnPath()
    }

    var animationDuration = 5.0
    func animateCircleOnPath(){
        let animation                  = CAKeyframeAnimation(keyPath: "position");
        animation.duration             = animationDuration
        animation.repeatCount          = MAXFLOAT
        animation.delegate = self
        animation.path                 = path.cgPath
        
        circleView.frame               = CGRect(x: 0, y: 0, width: 20, height: 20)
        circleView.layer.cornerRadius  = 10
        circleView.layer.shadowColor   = UIColor.darkGray.cgColor
        circleView.layer.shadowOpacity = 7.0
        circleView.layer.shadowRadius  = 3.0
        circleView.layer.shadowOffset  = CGSize(width: 2, height: 0)
        circleView.backgroundColor     = UIColor.cyan
        self.addSubview(circleView)
        circleView.layer.add(animation, forKey: nil)
    }
    
    func pauseLayer(layer: CALayer){
        let pausedTime = layer.convertTime(CACurrentMediaTime(), to: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func resumeLayer(layer: CALayer){
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(pausedTime, to: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
}

//
//  AHLimberTabbarBackgroundView.swift
//  LimberTabbar
//
//  Created by Afshin Hoseini on 4/20/19.
//  Copyright © 2019 Afshin Hoseini. All rights reserved.
//

import Foundation
import UIKit

class AHLimberTabbarBackgroundView : UIView {
    
    var borderLayer = CAShapeLayer()
    let pitDepth = CGFloat(40)
    let maxDepth = CGFloat(40)
    
    convenience init(parent: UIView) {
        
        self.init(frame: parent.frame)
        
        
        parent.addSubview(self)
        
        if #available(iOS 9.0, *) {
            translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                
                topAnchor.constraint(equalTo: parent.topAnchor),
                leadingAnchor.constraint(equalTo: parent.leadingAnchor),
                trailingAnchor.constraint(equalTo: parent.trailingAnchor),
                bottomAnchor.constraint(equalTo: parent.bottomAnchor)
                ])
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        
        addLayers()
    }
    
    func addLayers() {
        
        //Initializes border and guide rects layers
        
        borderLayer.bounds = bounds
        borderLayer.fillColor = UIColor.red.cgColor
        borderLayer.strokeColor = UIColor.red.cgColor
        borderLayer.position = CGPoint(x: 0, y: 0)
        borderLayer.anchorPoint = CGPoint(x: 0, y: 0)
        borderLayer.lineJoin = .round
        
        borderLayer.shadowColor = UIColor.black.cgColor
        borderLayer.shadowOffset = CGSize(width: 0, height: -2)
        borderLayer.shadowRadius = 1
        borderLayer.shadowOpacity = 0.3
        
        layer.addSublayer(borderLayer)
        
        //self.backgroundColor = nil
    }
    
    /**
     * Renders the border of view including the hole
     */
    func renderBorder(pitCenterX : CGFloat) {
        
        borderLayer.path = getBorderPath(for: pitCenterX, depthScale: 1)
    }
    
    func getBorderPath(for pitCenterX: CGFloat, depthScale: CGFloat) -> CGMutablePath {
        
        //Initial calculations
        let pitWidth = pitDepth * 2
        let y = CGFloat(0)
        let holeStartingPointX = pitCenterX - (pitWidth/2)
        
        //Creates the hole
        let borderPath = CGMutablePath()
        borderPath.move(to: CGPoint.zero)
        borderPath.addLine(to: CGPoint(x: holeStartingPointX, y: y))
        
        borderPath.addPit(toPath: borderPath, startingPointX: holeStartingPointX, y: y, depth: pitDepth, scale: depthScale)
        
        borderPath.addLine(to: CGPoint(x: bounds.width, y: 0))
        borderPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        borderPath.addLine(to: CGPoint(x: 0, y: bounds.height))
        borderPath.addLine(to: CGPoint(x: 0, y: 0))
        
        return borderPath
    }
    
    func animatePit(fromCenterX: CGFloat, toCenterX : CGFloat) {
        
        
        let anim = CAKeyframeAnimation(keyPath: #keyPath(CAShapeLayer.path))
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        anim.values = [
            getBorderPath(for: fromCenterX, depthScale:1),
            getBorderPath(for: fromCenterX + (toCenterX-fromCenterX)/2, depthScale:0.8),
            getBorderPath(for: toCenterX, depthScale:1)
        ]
        anim.keyTimes = [0,0.5,1]
        anim.duration = CFTimeInterval(0.6)
        anim.isRemovedOnCompletion = false
        anim.fillMode = .both
        
        borderLayer.add(anim, forKey: #keyPath(CAShapeLayer.path))
    }
}

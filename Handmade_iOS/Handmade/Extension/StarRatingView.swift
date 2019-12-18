//
//  StartRatingView.swift
//  Handmade
//
//  Created by mk on 2019/12/19.
//  Copyright © 2019 mk. All rights reserved.
//
// https://github.com/evgenyneu/Cosmos를 참조하여 필요한 코드로만 구성함

import UIKit

@IBDesignable class StarRatingView: UIView {
    
    @IBInspectable var rating: Double = 0.0 {
        
        didSet {
            
            update()
        }
    }
    
    open func update() {
        
        let layers = createStarLayers(rating)
        layer.sublayers = layers
        
        updateSize(layers)
    }
    
    private func updateSize(_ layers: [CALayer]) {
        
        let _ = calculateSizeToFitLayers(layers)
        
        invalidateIntrinsicContentSize()
        
        frame.size = intrinsicContentSize
        
        backgroundColor = UIColor.red
    }
    
    func calculateSizeToFitLayers(_ layers: [CALayer]) -> CGSize {
        
        var size = CGSize()
        
        for layer in layers {
            
            if layer.frame.maxX > size.width {
                
                size.width = layer.frame.maxX
            }
            
            if layer.frame.maxY > size.height {
                
                size.height = layer.frame.maxY
            }
        }
        
        return size
    }
    
    func createStarLayers(_ rating: Double) -> [CALayer] {
        
        var starLayers = [CALayer]()
        
        var ratingRemander = rating
        
        for _ in (0 ..< 5) {
            
            let fillLevel = ratingRemander >= 1 ? 1 : ratingRemander
            let starLayer = createCompositeStarLayer(fillLevel)
            starLayers.append(starLayer)
            ratingRemander -= 1
        }
        
        positionStarLayers(starLayers)
        
        return starLayers
    }
    
    func createCompositeStarLayer(_ starFillLevel: Double) -> CALayer {
        
        if starFillLevel >= 1 {
            
            return StarLayer.createStarLayer(true)
        }
        else if starFillLevel == 0 {
            
            return StarLayer.createStarLayer(false)
        }
        else {
            
            return StarLayer.createPartialStar(starFillLevel)
        }
    }
    
    func positionStarLayers(_ layers: [CALayer]) {
        
        var positionX:CGFloat = 0
        
        for layer in layers {
            
            layer.position.x = positionX
            positionX += layer.bounds.width + 4.0
        }
    }
    
    struct StarLayer {
        
        static let totalStars = 5
        static var starSize: Double = 20.0
        
        static let starPoints: [CGPoint] = [
            
          CGPoint(x: 49.5,  y: 0.0),
          CGPoint(x: 60.5,  y: 35.0),
          CGPoint(x: 99.0, y: 35.0),
          CGPoint(x: 67.5,  y: 58.0),
          CGPoint(x: 78.5,  y: 92.0),
          CGPoint(x: 49.5,    y: 71.0),
          CGPoint(x: 20.5,  y: 92.0),
          CGPoint(x: 31.5,  y: 58.0),
          CGPoint(x: 0.0,   y: 35.0),
          CGPoint(x: 38.5,  y: 35.0)
        ]
        
        static var filledBorderWidth: Double = 1.0
        static var emptyBorderWidth: Double = 1.0
        
        static var filledColor: UIColor = UIColor.yellow
        static var emptyColor: UIColor = UIColor.lightGray
        
        static var filledBorderColor: UIColor = UIColor.yellow
        static var emptyBorderColor: UIColor = UIColor.lightGray
        
        static func create(_ starPoints: [CGPoint], size: Double, lineWidth: Double, fillColor: UIColor, strokeColor: UIColor) -> CALayer {
            
          let containerLayer = createContainerLayer(size)
          let path = createStarPath(starPoints, size: size, lineWidth: lineWidth)
            
          let shapeLayer = createShapeLayer(path.cgPath, lineWidth: lineWidth, fillColor: fillColor, strokeColor: strokeColor, size: size)
            
          containerLayer.addSublayer(shapeLayer)
          
          return containerLayer
        }
        
        static func createContainerLayer(_ size: Double) -> CALayer {
            
          let layer = CALayer()
          layer.contentsScale = UIScreen.main.scale
          layer.anchorPoint = CGPoint()
          layer.masksToBounds = true
          layer.bounds.size = CGSize(width: size, height: size)
          layer.isOpaque = true
            
          return layer
        }
        
        static func createStarPath(_ starPoints: [CGPoint], size: Double, lineWidth: Double) -> UIBezierPath {
          
          let lineWidthLocal = lineWidth + ceil(lineWidth * 0.3)
          let sizeWithoutLineWidth = size - lineWidthLocal * 2
          
          let points = scaleStar(starPoints, factor: sizeWithoutLineWidth / 100, lineWidth: lineWidthLocal)
          
          let path = UIBezierPath()
          path.move(to: points[0])
          let remainingPoints = Array(points[1..<points.count])
          
          for point in remainingPoints {
            
            path.addLine(to: point)
          }
          
          path.close()
            
          return path
        }
        
        static func scaleStar(_ starPoints: [CGPoint], factor: Double, lineWidth: Double) -> [CGPoint] {
            
          return starPoints.map { point in
            
            return CGPoint(
                
              x: point.x * CGFloat(factor) + CGFloat(lineWidth),
              y: point.y * CGFloat(factor) + CGFloat(lineWidth)
            )
          }
        }
        
        static func createShapeLayer(_ path: CGPath, lineWidth: Double, fillColor: UIColor, strokeColor: UIColor, size: Double) -> CALayer {
            
          let layer = CAShapeLayer()
          layer.anchorPoint = CGPoint()
          layer.contentsScale = UIScreen.main.scale
          layer.strokeColor = strokeColor.cgColor
          layer.fillColor = fillColor.cgColor
          layer.lineWidth = CGFloat(lineWidth)
          layer.bounds.size = CGSize(width: size, height: size)
          layer.masksToBounds = true
          layer.path = path
          layer.isOpaque = true
            
          return layer
        }
        
        static func createPartialStar(_ starFillLevel: Double) -> CALayer {
            
          let filledStar = createStarLayer(true)
          let emptyStar = createStarLayer(false)

          let parentLayer = CALayer()
          parentLayer.contentsScale = UIScreen.main.scale
          parentLayer.bounds = CGRect(origin: CGPoint(), size: filledStar.bounds.size)
          parentLayer.anchorPoint = CGPoint()
          parentLayer.addSublayer(emptyStar)
          parentLayer.addSublayer(filledStar)
          
          filledStar.bounds.size.width *= CGFloat(starFillLevel)

          return parentLayer
        }
        
        static func createStarLayer(_ isFilled: Bool) -> CALayer {
                      
          let fillColor = isFilled ? filledColor : emptyColor
          let strokeColor = isFilled ? filledBorderColor : emptyBorderColor

            return StarLayer.create(StarLayer.starPoints, size: StarLayer.starSize,
                                  lineWidth: isFilled ? filledBorderWidth : emptyBorderWidth,
                                  fillColor: fillColor, strokeColor: strokeColor)
        }
    }
}

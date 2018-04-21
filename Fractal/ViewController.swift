//
//  ViewController.swift
//  Fractal
//
//  Created by Nazar on 21.04.18.
//  Copyright © 2018 Nazar. All rights reserved.
//

import UIKit

enum Points: Int {
    case First
    case Second
    case Third
    case StartPoint
    case Finish
    
    func nextPoints() -> Points {
        return Points(rawValue: rawValue + 1) ?? .First
    }
}

class ViewController: UIViewController {
    
    var stateOfPoints: Points = .First
    var arrayOfPoints: [CGPoint] = []
    var currentPoint: CGPoint = .zero
    
    var i = 1
    
    var canvas: UIView = UIView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvas.frame = self.view.frame
        canvas = UIImageView(image: UIImage(named: "cells"))
        addGesture(view: self.view)
        self.view.addSubview(canvas)
    }
    
    private func addGesture(view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.doSomeThing(gesture:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func doSomeThing(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: self.view)
        let pointOnMainView = gesture.location(in: self.view)
        let topView = self.view.hitTest(pointOnMainView, with: nil)
        
        if self.view.isEqual(topView) {
            switch stateOfPoints {
            case .First:
                self.drawCircle(point: point)
                self.arrayOfPoints.append(point)
            case .Second:
                self.drawCircle(point: point)
                self.arrayOfPoints.append(point)
            case .Third:
                self.drawCircle(point: point)
                self.arrayOfPoints.append(point)
                self.drawTriangle()
            case .StartPoint:
                self.drawCircle(point: point)
                self.currentPoint = point
                self.start()
            case .Finish:
                self.finish()
            }
            self.nextPoint()
        }
    }
    
    private func drawCircle(point: CGPoint) {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: point.x, y: point.y), radius: CGFloat(3), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 1.0
        self.view.layer.addSublayer(shapeLayer)
    }
    
    private func drawTriangle() {
        if !arrayOfPoints.isEmpty || arrayOfPoints.count >= 3 {
            let trianglePath = UIBezierPath()
            trianglePath.move(to: self.arrayOfPoints[0])
            trianglePath.addLine(to: self.arrayOfPoints[1])
            trianglePath.addLine(to: self.arrayOfPoints[2])
            trianglePath.close()
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = trianglePath.cgPath
            
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = UIColor.red.cgColor
            shapeLayer.lineWidth = 1.0
            self.view.layer.addSublayer(shapeLayer)
        }
    }
    
    private func start() {
        print("Start: ")
        while stateOfPoints == .StartPoint && i < 5000 {
            let point = randomPoint()
            print("point number \(i): ", point)
            let x = (self.currentPoint.x + point.x) / 2
            let y = (self.currentPoint.y + point.y) / 2
            self.currentPoint = CGPoint(x: x, y: y)
            self.drawCircle(point: currentPoint)
            i = i + 1
        }
    }
    
    private func finish() {
        print("Finish: ")
        self.arrayOfPoints.removeAll()
        i = 1
    }
    
    private func nextPoint() {
        stateOfPoints = Points.nextPoints(stateOfPoints)()
    }

    private func randomPoint() -> CGPoint {
        let number = Int(arc4random_uniform(3))
        return self.arrayOfPoints[number]
    }
}


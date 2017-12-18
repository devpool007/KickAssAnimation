//
//  ViewController.swift
//  KickAssAnimation
//
//  Created by Devansh Sharma on 18/12/17.
//  Copyright © 2017 Devansh Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController,URLSessionDownloadDelegate {

    let shapeLayer = CAShapeLayer()
    
    var pulsatingLayer = CAShapeLayer()
    
    let percentageLabel: UILabel = {
        let view = UILabel()
        view.text = "Start"
        view.textAlignment = .center
        view.font = UIFont.boldSystemFont(ofSize: 32)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
        let center = view.center
        //create track layer
        let tracklayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * (CGFloat.pi) , clockwise: true)
        
        tracklayer.path = circularPath.cgPath
        tracklayer.strokeColor = UIColor.lightGray.cgColor
        tracklayer.lineWidth = 10
        tracklayer.lineCap = kCALineCapRound
        tracklayer.fillColor = UIColor.clear.cgColor
        tracklayer.position = center
        view.layer.addSublayer(tracklayer)
        
        
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        pulsatingLayer.lineWidth = 10
        pulsatingLayer.lineCap = kCALineCapRound
        pulsatingLayer.fillColor = UIColor.yellow.cgColor
        pulsatingLayer.position = center
        view.layer.addSublayer(pulsatingLayer)
        
        animatePulsatingLayer()
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.position = center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
        
        view.layer.addSublayer(shapeLayer)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
    }
    
    private func animatePulsatingLayer(){
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.8
        animation.toValue = 1.5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulse")
    }

    let urlString = "https://firebasestorage.googleapis.com/v0/b/firestorechat-e64ac.appspot.com/o/intermediate_training_rec.mp4?alt=media&token=e20261d0-7219-49d2-b32d-367e1606500c"
    
    private func beginDownloadingFile(){
        print("Attempting to download file")
        
        shapeLayer.strokeEnd = 0
        let config = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: config, delegate: self, delegateQueue: operationQueue)
        
        guard let url = URL(string: urlString) else {return}
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print(totalBytesWritten, totalBytesExpectedToWrite)
        
        let percentage = CGFloat(totalBytesWritten)/CGFloat(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
             self.percentageLabel.text = "\(Int(percentage * 100))%"
             self.shapeLayer.strokeEnd = percentage
        }
       
        
        print(percentage)
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished Downloading")
    }
    
    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "Basic")
    }
    
    @objc private func handleTap(){
        
        print("cool")
        
        beginDownloadingFile()
        
        //animateCircle()
    }
   


}


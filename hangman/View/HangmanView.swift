//
//  Hangman.swift
//  Milestone Projects 7-9
//
//  Created by Dimas on 31/08/21.
//

import UIKit

class HangmanView: UIView {
	
	private(set) var livesLeft = 8;

	override func draw(_ rect: CGRect) {
		super.draw(rect)
		//        createHanger()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}
	
	// Returns boolean that indicate whether the game is over
	func continueStage() -> Bool {
		var isGameOver = false
		
		switch livesLeft {
		case 8:
			createHanger()
		case 7:
			createHead()
		case 6:
			createBody()
		case 5:
			createLeftHand()
		case 4:
			createRightHand()
		case 3:
			createLeftLeg()
		case 2:
			createRightLeg()
		case 1:
			createLoop()
			isGameOver = true
		default:
			fatalError("Unknown number of lives left")
		}
		
		livesLeft -= 1;
		return isGameOver
	}
	
	func restart() {
		livesLeft = 8;
		layer.sublayers?.removeAll()
	}
	
	private func setup() {
		backgroundColor = .clear
	}
	
	private func createLine(from: (x: CGFloat, y: CGFloat), to: (x: CGFloat, y: CGFloat), animate: Bool = true, for duration: Double = 0.2) {
		let path = UIBezierPath()
		path.move(to: .init(x: from.x, y: from.y))
		path.addLine(to: .init(x: to.x, y: to.y))
		
		let shapeLayer = CAShapeLayer() // a special layer where paths can be rendered inside
		layer.addSublayer(shapeLayer)
		shapeLayer.path = path.cgPath
		shapeLayer.lineWidth = 5
		shapeLayer.strokeColor = .init(red: 0.9137, green: 0.9098, blue: 0.9059, alpha: 1)
		
		if animate {
			let animation = CABasicAnimation(keyPath: "strokeEnd")
			animation.fromValue = 0.0
			animation.toValue = 1.0
			animation.duration = duration
			animation.beginTime = CACurrentMediaTime() + 0 // I don't know why if I don't use this, the animation will be broken

			shapeLayer.add(animation, forKey: "strokeEnd")
		}
	}
	
	private func createCircle(center: CGPoint, withDiameter diameter: CGFloat, animate: Bool = true, for duration: Double = 0.2) {
		let rect = CGRect(x: center.x, y: center.y, width: diameter, height: diameter)
		let circle = UIBezierPath(ovalIn: rect)
		
		let shapeLayer = CAShapeLayer() // a special layer where paths can be rendered inside
		layer.addSublayer(shapeLayer)
		shapeLayer.path = circle.cgPath
		shapeLayer.lineWidth = 5
		shapeLayer.fillColor = nil
		shapeLayer.strokeColor = .init(red: 0.9137, green: 0.9098, blue: 0.9059, alpha: 1)
		
		if animate {
			let animation = CABasicAnimation(keyPath: "strokeEnd")
			animation.fromValue = 0.0
			animation.toValue = 1.0
			animation.duration = duration
			animation.beginTime = CACurrentMediaTime() + 0 // I don't know why if I don't use this, the animation will be broken
			
			shapeLayer.add(animation, forKey: "strokeEnd")
		}
	}
	
	private func createHanger() {
		createLine(from: (x: 0, y: bounds.width), to: (x: 0, y: 0))
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
			guard let self = self else { return }
			self.createLine(from: (x: 0, y: 0), to: (x: self.bounds.width/2, y: 0))
		}

		setNeedsDisplay()
	}
	
	private func createHead() {
		createCircle(center: CGPoint(x: (bounds.width/2) - 15, y: 50), withDiameter: 30)
	}
	
	private func createBody() {
		createLine(from: (x: bounds.width/2, y: 80), to: (x: bounds.width/2, y: 140))
	}
	
	private func createLeftHand() {
		createLine(from: (x: (bounds.width/2) + 1, y: 90), to: (x: (bounds.width/2) - 20, y: 120))
	}
	
	private func createRightHand() {
		createLine(from: (x: (bounds.width/2) - 1, y: 90), to: (x: (bounds.width/2) + 20, y: 120))
	}
	
	private func createLeftLeg() {
		createLine(from: (x: (bounds.width/2) + 1, y: 140), to: (x: (bounds.width/2) - 15, y: 180))
	}
	
	private func createRightLeg() {
		createLine(from: (x: (bounds.width/2) + 1, y: 140), to: (x: (bounds.width/2) + 15, y: 180))
	}
	
	private func createLoop() {
		createLine(from: (x: bounds.width/2, y: 0), to: (x: bounds.width/2, y: bounds.height/4))
	}
	
	
}

//
//  TouchVelocityTracker.swift
//  Graphite
//
//  Created by Palle Klewitz on 18.12.17.
//  Copyright (c) 2017 Palle Klewitz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import UIKit

class TouchVelocityTracker {
	private var touches: [UITouch: (CGVector, TimeInterval)] = [:]
	private var view: UIView?
	
	func update(touch: UITouch) {
		let (newVector, newUpdateTime): (CGVector, TimeInterval)
		
		if let (lastVector, lastUpdate) = self.touches[touch] {
			let location = touch.location(in: view)
			let previousLocation = touch.previousLocation(in: view)
			
			newUpdateTime = touch.timestamp
			
			guard newUpdateTime != lastUpdate else {
				return
			}
			
			let delta = CGFloat(newUpdateTime - lastUpdate)
			
			let vector = CGVector(dx: (location.x - previousLocation.x) / delta, dy: (location.y - previousLocation.y) / delta)
			
			let decay = min(delta * 5, 1)
			
			newVector = CGVector(
				dx: lastVector.dx * (1 - decay) + vector.dx * decay,
				dy: lastVector.dy * (1 - decay) + vector.dy * decay
			)
		} else {
			newVector = .zero
			newUpdateTime = touch.timestamp
		}
		
		touches[touch] = (newVector, newUpdateTime)
	}
	
	func velocity(for touch: UITouch) -> CGVector {
		return touches[touch]?.0 ?? .zero
	}
	
	func endTracking(_ touch: UITouch) {
		touches.removeValue(forKey: touch)
	}
}
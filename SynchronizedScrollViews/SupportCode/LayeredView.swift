//
//  LayeredView.swift
//
//  Created by usagimaru on 2023/11/13.
//  Copyright © 2023 usagimaru.
//

import AppKit

class LayeredView: NSView {
	
	var mainLayer: CALayer {
		if layer == nil {
			wantsLayer = true
		}
		return layer!
	}
	
	var customFlippingFlag: Bool = false
	override var isFlipped: Bool {
		customFlippingFlag
	}
	
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		setup()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}
	
	override func viewWillMove(toSuperview newSuperview: NSView?) {
		super.viewWillMove(toSuperview: newSuperview)
		
		if newSuperview != nil {
			willShow()
		}
		else {
			willRemove()
		}
	}
	
	func willShow() {
		
	}
	
	func willRemove() {
		
	}
	
	private(set) var setupFlag: Bool = false
	
	func setup() {
		if !setupFlag {
			wantsLayer = true
			layerContentsRedrawPolicy = .onSetNeedsDisplay
			needsLayout = true
			needsDisplay = true
			setupFlag = true
		}
	}
	
	override func updateLayer() {
	}
	
}

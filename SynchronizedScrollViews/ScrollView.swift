//
//  ScrollView.swift
//
//  Created by usagimaru on 2023/11/17.
//  Copyright © 2023 usagimaru.
//

import AppKit

class ScrollView: NSScrollView {
	
	enum ScrollDirection {
		case horizontal
		case vertical
		case both
	}
	
	var documentOffset: NSPoint {
		set { documentView?.scroll(newValue) }
		get { documentVisibleRect.origin }
	}
	var documentSize: NSSize {
		set { documentView?.setFrameSize(newValue) }
		get { documentView?.frame.size ?? .zero }
	}
	
	/// Flips Y-axis
	var customFlippingFlag: Bool = false { didSet {
		(documentView as? LayeredView)?.customFlippingFlag = customFlippingFlag
		(contentView as? ClipView)?.customFlippingFlag = customFlippingFlag
	}}
	override var isFlipped: Bool {
		customFlippingFlag
	}
	
	private(set) weak var trackerScrollView: ScrollView?
	private(set) var synchronizationDirection: ScrollDirection = .vertical
	
	private var observation = Notify()
	
	
	// MARK: -
	
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		contentView = ClipView()
		documentView = LayeredView()
		
		_init()
		
		borderType = .noBorder
		hasHorizontalScroller = true
		hasVerticalScroller = true
		scrollsDynamically = true
		verticalScrollElasticity = .allowed
		horizontalScrollElasticity = .allowed
		usesPredominantAxisScrolling = true
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		_init()
	}
	
	func _init() {
		_prepareEventReceivers()
	}
	
	private func _prepareEventReceivers() {
		// Required for NSView.boundsDidChangeNotification
		postsBoundsChangedNotifications = true
		
		// Reacts to changes in coordinates of bounds
		observation.receive(NSView.boundsDidChangeNotification, sender: contentView) { [weak self] notification in
			guard let self else { return }
			
			let newOrigin = self.documentOffset
			
			if let trackerScrollView, trackerScrollView.trackerScrollView != self {
				var newOffset = trackerScrollView.documentOffset
				switch synchronizationDirection {
					case .horizontal:
						newOffset.x = newOrigin.x
						
					case .vertical:
						newOffset.y = newOrigin.y
						
					case .both:
						newOffset = newOrigin
				}
				
				/*
				 These methods have problems with synchronization on bounce.
				 
				 trackerScrollView.contentView.scroll(newOffset)
				 trackerScrollView.contentView.bounds.origin = newOffset
				 trackerScrollView.documentOffset = newOffset
				 */
				
				// Using `NSScrollView.scroll(_ clipView: NSClipView, to point: NSPoint)` works perfectly.
				// https://developer.apple.com/documentation/appkit/nsview/1531337-scroll
				trackerScrollView.scroll(trackerScrollView.contentView, to: newOffset)
				trackerScrollView.reflectScrolledClipView()
			}
		}
	}
	
	
	// MARK: -
	
	/// Set the tracker scroll view
	func setTracker(_ scrollView: ScrollView?, direction: ScrollDirection) {
		trackerScrollView = scrollView
		synchronizationDirection = direction
	}
	
	func reflectScrolledClipView() {
		reflectScrolledClipView(contentView)
	}
	
}

class ClipView: NSClipView {
	
	/// Flips Y-axis
	var customFlippingFlag: Bool = false
	override var isFlipped: Bool {
		customFlippingFlag
	}
	
}

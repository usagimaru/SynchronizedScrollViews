//
//  ViewController.swift
//  SynchronizedScrollViews
//
//  Created by usagimaru on 2024/06/08.
//

import Cocoa
import SnapKit

class ViewController: NSViewController {
	
	@IBOutlet var splitView: NSSplitView!
	
	private var leadingScrollView: ScrollView!
	private var trailingScrollView: ScrollView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUIForTesting()
		
		// Set tracker
		leadingScrollView.setTracker(trailingScrollView, direction: .vertical)
	}
	
	
	// MARK: -
	
	override func viewWillAppear() {
		super.viewWillAppear()
		
		// Set scroll content sizes
		leadingScrollView.documentSize = NSSize(width: 500, height: 2000)
		trailingScrollView.documentSize = NSSize(width: 1000, height: 2000)
	}

}

extension ViewController {
	
	private func setupUIForTesting() {
		leadingScrollView = prepareScrollView(at: 0)
		trailingScrollView = prepareScrollView(at: 1)
		
		leadingScrollView.drawsBackground = true
		leadingScrollView.backgroundColor = NSColor.orange.withAlphaComponent(0.2)
		
		trailingScrollView.drawsBackground = true
		trailingScrollView.backgroundColor = NSColor.blue.withAlphaComponent(0.2)
		
		insertTestView(.init(x: 20, y: 60, width: 150, height: 60),
					   image: NSImage(systemSymbolName: "rectangle.leadinghalf.inset.filled", accessibilityDescription: nil)!,
					   to: leadingScrollView)
		insertTestView(.init(x: 20, y: 60, width: 200, height: 100),
					   image: NSImage(systemSymbolName: "rectangle.trailinghalf.inset.filled", accessibilityDescription: nil)!,
					   to: trailingScrollView)
	}
	
	private func prepareScrollView(at paneIndex: Int) -> ScrollView {
		let pane = splitView.arrangedSubviews[paneIndex]
		let scrollView = ScrollView()
		scrollView.customFlippingFlag = true
		
		pane.addSubview(scrollView)
		scrollView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		return scrollView
	}
	
	@discardableResult
	private func insertTestView(_ frame: NSRect, image: NSImage, to: ScrollView) -> LayeredView {
		let testView = LayeredView(frame: frame)
		
		let imageView = NSImageView(image: image)
		imageView.symbolConfiguration = .init(scale: .large)
		imageView.contentTintColor = NSColor.white
		
		testView.addSubview(imageView)
		imageView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalToSuperview().offset(8)
			make.size.equalTo(NSSize(width: 28, height: 28))
		}
		
		testView.mainLayer.backgroundColor = NSColor.lightGray.cgColor
		to.documentView?.addSubview(testView)
		
		return testView
	}
	
}


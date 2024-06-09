//
//  Notify.swift
//
//  Created by usagimaru on 2023/02/09.
//  Copyright © 2023 usagimaru.
//

import Foundation

class Notify {
	
	/// オブザーバオブジェクト型
	typealias ObservationObject = NSObjectProtocol
	/// オブザーバID型
	typealias ObserverID = UUID
	
	/// オブザーバを格納する辞書
	private var observers = [ObserverID : ObservationObject]()
	
	/// 登録済みオブザーバの数
	var observerCount: Int {
		observers.count
	}
	
	deinit {
		removeAllObservers()
	}
	
	/// オブザーバを登録 (Closure)
	@discardableResult
	func receive(_ name: Notification.Name,
				 center: NotificationCenter = .default,
				 sender: Any?,
				 queue: OperationQueue? = .main,
				 perform: @escaping (_ notification: Notification) -> Void) -> ObserverID {
		let observer = center.addObserver(forName: name, object: sender, queue: queue) { (notification) in
			perform(notification)
		}
		let id = ObserverID()
		observers[id] = observer
		
		return id
	}
	
	/// オブザーバの登録済み状態を確認
	func isObserverRegistered(id: ObserverID) -> Bool {
		observers[id] != nil
	}
	
	/// オブザーバを削除
	func removeObserver(with id: ObserverID, center: NotificationCenter = .default) {
		if let observer = observers[id] {
			center.removeObserver(observer)
		}
		observers.removeValue(forKey: id)
	}
	
	/// すべてのオブザーバを削除
	func removeAllObservers() {
		observers.keys.forEach { id in
			removeObserver(with: id)
		}
	}
	
}

extension Notify {
	
	/// 通知を送信
	class func post(_ name: Notification.Name,
					center: NotificationCenter = .default,
					sender: Any?,
					userInfo: [AnyHashable : Any]? = nil) {
		center.post(name: name, object: sender, userInfo: userInfo)
	}
	
	/// オブザーバを登録 (Closure)
	@discardableResult
	class func receive(_ name: Notification.Name,
					   center: NotificationCenter = .default,
					   sender: Any?,
					   queue: OperationQueue? = .main,
					   perform: @escaping (_ notification: Notification) -> Void) -> ObservationObject {
		center.addObserver(forName: name, object: sender, queue: queue) { (notification) in
			perform(notification)
		}
	}
	
	/// オブザーバを登録 (Selector)
	class func receive(_ name: Notification.Name,
					   center: NotificationCenter = .default,
					   sender: Any?,
					   observer: Any,
					   selector: Selector) {
		center.addObserver(observer, selector: selector, name: name, object: sender)
	}
	
	/// オブザーバ削除
	class func remove(_ observer: Any,
					  name: Notification.Name,
					  center: NotificationCenter = .default,
					  sender: Any?) {
		center.removeObserver(observer, name: name, object: sender)
	}
	
	/// オブザーバ削除
	class func remove(_ observer: ObservationObject, center: NotificationCenter = .default) {
		center.removeObserver(observer)
	}
	
}

extension Notification {
	
	/// userInfo辞書から値を取り出す
	func userInfoObject<T>(for key: String) -> T? {
		userInfo?[key] as? T
	}
	
}

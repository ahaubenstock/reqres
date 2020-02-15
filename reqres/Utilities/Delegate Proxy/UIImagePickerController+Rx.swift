//
//  UIImagePickerController+Rx.swift
//  reqres
//
//  Created by Adam E. Haubenstock on 2/15/20.
//  Copyright © 2020 Adam E. Haubenstock. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UIImagePickerControllerDelegateProxy
: DelegateProxy<UIImagePickerController, UIImagePickerControllerDelegate & UINavigationControllerDelegate>
, DelegateProxyType
, UIImagePickerControllerDelegate
, UINavigationControllerDelegate {
	init(parentObject: UIImagePickerController) {
		super.init(parentObject: parentObject, delegateProxy: UIImagePickerControllerDelegateProxy.self)
	}
	
	static func registerKnownImplementations() {
		register { UIImagePickerControllerDelegateProxy(parentObject: $0) }
	}
	
	static func currentDelegate(for object: UIImagePickerController) -> (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? {
		return object.delegate
	}
	
	static func setCurrentDelegate(_ delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?, to object: UIImagePickerController) {
		object.delegate = delegate
	}
}

extension Reactive where Base: UIImagePickerController {
	var _delegate: UIImagePickerControllerDelegateProxy {
		return UIImagePickerControllerDelegateProxy.proxy(for: base)
	}
	
	var didCancel: Observable<Void> {
		return _delegate.methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
			.map { _ in }
	}
	
	var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey: Any]> {
		return _delegate.methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
			.map { $0[1] as! [UIImagePickerController.InfoKey: Any] }
	}
}

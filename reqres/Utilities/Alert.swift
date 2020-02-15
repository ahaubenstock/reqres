//
//  Alert.swift
//  reqres
//
//  Created by Adam E. Haubenstock on 2/14/20.
//  Copyright © 2020 Adam E. Haubenstock. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let errorSink = AnyObserver<Error> { event in
	if let error = event.element {
		let alert = UIAlertController(title: "error", message: error.localizedDescription, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
		DispatchQueue.main.async {
			topViewController().present(alert, animated: true, completion: nil)
		}
	}
}

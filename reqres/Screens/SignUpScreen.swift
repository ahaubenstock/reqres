//
//  SignUpScreen.swift
//  reqres
//
//  Created by Adam E. Haubenstock on 2/14/20.
//  Copyright © 2020 Adam E. Haubenstock. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpScreen: Screen {
    static func addLogic(to component: SignUpComponent, input: Void, observer: AnyObserver<String>) -> [Disposable] {
		let cancel = component.cancelButton.rx.tap
			.bind(onNext: observer.onCompleted)
		let response = component.submitButton.rx.tap
			.withLatestFrom(Observable.combineLatest(
				component.emailField.rx.text.orEmpty,
				component.passwordField.rx.text.orEmpty
			))
			.flatMap {
				apiResponse(from: .signUp(email: $0, password: $1))
				.materialize()
		}
		.share()
		let success = response
			.compactMap { $0.element }
			.bind(onNext: {
				observer.onNext($0.token)
				observer.onCompleted()
			})
		let error = response
			.compactMap { $0.error }
			.bind(to: errorSink)
        return [
			cancel,
			success,
			error
        ]
    }
}

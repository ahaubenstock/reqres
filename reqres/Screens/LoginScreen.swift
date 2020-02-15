//
//  LoginScreen.swift
//  reqres
//
//  Created by Adam E. Haubenstock on 2/14/20.
//  Copyright © 2020 Adam E. Haubenstock. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginScreen: Screen {
    static func addLogic(to component: LoginComponent, input: Void, observer: AnyObserver<Void>) -> [Disposable] {
		let loginResponse = component.submitButton.rx.tap
			.withLatestFrom(Observable.combineLatest(
				component.emailField.rx.text.orEmpty,
				component.passwordField.rx.text.orEmpty
			))
			.flatMap {
				apiResponse(from: .login(email: $0.0, password: $0.1))
				.materialize()
		}
		.share()
		let loginError = loginResponse
			.compactMap { $0.error }
			.bind(to: errorSink)
		let loginSuccess = loginResponse
			.compactMap { $0.element }
			.map { $0.token }
		let signUp = component.signUpButton.rx.tap
		.flatMap(use(SignUpScreen.self, from: component))
		let session = Observable.merge(loginSuccess, signUp)
			.map { Session(token: $0) }
			.bind(to: store.session)
		let enter = store.session
			.filter { $0 != nil }
			.map { _ in }
			.bind(onNext: route(to: UserListScreen.self, from: component))
        return [
			loginError,
			session,
			enter
        ]
    }
}

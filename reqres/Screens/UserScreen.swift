//
//  UserScreen.swift
//  reqres
//
//  Created by Adam E. Haubenstock on 2/15/20.
//  Copyright © 2020 Adam E. Haubenstock. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class UserScreen: Screen {
    static func addLogic(to component: UserComponent, input: User, observer: AnyObserver<Void>) -> [Disposable] {
		let state = BehaviorSubject(value: State.viewing)
		let firstName = BehaviorSubject(value: input.firstName)
		let lastName = BehaviorSubject(value: input.lastName)
		let email = BehaviorSubject(value: input.email)
		let image = BehaviorSubject<UIImage?>(value: nil)
		let bindNameLabelText = firstName
			.bind(to: component.nameLabel.rx.text)
		let bindAvatarImageViewImage = image
			.bind(to: component.avatarImageView.rx.image)
		let bindEditImageViewHidden = state
			.map { $0 != .editing }
			.bind(to: component.editImageView.rx.isHidden)
		let bindEditImageButtonEnabled = state
			.map { $0 == .editing }
			.bind(to: component.editImageButton.rx.isEnabled)
		let bindFirstNameFieldText = firstName
			.bind(to: component.firstNameField.rx.text)
		let bindFirstNameFieldBackgroundViewHidden = state
			.map { $0 != .editing }
			.bind(to: component.firstNameFieldBackgroundView.rx.isHidden)
		let bindFirstNameFieldEnabled = state
			.map { $0 == .editing }
			.bind(to: component.firstNameField.rx.isEnabled)
		let bindFirstNameFieldAlignment = state
			.map { $0 == .editing }
			.map { $0 ? NSTextAlignment.left : .right }
			.bind(onNext: { [weak field = component.firstNameField] in field?.textAlignment = $0 })
		let bindLastNameFieldText = lastName
			.bind(to: component.lastNameField.rx.text)
		let bindLastNameFieldBackgroundViewHidden = state
			.map { $0 != .editing }
			.bind(to: component.lastNameFieldBackgroundView.rx.isHidden)
		let bindLastNameFieldEnabled = state
			.map { $0 == .editing }
			.bind(to: component.lastNameField.rx.isEnabled)
		let bindEmailFieldText = email
			.bind(to: component.emailField.rx.text)
		let bindEmailFieldBackgroundViewHidden = state
			.map { $0 != .editing }
			.bind(to: component.emailFieldBackgroundView.rx.isHidden)
		let bindEmailFieldEnabled = state
			.map { $0 == .editing }
			.bind(to: component.emailField.rx.isEnabled)
		let bindEmailFieldAlignment = state
			.map { $0 == .editing }
			.map { $0 ? NSTextAlignment.left : .center }
			.bind(onNext: { [weak field = component.emailField] in field?.textAlignment = $0 })
		let bindSubmitButtonHidden = state
			.map { $0 != .editing }
			.bind(to: component.submitButton.rx.isHidden)
		let bindEditButtonHidden = state
			.map { $0 != .viewing }
			.bind(to: component.editButton.rx.isHidden)
		let bindLoadingViewHidden = state
			.map { $0 != .waiting }
			.bind(to: component.loadingView.rx.isHidden)
		let bindFirstName = component.firstNameField.rx.text.orEmpty
			.bind(to: firstName)
		let bindLastName = component.lastNameField.rx.text.orEmpty
			.bind(to: lastName)
		let bindEmail = component.emailField.rx.text.orEmpty
			.bind(to: email)
		let chosenImage = component.editImageButton.rx.tap
			.flatMap(chooseImage)
			.share()
		let bindImage = Observable.merge(
			getImage(from: input.avatar).takeUntil(chosenImage),
			chosenImage
		)
		.map { Optional.some($0) }
		.bind(to: image)
		let upload = component.submitButton.rx.tap
			.flatMap {
				Observable.just(APIError(message: "update failed"))
					.delay(.seconds(Int.random(in: 1...5)), scheduler: MainScheduler.instance)
					.map { if Bool.random() { throw $0 } }
					.materialize()
		}
		.share()
		let bindUploadError = upload
			.compactMap { $0.error }
			.bind(to: errorSink)
		let bindState = Observable.merge(
			component.submitButton.rx.tap.map { State.waiting },
			component.editButton.rx.tap.map { State.editing }
		)
			.bind(to: state)
		let bindComplete = Observable.merge(
			upload.filter { $0.isCompleted }.map { _ in },
			component.cancelButton.rx.tap.asObservable()
		)
			.bind(onNext: observer.onCompleted)
        return [
			bindNameLabelText,
			bindAvatarImageViewImage,
			bindEditImageViewHidden,
			bindEditImageButtonEnabled,
			bindFirstNameFieldText,
			bindFirstNameFieldBackgroundViewHidden,
			bindFirstNameFieldEnabled,
			bindFirstNameFieldAlignment,
			bindLastNameFieldText,
			bindLastNameFieldBackgroundViewHidden,
			bindLastNameFieldEnabled,
			bindEmailFieldText,
			bindEmailFieldBackgroundViewHidden,
			bindEmailFieldEnabled,
			bindEmailFieldAlignment,
			bindSubmitButtonHidden,
			bindEditButtonHidden,
			bindLoadingViewHidden,
			bindFirstName,
			bindLastName,
			bindEmail,
			bindImage,
			bindUploadError,
			bindState,
			bindComplete
        ]
    }
}

private enum State {
	case viewing
	case editing
	case waiting
}

private func chooseImage() -> Observable<UIImage> {
	let imagePickerController = UIImagePickerController()
	topViewController().present(imagePickerController, animated: true, completion: nil)
	return Observable.merge(
		imagePickerController.rx.didCancel.map { Optional<UIImage>.none },
		imagePickerController.rx.didFinishPickingMediaWithInfo
			.map { $0[.originalImage] as? UIImage }
	)
		.take(1)
		.compactMap { $0 }
		.do(onCompleted: {
			DispatchQueue.main.async {
				imagePickerController.dismiss(animated: true, completion: nil)
			}
		})
}

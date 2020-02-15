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
		let cancel = component.cancelButton.rx.tap
			.bind(onNext: observer.onCompleted)
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
		let bindFirstNameFieldText = firstName
			.bind(to: component.firstNameField.rx.text)
		let bindFirstNameFieldBackgroundViewHidden = state
			.map { $0 != .editing }
			.bind(to: component.firstNameFieldBackgroundView.rx.isHidden)
		let bindLastNameFieldText = lastName
			.bind(to: component.lastNameField.rx.text)
		let bindLastNameFieldBackgroundViewHidden = state
			.map { $0 != .editing }
			.bind(to: component.lastNameFieldBackgroundView.rx.isHidden)
		let bindEmailFieldText = email
			.bind(to: component.emailField.rx.text)
		let bindEmailFieldBackgroundViewHidden = state
			.map { $0 != .editing }
			.bind(to: component.emailFieldBackgroundView.rx.isHidden)
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
		enum ImageSource {
			case input
			case choose
		}
		let bindImage = Observable.merge(
			Observable.just(ImageSource.input),
			component.editImageButton.rx.tap.map { ImageSource.choose }
		)
			.flatMapLatest { (source: ImageSource) -> Observable<UIImage> in
				switch source {
				case .input:
					return getImage(from: input.avatar)
				case .choose:
					return chooseImage()
				}
		}
		.map { Optional.some($0) }
		.bind(to: image)
        return [
			cancel,
			bindNameLabelText,
			bindAvatarImageViewImage,
			bindEditImageViewHidden,
			bindFirstNameFieldText,
			bindFirstNameFieldBackgroundViewHidden,
			bindLastNameFieldText,
			bindLastNameFieldBackgroundViewHidden,
			bindEmailFieldText,
			bindEmailFieldBackgroundViewHidden,
			bindSubmitButtonHidden,
			bindEditButtonHidden,
			bindLoadingViewHidden,
			bindFirstName,
			bindLastName,
			bindEmail,
			bindImage
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
//	_ = imagePickerController.rx.didCancel
//		.take(1)
//		.bind(onNext: { imagePickerController.dismiss(animated: true, completion: nil) })
	return imagePickerController.rx.didFinishPickingMediaWithInfo
		.map { $0[.originalImage] as! UIImage }
}

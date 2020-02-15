//
//  UserListCell.swift
//  reqres
//
//  Created by Adam E. Haubenstock on 2/15/20.
//  Copyright © 2020 Adam E. Haubenstock. All rights reserved.
//

import UIKit
import RxSwift

class UserListCell: UITableViewCell {
	@IBOutlet weak var userImageView: UIImageView! {
		didSet {
			_ = imageURL
				.flatMapLatest {
					getImage(from: $0)
						.map { Optional.some($0) }
						.startWith(nil)
						.materialize()
			}
			.compactMap { $0.element }
			.takeUntil(userImageView.rx.deallocated)
			.bind(to: userImageView.rx.image)
		}
	}
	@IBOutlet weak var nameLabel: UILabel!
	
	func configure(user: User) {
		imageURL.onNext(user.avatar)
		nameLabel.text = "\(user.firstName) \(user.lastName)"
	}
	
	private let imageURL = PublishSubject<String>()
}

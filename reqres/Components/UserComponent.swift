//
//  UserComponent.swift
//  reqres
//
//  Created by Adam E. Haubenstock on 2/15/20.
//  Copyright © 2020 Adam E. Haubenstock. All rights reserved.
//

import UIKit

class UserComponent: Component {
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var avatarImageView: UIImageView!
	@IBOutlet weak var editImageView: UIImageView!
	@IBOutlet weak var editImageButton: UIButton!
	@IBOutlet weak var firstNameField: UITextField!
	@IBOutlet weak var firstNameFieldBackgroundView: UIView!
	@IBOutlet weak var lastNameField: UITextField!
	@IBOutlet weak var lastNameFieldBackgroundView: UIView!
	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var emailFieldBackgroundView: UIView!
	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var loadingView: UIActivityIndicatorView!
}

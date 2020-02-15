//
//  User.swift
//  reqres
//
//  Created by Adam E. Haubenstock on 2/14/20.
//  Copyright © 2020 Adam E. Haubenstock. All rights reserved.
//

import Foundation

struct User: Codable {
	let id: Int
	let email: String
	let firstName: String
	let lastName: String
	let avatar: String
	
	enum CodingKeys: String, CodingKey {
		case id
		case email
		case firstName = "first_name"
		case lastName = "last_name"
		case avatar
	}
}

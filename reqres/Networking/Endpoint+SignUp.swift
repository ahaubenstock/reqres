//
//  Endpoint+SignUp.swift
//  reqres
//
//  Created by Adam E. Haubenstock on 2/14/20.
//  Copyright © 2020 Adam E. Haubenstock. All rights reserved.
//

import Foundation

struct SignUpResponse: Decodable {
	let id: Int
	let token: String
}

extension Endpoint where ResponseObject == SignUpResponse {
	static func signUp(email: String, password: String) -> Endpoint<ResponseObject> {
		var request = URLRequest(url: URL(string: "\(baseURL)/register")!)
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpMethod = "POST"
		let object = [
			"email": email,
			"password": password
		]
		request.httpBody = try! JSONSerialization.data(withJSONObject: object, options: [])
		return Endpoint(request: request)
	}
}

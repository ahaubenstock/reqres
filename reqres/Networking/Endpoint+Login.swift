//
//  Endpoint+Login.swift
//  reqres
//
//  Created by Adam E. Haubenstock on 2/14/20.
//  Copyright © 2020 Adam E. Haubenstock. All rights reserved.
//

import Foundation

struct LoginResponse: Decodable {
	let token: String
}

extension Endpoint where ResponseObject == LoginResponse {
	static func login(email: String, password: String) -> Endpoint<ResponseObject> {
		var request = URLRequest(url: URL(string: "\(baseURL)/login")!)
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

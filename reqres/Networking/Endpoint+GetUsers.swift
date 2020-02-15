//
//  Endpoint+GetUsers.swift
//  reqres
//
//  Created by Adam E. Haubenstock on 2/15/20.
//  Copyright © 2020 Adam E. Haubenstock. All rights reserved.
//

import Foundation

struct GetUsersResponse: Decodable {
	let id: Int
	let token: String
}

extension Endpoint where ResponseObject == GetUsersResponse {
	static func getUsers(page: Int) -> Endpoint<ResponseObject> {
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

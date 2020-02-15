//
//  Endpoint+GetUsers.swift
//  reqres
//
//  Created by Adam E. Haubenstock on 2/15/20.
//  Copyright © 2020 Adam E. Haubenstock. All rights reserved.
//

import Foundation

struct GetUsersResponse: Decodable {
	let page: Int
	let perPage: Int
	let total: Int
	let totalPages: Int
	let data: [User]
	
	enum CodingKeys: String, CodingKey {
		case page
		case perPage = "per_page"
		case total
		case totalPages = "total_pages"
		case data
	}
}

extension Endpoint where ResponseObject == GetUsersResponse {
	static func getUsers(page: Int) -> Endpoint<ResponseObject> {
		var components = baseURLComponents(withPath: "users")
		components.queryItems = [
			URLQueryItem(name: "page", value: "\(page)")
		]
		var request = URLRequest(url: components.url!)
		request.httpMethod = "GET"
		return Endpoint(request: request)
	}
}

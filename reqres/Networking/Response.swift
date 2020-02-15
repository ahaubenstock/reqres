//
//  Response.swift
//  reqres
//
//  Created by Adam E. Haubenstock on 2/14/20.
//  Copyright © 2020 Adam E. Haubenstock. All rights reserved.
//

import Foundation
import RxSwift

let baseURL = "https://reqres.in/api"

struct APIError: LocalizedError {
	init(message: String?) {
		self.message = message
	}
	
	var errorDescription: String? {
		return message?.lowercased() ?? "an unknown error occurred"
	}
	
	private let message: String?
}

func apiResponse<ResponseObject>(from endpoint: Endpoint<ResponseObject>) -> Observable<ResponseObject> {
	return URLSession.shared.rx.response(request: endpoint.request)
		.do(onNext: {
			if $0.response.statusCode < 200 || $0.response.statusCode > 299 {
				let responseObject = try? JSONSerialization.jsonObject(with: $0.data, options: []) as? [String: Any]
				throw APIError(message: responseObject?["error"] as? String)
			}
		})
		.map { try! JSONDecoder().decode(ResponseObject.self, from: $0.data) }
}

/// Will complete on any termination event but emit an image only if there is not an error during retrieval
func getImage(from url: String) -> Observable<UIImage> {
	return Observable.just(url)
		.map { URL(string: $0)! }
		.map { URLRequest(url: $0) }
		.flatMap {
			URLSession.shared.rx.data(request: $0)
				.materialize()
		}
		.compactMap { $0.element }
		.map { UIImage(data: $0)! }
}

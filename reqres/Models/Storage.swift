//
//  Storage.swift
//  reqres
//
//  Created by Adam E. Haubenstock on 2/14/20.
//  Copyright © 2020 Adam E. Haubenstock. All rights reserved.
//

import Foundation

let store = (
	_: (),
	session: storageProperty(of: Session.self, keyPath: "session")
)

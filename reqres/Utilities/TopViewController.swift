//
//  TopViewController.swift
//  reqres
//
//  Created by Adam E. Haubenstock on 2/14/20.
//  Copyright © 2020 Adam E. Haubenstock. All rights reserved.
//

import UIKit

func topViewController() -> UIViewController {
	var result = UIApplication.shared.delegate!.window!!.rootViewController!
	while let next = result.presentedViewController {
		result = next
	}
	return result
}

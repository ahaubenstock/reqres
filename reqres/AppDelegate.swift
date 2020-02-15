//
//  AppDelegate.swift
//  reqres
//
//  Created by Adam E. Haubenstock on 2/14/20.
//  Copyright © 2020 Adam E. Haubenstock. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let (component, _) = LoginScreen.create()
		let navigation = UINavigationController(rootViewController: component)
		navigation.isNavigationBarHidden = true
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = navigation
		window?.makeKeyAndVisible()
		#if DEBUG
		_ = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
			.map { _ in RxSwift.Resources.total }
			.distinctUntilChanged()
			.subscribe(onNext: {
				print("♦️ resource count: \($0)")
			})
		#endif
		return true
	}
}


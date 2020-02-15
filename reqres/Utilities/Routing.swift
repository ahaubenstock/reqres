//
//  Routing.swift
//  sandbox
//
//  Created by Adam E. Haubenstock on 2/7/20.
//  Copyright © 2020 Adam E. Haubenstock. All rights reserved.
//

import UIKit
import RxSwift

func route<T: Screen>(to screen: T.Type, from component: Component) -> (T.Input) -> Void where T.Output == Void {
    return { [unowned component] input in
        let navigation = component.navigationController!
        let (_component, output) = screen.create(input: input)
        DispatchQueue.main.async { navigation.pushViewController(_component, animated: true) }
        _ = output
			.observeOn(MainScheduler.instance)
            .subscribe(onCompleted: { navigation.popViewController(animated: true) })
    }
}

func use<T: Screen>(_ screen: T.Type, from component: Component) -> (T.Input) -> Observable<T.Output> {
    return { [unowned component] input in
        let (_component, output) = screen.create(input: input)
        DispatchQueue.main.async { component.present(_component, animated: true, completion: nil) }
        _ = output
			.observeOn(MainScheduler.instance)
			.subscribe(onCompleted: { component.dismiss(animated: true, completion: nil) })
        return output
    }
}

protocol Flow: Screen {
    static func flow<T: Screen>(to screen: T.Type, from component: Component) -> (T.Input) -> Observable<T.Output>
}
extension Flow {
    static func flow<T: Screen>(to screen: T.Type, from component: Component) -> (T.Input) -> Observable<T.Output> {
        return { [unowned component] input in
            let navigation = component.navigationController!
            let (_component, output) = screen.create(input: input)
            DispatchQueue.main.async { navigation.pushViewController(_component, animated: true) }
            let events = output.materialize()
            let next = events.compactMap { $0.element }
            let complete = events.filter { $0.isCompleted }
            _ = complete
                .takeUntil(next)
				.observeOn(MainScheduler.instance)
                .bind(onNext: { _ in navigation.popViewController(animated: true) })
            return output
        }
    }
}
func use<T: Flow>(_ flow: T.Type, from component: Component) -> (T.Input) -> Observable<T.Output> {
    return { [unowned component] input in
        let (_component, output) = flow.create(input: input)
        let navigation = UINavigationController(rootViewController: _component)
        navigation.isNavigationBarHidden = true
        DispatchQueue.main.async { component.present(navigation, animated: true, completion: nil) }
        _ = output
			.observeOn(MainScheduler.instance)
            .subscribe(onCompleted: { component.dismiss(animated: true, completion: nil) })
        return output
    }
}

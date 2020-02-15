//
//  Screen.swift
//  sandbox
//
//  Created by Adam E. Haubenstock on 2/7/20.
//  Copyright © 2020 Adam E. Haubenstock. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

typealias Component = UIViewController

protocol Screen: class {
    associatedtype Input
    associatedtype Output
    associatedtype ComponentType: Component
    static func create(input: Input) -> (Component, Observable<Output>)
    static func addLogic(to component: ComponentType, input: Input, observer: AnyObserver<Output>) -> [Disposable]
}
extension Screen {
    static func create(input: Input) -> (Component, Observable<Output>) {
        let component = UIStoryboard(name: String(describing: Self.ComponentType.self), bundle: nil).instantiateInitialViewController() as! ComponentType
        component.loadViewIfNeeded()
        let subject = PublishSubject<Output>()
        let disposables = addLogic(to: component, input: input, observer: subject.asObserver())
        _ = component.rx.deallocated
            .bind(onNext: { disposables.forEach { $0.dispose() } })
        _ = subject
            .materialize()
            .filter { $0.isCompleted }
            .flatMap { _ in Observable<Int>.timer(.seconds(2), scheduler: MainScheduler.instance) }
            .takeUntil(component.rx.deallocated)
            .bind(onNext: { _ in
                print("⚠️ `\(String(describing: Self.ComponentType.self))` – not released")
            })
        return (component, subject)
    }
}
extension Screen where Input == Void {
    static func create() -> (Component, Observable<Output>) {
        return create(input: ())
    }
}

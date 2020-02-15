//
//  Storage.swift
//  reqres
//
//  Created by Adam E. Haubenstock on 2/14/20.
//  Copyright © 2020 Adam E. Haubenstock. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct StorageProperty<PropertyType: Codable>: ObservableType, ObserverType {
	typealias Element = PropertyType?
		
    let _values: Observable<Element>
    let _valueSink: AnyObserver<Element>

    public init<Values: ObservableType, Sink: ObserverType>(values: Values, valueSink: Sink) where Element == Values.Element, Element == Sink.Element {
		_values = values.asObservable()
        _valueSink = valueSink.asObserver()
    }

    public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
		return _values.subscribe(observer)
    }

    public func asObservable() -> Observable<Element> {
        return _values
    }

    public func on(_ event: Event<Element>) {
		_valueSink.on(event)
    }
}

func storageProperty<T: Codable>(of _type: T.Type, keyPath: String) -> StorageProperty<T> {
	return StorageProperty(
		values: UserDefaults.standard.rx.observe(Data.self, keyPath)
			.map {
				if let data = $0 {
					return try! JSONDecoder().decode(_type, from: data)
				}
				return nil
			}
		.share(replay: 1),
		valueSink: Binder(UserDefaults.standard.rx.base) { defaults, element in
			if let element = element {
				let data = try! JSONEncoder().encode(element)
				defaults.set(data, forKey: keyPath)
			} else {
				defaults.set(nil, forKey: keyPath)
			}
		}
	)
}

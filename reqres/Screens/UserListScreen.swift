//
//  UserListScreen.swift
//  reqres
//
//  Created by Adam E. Haubenstock on 2/15/20.
//  Copyright © 2020 Adam E. Haubenstock. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class UserListScreen: Screen {
    static func addLogic(to component: UserListComponent, input: Void, observer: AnyObserver<Void>) -> [Disposable] {
		let users = BehaviorSubject(value: [] as [User])
		let bindTableViewCells = users.bind(to: component.tableView.rx.items(cellIdentifier: "Cell", cellType: UserListCell.self)) { _, element, cell in
			cell.configure(user: element)
		}
		let bindUsers = Observable.just(1)
			.flatMapLatest {
				apiResponse(from: .getUsers(page: $0))
				.materialize()
		}
		.compactMap { $0.element }
		.map { $0.data }
		.bind(to: users)
		let bindSelect = component.tableView.rx.itemSelected
			.map { $0.row }
			.withLatestFrom(users) { $1[$0] }
			.bind(onNext: route(to: UserScreen.self, from: component))
        return [
			bindTableViewCells,
			bindUsers,
			bindSelect
        ]
    }
}

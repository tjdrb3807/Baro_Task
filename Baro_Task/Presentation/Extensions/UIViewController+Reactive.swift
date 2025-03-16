//
//  UIViewController+Reactive.swift
//  Baro_Task
//
//  Created by 전성규 on 3/16/25.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var viewWillAppear: Observable<Void> {
        methodInvoked(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in }
    }
}

//
//  UITextField+Reactive.swift
//  Baro_Task
//
//  Created by 전성규 on 3/15/25.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITextField {
    var textOnEditingDidBegin: Observable<String> {
        base.rx.controlEvent(.editingDidBegin)
            .withLatestFrom(base.rx.text.orEmpty)
    }
    
    var textOnEditingDidEnd: Observable<String> {
        base.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(base.rx.text.orEmpty)
    }
}


//
//  MainViewModel.swift
//  Baro_Task
//
//  Created by 전성규 on 3/14/25.
//

import Foundation
import RxSwift
import RxRelay

final class MainViewModel: ViewModelType {
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        Output()
    }
}

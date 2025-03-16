//
//  LoginViewModel.swift
//  Baro_Task
//
//  Created by 전성규 on 3/14/25.
//

import Foundation
import RxSwift
import RxRelay

final class LoginViewModel: ViewModelType {
    struct Input {
        let startButtonTap: Observable<Void>
    }
    
    struct Output {
        let navigateToScreen: Observable<Bool>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let navigateToScreen = input.startButtonTap
            .map { _ in
                let userID = UserDefaults.standard.string(forKey: "loggedInUserId")
                
                return userID != nil
            }
            
        return Output(navigateToScreen: navigateToScreen)
    }
}

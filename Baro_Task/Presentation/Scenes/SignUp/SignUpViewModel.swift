//
//  SignUpViewModel.swift
//  Baro_Task
//
//  Created by 전성규 on 3/14/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModelType {
    struct Input {
        let idEditingDidBegin: Observable<String>
        let idEditingDidEnd: Observable<String>
        let passwordEditingDidBegin: Observable<String>
        let passwordEditingDidEnd: Observable<String>
        let confirmPasswordEditingDidEnd: Observable<String>
        let nicknameEditingDidEnd: Observable<String>
        let signUpButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let shouldClearIDText: Driver<Bool>
        let isIDValid: Driver<Bool>
        let shouldClearPasswordText: Driver<Bool>
        let isPasswordValid: Driver<Bool>
        let isConfirmPasswordValid: Driver<Bool>
        let isSignUpEnabled: Driver<Bool>
        let signUpResult: Driver<Bool>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let shouldClearIDText = input.idEditingDidBegin
            .map { !$0.isEmpty && !ValidationService.isValidID($0) }
            .asDriver(onErrorJustReturn: false)
        
        let isIDValid = input.idEditingDidEnd
            .map { ValidationService.isValidID($0) }
            .asDriver(onErrorJustReturn: false)
        
        let shouldClearPasswordText = input.passwordEditingDidBegin
            .map { !$0.isEmpty && !ValidationService.isValidPassword($0) }
            .asDriver(onErrorJustReturn: false)
        
        let isPasswordValid = input.passwordEditingDidEnd
            .map { ValidationService.isValidPassword($0) }
            .asDriver(onErrorJustReturn: false)
        
        let isConfirmPasswordValid = Observable
            .combineLatest(
                input.passwordEditingDidEnd,
                input.confirmPasswordEditingDidEnd
            ).map { password, confirmPassword in
                password == confirmPassword && ValidationService.isValidPassword(confirmPassword)
            }.asDriver(onErrorJustReturn: false)
        
        let isNicknameValid = input.nicknameEditingDidEnd
            .map { !$0.isEmpty }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
        
        let isSignUpEnabled = Driver
            .combineLatest(
                isIDValid,
                isPasswordValid,
                isConfirmPasswordValid,
                isNicknameValid
            ) { $0 && $1 && $2 && $3 }

        let signUpResult = input.signUpButtonDidTap
            .withLatestFrom(Observable.combineLatest(
                input.idEditingDidEnd,
                input.confirmPasswordEditingDidEnd,
                input.nicknameEditingDidEnd
            )).flatMapLatest { id, password, nickname -> Observable<Bool> in
                let result = CoreDataManager.shared.saveUser(id: id, password: password, nickname: nickname)
                
                if result {
                    LoginManager.saveLoginSession(id: id, nickname: nickname)
                }
                
                return Observable.just(result)
            }.asDriver(onErrorJustReturn: false)
            
        return Output(
            shouldClearIDText: shouldClearIDText,
            isIDValid: isIDValid,
            shouldClearPasswordText: shouldClearPasswordText,
            isPasswordValid: isPasswordValid,
            isConfirmPasswordValid: isConfirmPasswordValid,
            isSignUpEnabled: isSignUpEnabled,
            signUpResult: signUpResult
        )
    }
}

//
//  MainViewModel.swift
//  Baro_Task
//
//  Created by 전성규 on 3/14/25.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel: ViewModelType {
    struct Input {
        let viewWillAppear: Observable<Void>
        let withdrawalButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let loggedInUserNickname: Driver<String>
        let withdrawalCompletd: Signal<Void>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let loggedInUserNickname = input.viewWillAppear
            .take(1)
            .compactMap { LoginManager.getLoggedInUserNickname() }
            .asDriver(onErrorDriveWith: .empty())
        
        let withdrawalComplete = PublishSubject<Void>()
        
        input.withdrawalButtonDidTap
            .flatMapLatest { _ -> Observable<Void> in
                self.withdrawUser()
            }.bind(to: withdrawalComplete)
            .disposed(by: disposeBag)
            
        return Output(
            loggedInUserNickname: loggedInUserNickname,
            withdrawalCompletd: withdrawalComplete.asSignal(onErrorSignalWith: .empty()))
    }
}

extension MainViewModel {
    private func withdrawUser() -> Observable<Void> {
        Observable.create { observer in
            CoreDataManager.shared.deleteUser(id: LoginManager.getLoggedInUserID() ?? "")
            
            LoginManager.clearLoginSession()
            
            observer.onNext(())
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}

//
//  LoginViewController.swift
//  Baro_Task
//
//  Created by 전성규 on 3/14/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LoginViewController: BaseViewController {
    let viewModel: LoginViewModel
    
    private let startButton = CustomButton(type: .start)
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        let input = LoginViewModel.Input(startButtonTap: startButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output
            .navigateToScreen
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, isLoggedIn in
                vc.navigate(
                    to: isLoggedIn ?
                    MainViewController(viewModel: MainViewModel()) : SignUpViewController(viewModel: SignUpViewModel()))
            }).disposed(by: disposeBag)
    }
    
    override func configureViews() {
        super.configureViews()
        
        [startButton].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        startButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50.0)
        }
    }
    
    private func navigate(to viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

@available(iOS 17.0, *)
#Preview {
    LoginViewController(viewModel: LoginViewModel())
}

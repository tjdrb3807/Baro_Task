//
//  MainViewController.swift
//  Baro_Task
//
//  Created by 전성규 on 3/14/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class MainViewController: BaseViewController {
    let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private let buttonHStckView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 20.0
        
        return stackView
    }()
    
    private let logOutButton = CustomTextButton(type: .logOut)
    private let withdrawalButton = CustomTextButton(type: .withdrawal)
    
    override func bind() {
        let input = MainViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            withdrawalButtonDidTap: withdrawalButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.loggedInUserNickname
            .map { "\($0)님 환영합니다." }
            .drive(nickNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        Observable
            .merge(logOutButton.rx.tap.asObservable(),
                   output.withdrawalCompletd.asObservable())
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                let LoginViewModel = LoginViewModel()
                let LoginViewController = LoginViewController(viewModel: LoginViewModel)
                
                vc.navigationController?.setViewControllers([LoginViewController], animated: false)
            }).disposed(by: disposeBag)
    }
    
    override func configureViews() {
        super.configureViews()

        [nickNameLabel, buttonHStckView].forEach { view.addSubview($0) }
        
        [logOutButton, withdrawalButton].forEach { buttonHStckView.addArrangedSubview($0) }
    }
    
    override func configureConstraints() {
        nickNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20.0)
        }
        
        buttonHStckView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20.0)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    MainViewController(viewModel: MainViewModel())
}

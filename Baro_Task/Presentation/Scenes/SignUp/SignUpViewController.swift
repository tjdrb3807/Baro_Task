//
//  SignUpViewController.swift
//  Baro_Task
//
//  Created by 전성규 on 3/14/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpViewController: BaseViewController {
    private let viewModel: SignUpViewModel
    
    private let headLineLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign-Up"
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 30.0, weight: .bold)
        
        return label
    }()
    
    private let contentVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20.0
        
        return stackView
    }()
    
    private let idInputView = CustomInputView(type: .identifier)
    private let passwordInputView = CustomInputView(type: .password)
    private let confirmPasswordInputView = CustomInputView(type: .confirmPassword)
    private let nicknameInputView = CustomInputView(type: .nickName)
    
    private let signUpButton = CustomButton(type: .signUp)
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        let input = SignUpViewModel.Input(
            idEditingDidBegin: idInputView.textField.rx.textOnEditingDidBegin,
            idEditingDidEnd: idInputView.textField.rx.textOnEditingDidEnd,
            passwordEditingDidBegin: passwordInputView.textField.rx.textOnEditingDidBegin,
            passwordEditingDidEnd: passwordInputView.textField.rx.textOnEditingDidEnd,
            confirmPasswordEditingDidEnd: confirmPasswordInputView.textField.rx.textOnEditingDidEnd,
            nicknameEditingDidEnd: nicknameInputView.textField.rx.text.orEmpty.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.shouldClearIDText
            .drive(onNext: { [weak self] shouldClear in
                if shouldClear { self?.idInputView.textField.text = .none }
            }).disposed(by: disposeBag)
        
        output.isIDValid
            .drive(idInputView.errorMessageLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.shouldClearPasswordText
            .drive(onNext: { [weak self] shouldClear in
                if shouldClear { self?.passwordInputView.textField.text = .none }
            }).disposed(by: disposeBag)
        
        output.isPasswordValid
            .drive(passwordInputView.errorMessageLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isConfirmPasswordValid
            .drive(confirmPasswordInputView.errorMessageLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isSignUpEnabled
            .drive(onNext: { [weak self] in
                self?.signUpButton.setEnabled($0)
            }).disposed(by: disposeBag)
    }
    
    override func configureViews() {
        [headLineLabel, contentVStackView, signUpButton].forEach { view.addSubview($0) }
        
        [idInputView, passwordInputView, confirmPasswordInputView, nicknameInputView].forEach {
            contentVStackView.addArrangedSubview($0)
        }
    }
    
    override func configureConstraints() {
        headLineLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10.0)
            $0.horizontalEdges.equalToSuperview().inset(20.0)
        }
        
        contentVStackView.snp.makeConstraints {
            $0.top.equalTo(headLineLabel.snp.bottom).offset(20.0)
            $0.horizontalEdges.equalToSuperview().inset(20.0)
        }
        
        signUpButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50.0)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    SignUpViewController(viewModel: SignUpViewModel())
}

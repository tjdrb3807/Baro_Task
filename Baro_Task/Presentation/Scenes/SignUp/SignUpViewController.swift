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
    override var shouldEnableKeyboardDismiss: Bool { true }
    
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
    private var signUpButtonBottomConstraint: Constraint?
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.bindKeyboardChanges()
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
        super.configureViews()
        
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
            signUpButtonBottomConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide).constraint
            $0.height.equalTo(50.0)
        }
    }
    
    /// 키보드 높이에 따라 signUpButton 위치 조정
    private func bindKeyboardChanges() {
        // 키보드가 올라올 때
        let keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .compactMap { notification -> CGFloat? in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return nil }
                return keyboardFrame.height
            }
        
        // 키보드가 내려올 때
        let keyboardWillHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        // 키보드 높이 값 감지 및 UI 업데이트
        Observable.merge(keyboardWillShow, keyboardWillHide)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                
                let isKeyboardVisible = keyboardHeight > 0
                let safeAreaBottom = self.view.safeAreaInsets.bottom
                
                // 키보드 높이에서 Safe Area 높이를 빼줘서 정확한 위치로 조정
                let adjustedKeyboardHeight = max(keyboardHeight - safeAreaBottom, 0)
                
                self.signUpButton.snp.updateConstraints {
                    $0.horizontalEdges.equalToSuperview().inset(isKeyboardVisible ? 0 : 20.0)
                    self.signUpButtonBottomConstraint?.update(offset: isKeyboardVisible ? -adjustedKeyboardHeight : 0)
                }
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.signUpButton.layer.cornerRadius = isKeyboardVisible ? 0 : 8.0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }).disposed(by: disposeBag)
    }
}

@available(iOS 17.0, *)
#Preview {
    SignUpViewController(viewModel: SignUpViewModel())
}

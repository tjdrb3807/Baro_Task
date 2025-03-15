//
//  CustomInputView.swift
//  Baro_Task
//
//  Created by 전성규 on 3/14/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

enum CustomInputViewType {
    case identifier
    case password
    case confirmPassword
    case nickName
}

final class CustomInputView: UIStackView {
    private let type: CustomInputViewType
    private let textFieldBottomBorder = CALayer()
    private let disposeBag = DisposeBag()
    
    private lazy var titleLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .semibold)

        switch type {
        case .identifier:
            label.text = "ID＊"
        case .password:
            label.text = "Password＊"
        case .confirmPassword:
            label.text = "Check password＊"
        case .nickName:
            label.text = "Nickname＊"
        }
        
        label.setTitleLabelColor()
        
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        textFieldBottomBorder.backgroundColor = UIColor.lightGray.cgColor
        textField.layer.addSublayer(textFieldBottomBorder)
        
        switch type {
        case .identifier:
            textField.placeholder = "아이디를 입력해주세요."
        case .password:
            textField.placeholder = "비밀번호를 입력해주세요. (최소 8자 이상)"
            textField.isSecureTextEntry = true
        case .confirmPassword:
            textField.placeholder = "비밀번호 확인을 입력해주세요."
            textField.isSecureTextEntry = true
        case .nickName:
            textField.placeholder = "닉네임을 입력해주세요."
        }
        
        return textField
    }()
    
    lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        label.numberOfLines = 0
        label.textColor = .red
        label.isHidden = true
        
        switch type {
        case .identifier:
            label.text = "아이디는 이메일 형식이어야 하며, '@' 이전에는 영문 소문자(a-z)와 숫자(0-9)만 사용할 수 있습니다. 또한, 최소 6자 이상 20자 이하로 입력해야 하며, 숫자로 시작할 수 없습니다. (예: abc@gmail.com)"
        case .password:
            label.text = "비밀번호는 최소 8자 이상이어야 하며, 영문 대문자(A-Z), 영문 소문자(a-z), 숫자(0-9), 특수문자(!@#$%^&*)를 각각 최소 1개 이상 포함해야 합니다."
        case .confirmPassword:
            label.text = "비밀번호가 일치하지 않습니다."
        case .nickName:
            break
        }
        
        return label
    }()
    
    init(type: CustomInputViewType) {
        self.type = type
        super.init(frame: .zero)
        
        self.bindEditing()
        self.configureProperties()
        self.configureViews()
        self.configureConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textFieldBottomBorder.frame = CGRect(
            x: 0.0,
            y: textField.bounds.height - 1.0, // textField의 하단에 배치
            width: textField.bounds.width,
            height: 1.0)
    }
    
    private func bindEditing() {
        textField.rx.controlEvent(.editingDidBegin)
            .map { _ in UIColor.systemBlue.cgColor }
            .bind(to: textFieldBottomBorder.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidEnd)
            .map { _ in UIColor.lightGray.cgColor }
            .bind(to: textFieldBottomBorder.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    
    private func configureProperties() {
        axis = .vertical
        distribution = .equalSpacing
        spacing = 5.0
    }
    
    private func configureViews() {
        [titleLable, textField, errorMessageLabel].forEach { addArrangedSubview($0) }
    }
    
    private func configureConstraints() {
        textField.snp.makeConstraints { $0.height.equalTo(30.0) }
    }
}

#if DEBUG

@available(iOS 17.0, *)
#Preview {
    let containerViewController = UIViewController()
    let customInputView = CustomInputView(type: .identifier)
    
    containerViewController.view.addSubview(customInputView)
    customInputView.snp.makeConstraints {
        $0.horizontalEdges.equalToSuperview().inset(20.0)
        $0.centerY.equalToSuperview()
    }
    
    return containerViewController
}

#endif

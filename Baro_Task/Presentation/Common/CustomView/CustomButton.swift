//
//  CustomButton.swift
//  Baro_Task
//
//  Created by 전성규 on 3/14/25.
//

import UIKit
import RxSwift
import RxCocoa

// CustomButton의 종류를 정의하는 enum
enum CustomButtonType: String {
    case start = "시작하기"
    case signUp = "가입하기"
    case logOut = "로그아웃"
}

final class CustomButton: UIButton {
    private let type: CustomButtonType
    private let disposeBag = DisposeBag()
    
    /// 버튼의 활성화 상태를 관리하는 Relay
    private let isEnabledRelay: BehaviorRelay<Bool>
    
    /// CustomButton 초기화
    /// - Parameter type: CustomButtonType을 받아 버튼의 속성을 설정
    init(type: CustomButtonType) {
        self.type = type
        let initialState = (type == .signUp) ? false : true // signUp 버튼은 초기 비활성화
        isEnabledRelay = BehaviorRelay<Bool>(value: initialState)
        super.init(frame: .zero)
        
        self.configureProperties()
        self.bindState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureProperties() {
        setTitle(type.rawValue, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        layer.cornerRadius = 12.0
    }
    
    private func bindState() {
        isEnabledRelay
            .bind(to: rx.isEnabled)
            .disposed(by: disposeBag)
        
        isEnabledRelay
            .map { $0 ? UIColor.systemBlue :  UIColor.lightGray }
            .bind(to: rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    
    /// 버튼의 활성화 상태를 변경하는 메서드
    /// - Parameter enabled: 활성화 여부
    func setEnabled(_ enabled: Bool) {
        guard isEnabledRelay.value != enabled else { return }   // 중복 방지
        isEnabledRelay.accept(enabled)
    }
}

#if DEBUG

import SnapKit

@available(iOS 17.0, *)
#Preview {
    let containerViewController = UIViewController()
    let customButton = CustomButton(type: .start)
    
    containerViewController.view.addSubview(customButton)
    customButton.snp.makeConstraints {
        $0.horizontalEdges.equalToSuperview().inset(20.0)
        $0.bottom.equalTo(containerViewController.view.safeAreaLayoutGuide)
        $0.height.equalTo(50.0)
    }
    
    return containerViewController
}

#endif

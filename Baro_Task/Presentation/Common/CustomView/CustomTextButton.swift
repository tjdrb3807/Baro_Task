//
//  CustomTextButton.swift
//  Baro_Task
//
//  Created by 전성규 on 3/16/25.
//

import UIKit

enum CustomTextButtonType: String {
    case logOut = "로그아웃"
    case withdrawal = "회원 탈퇴"
}

final class CustomTextButton: UIButton {
    private let type: CustomTextButtonType
    
    init(type: CustomTextButtonType) {
        self.type = type
        super.init(frame: .zero)
        
        self.configureProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureProperties() {
        setTitle(type.rawValue, for: .normal)
        setTitleColor(.lightGray, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 15.0, weight: .regular)
    }
}

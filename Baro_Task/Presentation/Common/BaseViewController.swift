//
//  BaseViewController.swift
//  Baro_Task
//
//  Created by 전성규 on 3/14/25.
//

import UIKit
import RxSwift

/// 모든 ViewController가 상속받는 기본 뷰 컨트롤러
/// - 공통적으로 필요한 UI 설정 및 바인딩을 처리하기 위한 베이스 클래스
class BaseViewController: UIViewController {
    /// 키보드가 나타났을 때 탭 제스처로 키보드를 내리는 기능 활성화 여부
    var shouldEnableKeyboardDismiss: Bool { false }
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
        self.configureViews()
        self.configureConstraints()
        
        if shouldEnableKeyboardDismiss { bindKeyboardDismiss() }
    }
    
    /// ViewModel과 데이터 바인딩을 설정하는 메서드
    func bind() { }
    
    /// 서브 뷰를 추가하고 초기 UI 설정하는 메서드
    func configureViews() { }
    
    /// AutoLayout을 설정하는 메서드
    func configureConstraints() { }
}

// MARK: - 키보드 해제 기능 (화면 탭 시 키보드 내리기)
extension BaseViewController {
    /// 화면을 탭하면 키보드를 내리는 기능을 설정하는 메서드
    /// - shouldEnableKeyboardDismiss가 true인 경우에만 활성화됨
    private func bindKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.view.endEditing(true)
            }).disposed(by: disposeBag)
    }
}

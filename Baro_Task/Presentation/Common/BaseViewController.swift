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
final class BaseViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
        self.configureViews()
        self.configureConstraints()
    }
    
    /// ViewModel과 데이터 바인딩을 설정하는 메서드
    func bind() { }
    
    /// 서브 뷰를 추가하고 초기 UI 설정하는 메서드
    func configureViews() { }
    
    /// AutoLayout을 설정하는 메서드
    func configureConstraints() { }
}

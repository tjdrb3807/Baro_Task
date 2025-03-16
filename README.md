# Baro_Task

## 📌 프로젝트 소개
Baro_Task는 iOS 기반의 로그인 및 회원가입 기능을 포함한 기본적인 사용자 인증 프로젝트입니다. RxSwift와 MVVM 패턴을 활용하여 설계되었습니다.

## 🛠️ 기술 스택
- **언어**: Swift
- **UI 프레임워크**: UIKit
- **아키텍처**: MVVM (Model-View-ViewModel)
- **라이브러리**:
  - RxSwift & RxCocoa (비동기 데이터 바인딩)
  - SnapKit (오토레이아웃)
  - CoreData (로컬 데이터 저장)
  
## 📂 프로젝트 구조
```
Baro_Task/
├── Application/        # 앱 실행 및 초기 설정 관련 파일
├── Data/               # 데이터 관리 (CoreData)
├── Domain/             # 비즈니스 로직 (UseCase 등)
├── Presentation/       # UI 관련 코드
│   ├── Scenes/         # 각 화면별 뷰컨트롤러 및 뷰모델
│   │   ├── Login/      # 로그인 화면
│   │   ├── SignUp/     # 회원가입 화면
│   │   ├── Main/       # 메인 화면
├── Resource/           # 앱 리소스 (Assets, Storyboards 등)
└── SupportingFiles/    # 프로젝트 설정 관련 파일 (Info.plist 등)
```

## 📌 주요 기능
- **로그인 화면**
  - ID, 비밀번호 입력 후 로그인 가능
  - 로그인 여부에 따라 메인 화면 또는 회원가입 화면으로 이동
- **회원가입 화면**
  - ID 중복 체크 기능
  - 비밀번호 유효성 검사 및 확인
  - 회원가입 성공 시 자동 로그인 및 메인 화면 이동
- **메인 화면**
  - 현재 로그인한 사용자 정보 표시
  - 로그아웃 및 계정 탈퇴 기능

# 또보겠지!?
### 프로젝트 설치 및 실행 관련 가이드
1. 해당 프로젝트 경로의 터미널에서 `make bootstrap` 명령을 통해 필요한 툴 설치를 진행합니다.
(최초 툴 설치가 안되어있을때만 진행)
2. 위 과정에서 만약 누락된 설치가 있다면 터미널에서 안내해주기에 이에 따라 추가 설치합니다.
예시) npm 설치가 누락되있다면 터미널에서 "Run 'npm install' to install" 안내가 나오며, 이에 npm install명령어를 입력하여 순차적으로 진행합니다.
3. 프로젝트 경로의 터미널에서 `grunt gp` 명령을 통해 프로젝트를 생성합니다.
4. 생성된 `SeeYouAgain.xcworkspace` 파일로 실행합니다.
5. 빌드는 Dev/Prod 중 상황에 맞는 스킴으로 실행합니다.

### 개발 환경
- iOS 16.0 +
- Xcode 14.3 

### 사용 기술 및 라이브러리
- SwiftUI
- The Composable Architecture (TCA)
- TCACoordinators
- Combine / CombineExt
- Alamofire
- Nuke
- SwiftLint
- Tuist
- Fastlane

### 프로젝트 구성
총 하단과 같이 5개의 모듈화로 구성되어 있습니다.
- App: 실제 앱 실행을 위한 정보 및 사용한 Feature 모듈을 올려 앱을 실행시키는 모듈
- Core: Model, Service 및 Extension 등의 Common 영역을 담은 모듈
- DesignSystem: 앱 내 사용할 폰트, 컬러, 이미지, 아이콘 등의 에셋과 커스텀 뷰 등의 디자인 소스들을 담은 모듈
- Coordinator: Scene들의 계층을 관리하는 모듈
- Scene: 각 화면 별 타겟을 분리해 Scene 모듈을 구성하여 App 및 Scene 모듈에서 조합하여 사용 가능한 모듈

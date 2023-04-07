# 또보겠지!?🍡
### 프로젝트 설치 및 실행 관련 가이드
1. 해당 프로젝트 경로의 터미널에서 `make bootstrap` 명령을 통해 필요한 툴 설치를 진행합니다.
(최초 툴 설치가 안되어있을때만 진행)
2. 위 과정에서 만약 누락된 설치가 있다면 터미널에서 안내해주기에 이에 따라 추가 설치합니다.
예시) npm 설치가 누락되있다면 터미널에서 "Run 'npm install' to install" 안내가 나오며, 이에 npm install명령어를 입력하여 순차적으로 진행합니다.
3. 프로젝트 경로의 터미널에서 `grunt gp` 명령을 통해 프로젝트를 생성합니다.
4. 생성된 `SeeYouAgain.xcworkspace` 파일로 실행합니다.
5. 빌드는 Dev/Prod 중 상황에 맞는 스킴으로 실행합니다.
***
### 개발 환경
- iOS 16.0 +
- Xcode 14.3 
***
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
***
### 프로젝트 구성
총 하단과 같이 5개의 모듈화로 구성되어 있습니다.
- App: 실제 앱 실행을 위한 정보 및 사용한 Feature 모듈을 올려 앱을 실행시키는 모듈
- Core: Model, Service 및 Extension 등의 Common 영역을 담은 모듈
- DesignSystem: 앱 내 사용할 폰트, 컬러, 이미지, 아이콘 등의 에셋과 커스텀 뷰 등의 디자인 소스들을 담은 모듈
- Coordinator: Scene들의 계층을 관리하는 모듈
- Scene: 각 화면 별 타겟을 분리해 Scene 모듈을 구성하여 App 및 Scene 모듈에서 조합하여 사용 가능한 모듈
***
### Grunt 명령어 가이드
1. gp
  - `grunt gp`를 통해 xcworkspace 파일을 생성

2. onboarding
  - `grunt onboarding`을 통해 Personal Access Token을 입력 받아 환경변수에 저장
  - 추후 깃헙 PR 자동화 등 깃헙 권한에 필요

3. pr
  - `grunt pr`을 통해 터미널에서 PR을 보냄
  - 사전에 Personal Access Token이 필요함으로 최초 `grunt onboarding`을 통해 저장이 필요
  - 해당 명령어 실행 전 꼭 remote에 해당 branch가 push 되어 있어야 합니다.
  - 아래 스텝에 따라 PR을 작성할 수 있습니다. (예시)   

    1️⃣ PR의 Prefix를 입력해 주세요.
      - 인프라, 기능, 테스트 등등 키워드 입력

    2️⃣ PR의 제목을 입력해 주세요.
      - PR 자동화 테스트

    3️⃣ head(머지시킬) branch 이름을 입력해 주세요.
      - infra/#1 (작업한 branch를 입력합니다.)

    4️⃣ base(머지당할) branch 이름을 입력해 주세요.
      - main

    5️⃣ 해당 PR에 해당하는 Task 이름을 입력해 주세요.
      - PR 자동화 기능 추가

    6️⃣ 해당 PR에 해당하는 참고할 URL을 입력해 주세요.
      - http://green.com

    7️⃣ 해당 PR과 관련하여 참고할 사항을 입력해 주세요.
      - 말그대로 테스트입니다!
      
4. deploy-local
  - `grunt deploy-local`을 통해 터미널에서 fastlane 배포를 실행
  - main branch가 배포됩니다.
  - 버전 넘버는 지정할 수 있으나 빌드 넘버는 해당 명령어 실행 시각으로 자동화 설정 됩니다. (ex. 1.0.0 - 202304071048)
  - fastlane 배포 뿐 아니라 릴리즈 커밋을 생성하고 자동 푸쉬합니다.
  - 아래 스텝에 실행할 수 있습니다. (예시)

    1️⃣ Apple Developer 이메일을 입력해 주세요. (ex. humains@nate.com)
      - humains@nate.com

    2️⃣ bump type (no, patch, minor, major) 또는 특정 버전(1.1.0)을 입력하세요. / 현재 버전은 1.0.0 입니다.
      - patch

    3️⃣ git reset --h 명령어가 실행됩니다. 커밋되지 않은 변경사항은 모두 삭제됩니다. (y/n)
      - y
***
### 배포 가이드
1. `grunt deploy-local`을 통해 터미널에서 자동 배포
2. `fastlane beta` or `fastlane dev` or `fastlane prod`를 통해 배포
3. Xcode에서 직접 아카이빙하여 배포

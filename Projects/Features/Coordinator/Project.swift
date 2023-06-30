import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "Coordinator",
  targets: [
    .make(
      name: "AppCoordinator",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.appCoordinator",
      sources: ["AppCoordinator/**"],
      dependencies: [
        .target(name: "NewsCardCoordinator"),
        .project(target: "TabBar", path: .relativeToRoot("Projects/Features/Scene")),
        .project(target: "Splash", path: .relativeToRoot("Projects/Features/Scene")),
        .project(target: "SetCategory", path: .relativeToRoot("Projects/Features/Scene")),
        .externalsrt("TCA"),
        .externalsrt("TCACoordinators"),
      ]
    ),
    .make(
      name: "NewsCardCoordinator",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.newsCardCoordinator",
      sources: ["NewsCardCoordinator/**"],
      dependencies: [
        .project(target: "NewsList", path: .relativeToRoot("Projects/Features/Scene")),
        .project(target: "Web", path: .relativeToRoot("Projects/Features/Scene")),
        .externalsrt("TCA"),
        .externalsrt("TCACoordinators"),
      ]
    ),
    .make(
      name: "ShortStorageCoordinator",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.shortStorageCoordinator",
      sources: ["ShortStorageCoordinator/**"],
      dependencies: [
        .project(target: "ShortStorageNewsList", path: .relativeToRoot("Projects/Features/Scene")),
        .externalsrt("TCA"),
        .externalsrt("TCACoordinators"),
      ]
    ),
    .make(
      name: "LongStorageCoordinator",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.longStorageCoordinator",
      sources: ["LongStorageCoordinator/**"],
      dependencies: [
        .project(target: "LongStorageNewsList", path: .relativeToRoot("Projects/Features/Scene")),
        .project(target: "Web", path: .relativeToRoot("Projects/Features/Scene")),
        .externalsrt("TCA"),
        .externalsrt("TCACoordinators"),
      ]
    ),
    .make(
      name: "MainCoordinator",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.mainCoordinator",
      sources: ["MainCoordinator/**"],
      dependencies: [
				.target(name: "NewsCardCoordinator"),
        .project(target: "Main", path: .relativeToRoot("Projects/Features/Scene")),
        .externalsrt("TCA"),
        .externalsrt("TCACoordinators"),
      ]
    ),
    .make(
      name: "HotKeywordCoordinator",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.hotKeyword",
      sources: ["HotKeywordCoordinator/**"],
      dependencies: [
        .target(name: "NewsCardCoordinator"),
        .project(target: "HotKeyword", path: .relativeToRoot("Projects/Features/Scene")),
        .externalsrt("TCA"),
        .externalsrt("TCACoordinators"),
      ]
    ),
    .make(
      name: "MyPageCoordinator",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.myPage",
      sources: ["MyPageCoordinator/**"],
      dependencies: [
        .target(name: "ShortStorageCoordinator"),
        .target(name: "LongStorageCoordinator"),
        .target(name: "SettingCoordinator"),
        .project(target: "MyPage", path: .relativeToRoot("Projects/Features/Scene")),
        .externalsrt("TCA"),
        .externalsrt("TCACoordinators"),
      ]
    ),
    .make(
      name: "SettingCoordinator",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.setting",
      sources: ["SettingCoordinator/**"],
      dependencies: [
        .project(target: "Setting", path: .relativeToRoot("Projects/Features/Scene")),
        .externalsrt("TCA"),
        .externalsrt("TCACoordinators"),
      ]
    ),
  ]
)

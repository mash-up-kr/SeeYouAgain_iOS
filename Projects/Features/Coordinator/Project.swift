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
        .target(name: "TabBarCoordinator"),
        .target(name: "NewsCardCoordinator"),
        .target(name: "SettingCoordinator"),
        .project(target: "Splash", path: .relativeToRoot("Projects/Features/Scene")),
        .project(target: "SetCategory", path: .relativeToRoot("Projects/Features/Scene")),
        .externalsrt("TCA"),
        .externalsrt("TCACoordinators"),
      ]
    ),
    .make(
      name: "TabBarCoordinator",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.tabBarCoordinator",
      sources: ["TabBarCoordinator/**"],
      dependencies: [
        .target(name: "MainCoordinator"),
        .target(name: "HotKeywordCoordinator"),
        .target(name: "MyCoordinator"),
        .project(target: "TabBar", path: .relativeToRoot("Projects/Features/Scene")),
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
        .project(target: "ShortStorageCardList", path: .relativeToRoot("Projects/Features/Scene")),
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
        .project(target: "HotKeyword", path: .relativeToRoot("Projects/Features/Scene")),
        .project(target: "HotKeywordNewsList", path: .relativeToRoot("Projects/Features/Scene")),
        .externalsrt("TCA"),
        .externalsrt("TCACoordinators"),
      ]
    ),
    .make(
      name: "MyCoordinator",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.my",
      sources: ["MyCoordinator/**"],
      dependencies: [
        .target(name: "ShortStorageCoordinator"),
        .target(name: "LongStorageCoordinator"),
        .project(target: "My", path: .relativeToRoot("Projects/Features/Scene")),
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

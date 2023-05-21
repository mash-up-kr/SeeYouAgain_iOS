import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "Coordinator",
  targets: [
    .make(
      name: "CoordinatorKit",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.coordinatorKit",
      sources: ["CoordinatorKit/**"],
      dependencies: [
        .target(name: "AppCoordinator"),
        .target(name: "TabBarCoordinator"),
        .target(name: "NewsCardCoordinator"),
        .target(name: "ShortStorageCoordinator"),
        .target(name: "LongStorageCoordinator"),
        .target(name: "HotKeywordCoordinator"),
        .target(name: "SettingCoordinator"),
        .externalsrt("TCA"),
        .externalsrt("TCACoordinators"),
      ]
    ),
    .make(
      name: "AppCoordinator",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.appCoordinator",
      sources: ["AppCoordinator/**"],
      dependencies: [
        .target(name: "TabBarCoordinator"),
        .target(name: "NewsCardCoordinator"),
        .target(name: "ShortStorageCoordinator"),
        .target(name: "LongStorageCoordinator"),
        .target(name: "HotKeywordCoordinator"),
        .target(name: "SettingCoordinator"),
        .project(target: "Splash", path: .relativeToRoot("Projects/Features/Scene")),
        .project(target: "SetCategory", path: .relativeToRoot("Projects/Features/Scene")),
        .project(target: "Main", path: .relativeToRoot("Projects/Features/Scene")),
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

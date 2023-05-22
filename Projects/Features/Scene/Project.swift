import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "Scene",
  targets: [
    .make(
      name: "Splash",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.splash.splash",
      sources: ["SplashScene/Splash/**"],
      dependencies: [
        .project(target: "CoreKit", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
        .externalsrt("TCA"),
      ]
    ),
    .make(
      name: "SetCategory",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.setCategory.setCategory",
      sources: ["SetCategoryScene/SetCategory/**"],
      dependencies: [
        .project(target: "CoreKit", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
        .externalsrt("TCA"),
      ]
    ),
    .make(
      name: "Main",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.main.main",
      sources: ["MainScene/Main/**"],
      dependencies: [
        .project(target: "CoreKit", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
        .externalsrt("TCA"),
        .externalsrt("Nuke"),
        .externalsrt("NukeUI"),
      ]
    ),
    .make(
      name: "TabBar",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.tabBar.tabBar",
      sources: ["TabBarScene/TabBar/**"],
      dependencies: [
        .project(target: "CoreKit", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
        .externalsrt("TCA"),
        .externalsrt("Nuke"),
        .externalsrt("NukeUI"),
      ]
    ),
    .make(
      name: "MyPage",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.myPage.myPage",
      sources: ["MyPageScene/MyPage/**"],
      dependencies: [
        .project(target: "CoreKit", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
        .externalsrt("TCA"),
        .externalsrt("Nuke"),
        .externalsrt("NukeUI"),
      ]
    ),
    .make(
      name: "NewsList",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.newsCard.newsList",
      sources: ["NewsCardScene/NewsList/**"],
      dependencies: [
        .project(target: "CoreKit", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
        .externalsrt("TCA"),
        .externalsrt("Nuke"),
        .externalsrt("NukeUI"),
      ]
    ),
    .make(
      name: "ShortStorageCardList",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.shortStorage.shortStorageCardList",
      sources: ["ShortStorageScene/ShortStorageCardList/**"],
      dependencies: [
        .project(target: "CoreKit", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
        .externalsrt("TCA"),
        .externalsrt("Nuke"),
        .externalsrt("NukeUI"),
      ]
    ),
    .make(
      name: "ShortStorageNewsList",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.shortStorage.shortStorageNewsList",
      sources: ["ShortStorageScene/ShortStorageNewsList/**"],
      dependencies: [
        .project(target: "CoreKit", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
        .externalsrt("TCA"),
        .externalsrt("Nuke"),
        .externalsrt("NukeUI"),
      ]
    ),
    .make(
      name: "LongStorageNewsList",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.longStorage.longStorageNewsList",
      sources: ["LongStorageScene/LongStorageNewsList/**"],
      dependencies: [
        .project(target: "CoreKit", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
        .externalsrt("TCA"),
        .externalsrt("Nuke"),
        .externalsrt("NukeUI"),
      ]
    ),
    .make(
      name: "HotKeyword",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.hotKeyword.hotKeyword",
      sources: ["HotKeywordScene/HotKeyword/**"],
      dependencies: [
        .project(target: "CoreKit", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
        .externalsrt("TCA"),
        .externalsrt("Nuke"),
        .externalsrt("NukeUI"),
      ]
    ),
    .make(
      name: "HotKeywordNewsList",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.hotKeyword.hotKeywordNewsList",
      sources: ["HotKeywordScene/HotKeywordNewsList/**"],
      dependencies: [
        .project(target: "CoreKit", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
        .externalsrt("TCA"),
        .externalsrt("Nuke"),
        .externalsrt("NukeUI"),
      ]
    ),
    .make(
      name: "Setting",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.setting.setting",
      sources: ["SettingScene/Setting/**"],
      dependencies: [
        .project(target: "CoreKit", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
        .externalsrt("TCA"),
        .externalsrt("Nuke"),
        .externalsrt("NukeUI"),
      ]
    ),
  ]
)

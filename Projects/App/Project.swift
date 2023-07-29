import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "App",
  targets: [
    .make(
      name: "Prod-SeeYouAgain",
      product: .app,
      bundleId: "com.mashup.seeYouAgain",
      infoPlist: .file(path: .relativeToRoot("Projects/App/Info.plist")),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .project(target: "CoreKit", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
        .project(target: "AppCoordinator", path: .relativeToRoot("Projects/Features/Coordinator")),
        .externalsrt("TCA"),
      ],
      settings: .settings(
        base: [
          "ASSETCATALOG_COMPILER_APPICON_NAME":"ProdAppIcon"
        ],
        configurations: [
          .release(name: .release, xcconfig: "./xcconfigs/SeeYouAgain.release.xcconfig"),
        ]
      )
    ),
    .make(
      name: "Dev-SeeYouAgain",
      product: .app,
      bundleId: "com.mashup.seeYouAgain-dev",
      infoPlist: .file(path: .relativeToRoot("Projects/App/Info.plist")),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .project(target: "CoreKit", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
        .project(target: "AppCoordinator", path: .relativeToRoot("Projects/Features/Coordinator")),
        .externalsrt("TCA"),
      ],
      settings: .settings(
        base: [
          "ASSETCATALOG_COMPILER_APPICON_NAME":"DevAppIcon"
        ],
        configurations: [
          .debug(name: .debug, xcconfig: "./xcconfigs/SeeYouAgain.debug.xcconfig"),
        ]
      )
    ),
    .make(
      name: "Prod-SeeYouAgain-WatchOS",
      platform: .watchOS,
      product: .watch2Extension,
      bundleId: "com.mashup.seeYouAgain.watchkitextension",
      deploymentTarget: .watchOS(targetVersion: "9.0"),
      infoPlist: .file(path: .relativeToRoot("Projects/App/WatchInfo.plist")),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .project(target: "CoreKitWatchOS", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystemWatchOS", path: .relativeToRoot("Projects/DesignSystemWatchOS")),
        .externalsrt("TCA"),
      ],
      settings: .settings(
        base: [
          "ASSETCATALOG_COMPILER_APPICON_NAME":"ProdAppIcon"
        ],
        configurations: [
          .release(name: .release, xcconfig: "./xcconfigs/SeeYouAgain.release.xcconfig"),
        ]
      )
    ),
    .make(
      name: "Dev-SeeYouAgain-WatchOS",
      platform: .watchOS,
      product: .watch2Extension,
      bundleId: "com.mashup.seeYouAgain.watchkitapp-dev",
      deploymentTarget: .watchOS(targetVersion: "9.0"),
      infoPlist: .file(path: .relativeToRoot("Projects/App/WatchInfo.plist")),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .project(target: "CoreKitWatchOS", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystemWatchOS", path: .relativeToRoot("Projects/DesignSystemWatchOS")),
        .externalsrt("TCA"),
      ],
      settings: .settings(
        base: [
          "ASSETCATALOG_COMPILER_APPICON_NAME":"DevAppIcon"
        ],
        configurations: [
          .debug(name: .debug, xcconfig: "./xcconfigs/SeeYouAgain.debug.xcconfig"),
        ]
      )
    )
  ],
  additionalFiles: [
    "./xcconfigs/SeeYouAgain.shared.xcconfig"
  ]
)

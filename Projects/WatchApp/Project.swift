import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "WatchApp",
  targets: [
    .make(
      name: "Prod-SeeYouAgain-WatchOS",
      platform: .watchOS,
      product: .watch2Extension,
      bundleId: "com.mashup.seeYouAgain.watchkitapp",
      deploymentTarget: .watchOS(targetVersion: "9.0"),
      infoPlist: .file(path: .relativeToRoot("Projects/WatchApp/Info.plist")),
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
      name: "Dev-SeeYouAgain-WatchOS-dev",
      platform: .watchOS,
      product: .watch2Extension,
      bundleId: "com.mashup.seeYouAgain.watchkitapp",
      deploymentTarget: .watchOS(targetVersion: "9.0"),
      infoPlist: .file(path: .relativeToRoot("Projects/WatchApp/Info.plist")),
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

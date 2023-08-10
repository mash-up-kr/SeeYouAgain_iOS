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
				.project(target: "Prod-SeeYouAgain-WatchOS", path: .relativeToRoot("Projects/WatchApp")),
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
				.project(target: "Dev-SeeYouAgain-WatchOS", path: .relativeToRoot("Projects/WatchApp")),
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
  ],
  additionalFiles: [
    "./xcconfigs/SeeYouAgain.shared.xcconfig"
  ]
)

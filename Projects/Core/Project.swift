import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "Core",
  targets: [
    .make(
      name: "CoreKit",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.coreKit",
      sources: ["CoreKit/**"],
      dependencies: [
        .target(name: "Common"),
        .target(name: "Models"),
        .target(name: "Services")
      ]
    ),
    .make(
      name: "CoreKitWatchOS",
      platform: .watchOS,
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.coreKit.watchOS",
      deploymentTarget: .watchOS(targetVersion: "9.0"),
      sources: ["CoreKit/**"],
      dependencies: [
        .target(name: "CommonWatchOS"),
        .target(name: "ModelsWatchOS"),
        .target(name: "ServicesWatchOS")
      ]
    ),
    .make(
      name: "Common",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.common",
      sources: ["Common/**"],
      dependencies: [
        .externalsrt("TCA")
      ]
    ),
    .make(
      name: "CommonWatchOS",
      platform: .watchOS,
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.common.watchOS",
      deploymentTarget: .watchOS(targetVersion: "9.0"),
      sources: ["Common/**"],
      dependencies: [
        .externalsrt("TCA")
      ]
    ),
    .make(
      name: "Models",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.models",
      sources: ["Models/**"],
      dependencies: []
    ),
    .make(
      name: "ModelsWatchOS",
      platform: .watchOS,
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.models.watchOS",
      deploymentTarget: .watchOS(targetVersion: "9.0"),
      sources: ["Models/**"],
      dependencies: []
    ),
    .make(
      name: "Services",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.services",
      sources: ["Services/**"],
      dependencies: [
        .target(name: "Common"),
        .target(name: "Models"),
        .externalsrt("AF"),
        .externalsrt("TCA"),
        .externalsrt("CombineExt")
      ]
    ),
    .make(
      name: "ServicesWatchOS",
      platform: .watchOS,
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.services.watchOS",
      deploymentTarget: .watchOS(targetVersion: "9.0"),
      sources: ["Services/**"],
      dependencies: [
        .target(name: "CommonWatchOS"),
        .target(name: "ModelsWatchOS"),
        .externalsrt("AF"),
        .externalsrt("TCA"),
        .externalsrt("CombineExt")
      ]
    ),
  ]
)

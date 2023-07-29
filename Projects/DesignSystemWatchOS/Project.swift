import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "DesignSystemWatchOS",
  targets: [
    .make(
      name: "DesignSystemWatchOS",
      platform: .watchOS,
      product: .framework,
      bundleId: "com.mashup.seeYouAgain.designSystem.watchOS",
      deploymentTarget: .watchOS(targetVersion: "9.0"),
      sources: ["Sources/**"],
      resources: ["Resources/**"]
    )
  ],
  resourceSynthesizers: [
    .custom(name: "Assets", parser: .assets, extensions: ["xcassets"]),
    .fonts()
  ]
)

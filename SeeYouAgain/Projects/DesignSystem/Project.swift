import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "DesignSystem",
  targets: [
    .make(
      name: "DesignSystem",
      product: .framework,
      bundleId: "com.mashup.seeYouAgain.designSystem",
      sources: ["Source/**"],
      resources: ["Resource//**"],
      dependencies: [
        .project(target: "CoreKit", path: .relativeToRoot("Projects/Core")),
      ]
    )
  ],
  resourceSynthesizers: [
    .custom(name: "Assets", parser: .assets, extensions: ["xcassets"]),
    .fonts()
  ]
)

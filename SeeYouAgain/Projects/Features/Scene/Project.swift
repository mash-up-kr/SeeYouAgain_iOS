import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "Scene",
  targets: [
    .make(
      name: "Home",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.main.home",
      sources: ["Main/Home/**"],
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
      bundleId: "com.mashup.seeYouAgain.main.setting",
      sources: ["Main/Setting/**"],
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

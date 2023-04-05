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
        .target(name: "MainCoordinator"),
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
        .project(target: "Home", path: .relativeToRoot("Projects/Features/Scene")),
        .project(target: "Setting", path: .relativeToRoot("Projects/Features/Scene")),
        .externalsrt("TCA"),
        .externalsrt("TCACoordinators"),
      ]
    ),
  ]
)

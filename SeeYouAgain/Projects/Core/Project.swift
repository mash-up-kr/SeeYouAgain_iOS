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
        .target(name: "Services"),
      ]
    ),

    .make(
      name: "Common",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.common",
      sources: ["Common/**"],
      dependencies: [
        .externalsrt("TCA"),
      ]
    ),
    .make(
      name: "Models",
      product: .staticLibrary,
      bundleId: "com.mashup.seeYouAgain.models",
      sources: ["Models/**"],
      dependencies: [
        
      ]
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
        .externalsrt("CombineExt"),
      ]
    ),
  ]
)

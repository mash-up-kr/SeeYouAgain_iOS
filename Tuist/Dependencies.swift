import ProjectDescription

let dependencies = Dependencies(
  swiftPackageManager: [
    .remote(
      url: "https://github.com/pointfreeco/swift-composable-architecture.git",
      requirement: .exact("0.40.2")
    ),
    .remote(
      url: "https://github.com/johnpatrickmorgan/TCACoordinators.git",
      requirement: .exact("0.2.0")
    ),
    .remote(
      url: "https://github.com/Alamofire/Alamofire.git",
      requirement: .exact("5.6.4")
    ),
    .remote(
      url: "https://github.com/CombineCommunity/CombineExt.git",
      requirement: .exact("1.8.1")
    ),
    .remote(
      url: "https://github.com/kean/Nuke.git",
      requirement: .exact("12.1")
    ),
  ],
  platforms: [.iOS, .watchOS]
)

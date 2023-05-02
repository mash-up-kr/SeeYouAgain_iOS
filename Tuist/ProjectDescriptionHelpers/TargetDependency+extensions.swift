import ProjectDescription

extension TargetDependency {
  public static func externalsrt(
    _ name: String
  ) -> TargetDependency {
    switch name {
    case "TCA":
      return .external(name: "ComposableArchitecture")
    case "AF":
      return .external(name: "Alamofire")
    case "Nuke":
      return .external(name: "Nuke")
    case "NukeUI":
      return .external(name: "NukeUI")
    default:
      return .external(name: name)
    }
  }
}

import Foundation
import ProjectDescription

fileprivate let commonScripts: [TargetScript] = [
  .pre(
    script: """
    ROOT_DIR=\(ProcessInfo.processInfo.environment["TUIST_ROOT_DIR"] ?? "")
    
    ${ROOT_DIR}/swiftlint --config ${ROOT_DIR}/.swiftlint.yml
    
    """,
    name: "SwiftLint",
    basedOnDependencyAnalysis: false
  )
]

extension Target {
  public static func make(
      name: String,
      platform: Platform = .iOS,
      product: Product,
      bundleId: String,
      deploymentTarget: DeploymentTarget = .iOS(targetVersion: "16.0", devices: [.iphone]),
      infoPlist: InfoPlist? = .default,
      sources: SourceFilesList,
      resources: ResourceFileElements? = nil,
      dependencies: [TargetDependency] = [],
      settings: Settings? = nil,
      scripts: [TargetScript] = []
    ) -> Target {
      return Target(
        name: name,
        platform: platform,
        product: product,
        bundleId: bundleId,
        deploymentTarget: deploymentTarget,
        infoPlist: infoPlist,
        sources: sources,
        resources: resources,
        scripts: commonScripts + scripts,
        dependencies: dependencies,
        settings: settings
      )
    }
}

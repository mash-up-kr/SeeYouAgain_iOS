import ProjectDescription

extension Project {
  public static func make(
    name: String,
    targets: [Target],
    packages: [Package] = [],
    resourceSynthesizers: [ResourceSynthesizer] = [],
    additionalFiles: [FileElement] = []
  ) -> Project {
    return Project(
      name: name,
      organizationName: "mashup.seeYouAgain",
      options: .options(
        automaticSchemesOptions: .disabled,
        textSettings: .textSettings(usesTabs: false, indentWidth: 2, tabWidth: 2)
      ),
      packages: packages,
      targets: targets,
      additionalFiles: additionalFiles,
      resourceSynthesizers: resourceSynthesizers
    )
  }
}

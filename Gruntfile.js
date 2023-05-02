const generateProjectFile = require("./grunt/generate-project-file");
const onboarding = require("./grunt/onboarding");
const pr = require("./grunt/pr");
const deployLocal = require("./grunt/deploy-local");

module.exports = function (grunt) {
  grunt.initConfig({
    availabletasks: {
      tasks: {},
    },
  });
  grunt.loadNpmTasks("grunt-available-tasks");

  grunt.registerTask("default", ["availabletasks"]);
  
  grunt.registerTask("gp", "project 파일을 생성 합니다.", generateProjectFile);

  grunt.registerTask("onboarding", "Github Personal AccessToken을 설정합니다.", onboarding);

  grunt.registerTask("pr", "정해진 양식에 따라 PullRequest를 보냅니다.", pr);

  grunt.registerTask("deploy-local", "fastlane을 통해 local에서 배포를 진행합니다.", deployLocal);
};

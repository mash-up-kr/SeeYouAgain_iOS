const generateProjectFile = require("./grunt/generate-project-file");

module.exports = function (grunt) {
  grunt.initConfig({
    availabletasks: {
      tasks: {},
    },
  });
  grunt.loadNpmTasks("grunt-available-tasks");

  grunt.registerTask("default", ["availabletasks"]);
  
  grunt.registerTask("gp", "project 파일을 생성 합니다.", generateProjectFile);
};

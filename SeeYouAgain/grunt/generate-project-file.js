const shell = require("shelljs");

module.exports = function generateProjectFile() {
  shell.echo("");
  shell.echo("🌀 Running 'tuist fetch': Install SPM Dependencies By Tuist");
  if (shell.exec("tuist fetch").code > 0) {
    shell.echo("❌ 'tuist generate  --no-open' failed");
    shell.exit(1);
  }

  shell.echo("");
  shell.echo("🌀 Running 'tuist generate': Generate Xcode project file");
  if (shell.exec("TUIST_ROOT_DIR=$PWD tuist generate --no-open").code > 0) {
    shell.echo("❌ 'tuist generate  --no-open' failed");
    shell.exit(1);
  }
};

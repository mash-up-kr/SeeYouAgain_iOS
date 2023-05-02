const shell = require("shelljs");

module.exports = function installTemplate() {
  shell.echo("🌀 Running 'installTemplate.sh'");
  if (shell.exec("sh Template/installTemplate.sh").code > 0) {
    shell.echo("❌ 'installTemplate.sh' failed");
    shell.exit(1);
  }
};

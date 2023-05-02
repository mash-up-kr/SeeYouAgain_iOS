const fs = require("fs");
const { question } = require("./helpers");
const shell = require("shelljs");

module.exports = async function onboarding() {
  const done = this.async();

  const token = await fetchEnv();

  createGruntEnvFile();

  _setXCConfigValue("PERSONAL_PRIVATE_TOKEN", token, "./.grunt-env");

  done();
};

async function fetchEnv() {
  const token = await question(`\n🙏 Github Personal Access Token을 입력해 주세요.\n>`);

  shell.echo(`\n===입력 정보 확인===\n🎯 token: ${token}`);

  return token;
}

function createGruntEnvFile() {
  const gruntEnvExampleStr = fs.readFileSync("./.grunt-env.example", {
    encoding: "utf8",
  });

  fs.writeFileSync("./.grunt-env", gruntEnvExampleStr);
}

/**
 *
 * @param {string} key
 * @param {string} value
 * @param {string} configFilePath
 */
function _setXCConfigValue(key, value, configFilePath) {
  const entities = _xcconfigEntities(configFilePath);
  const newEntities = entities.map((entity) => {
    if (entity.length !== 2) {
      return entity;
    }

    const [_key, _] = entity;
    if (_key !== key) {
      return entity;
    }

    return [_key, value];
  });
  const lines = newEntities.map((entity) => entity.join("="));
  const data = lines.join("\n");
  fs.writeFileSync(configFilePath, data);
}

/**
 *
 * @param {string} configFilePath
 * @returns {string[][]} entities
 */
function _xcconfigEntities(configFilePath) {
  const xcconfigStr = fs.readFileSync(configFilePath, {
    encoding: "utf8",
  });
  const lines = xcconfigStr.split("\n");
  return lines.map((line) => {
    return line.split("=", 2);
  });
}

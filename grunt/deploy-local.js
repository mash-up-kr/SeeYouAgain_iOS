const fs = require("fs");
const { question } = require("./helpers");
const shell = require("shelljs");
const semver = require("semver");

module.exports = async function deployLocal() {
  const done = this.async();

  const { appleID, newVersionNumber, newBuildNumber } = await fetchEnv();

  await checkoutBranch(newVersionNumber, newBuildNumber);

  await setBuildInfo(newVersionNumber, newBuildNumber);
  createReleaseCommit(newVersionNumber, newBuildNumber);

  await deploy(appleID, newVersionNumber, newBuildNumber);

  done();
};

async function setBuildInfo(newVersionNumber, newBuildNumber) {
  const { execa } = await import("execa");
  const configFilePath = "./Projects/WatchApp/xcconfigs/SeeYouAgain.shared.xcconfig";
  const xcodeProjPath = "./Projects/WatchApp/WatchApp.xcodeproj"

  _setXCConfigValue("MARKETING_VERSION", newVersionNumber, configFilePath);

  await execa("bundle", ["exec", "fastlane", "run", "increment_build_number", `build_number:${newBuildNumber}`, `xcodeproj:${xcodeProjPath}`], {
    stdio: "inherit",
  });
}

function createReleaseCommit(newVersionNumber, newBuildNumber) {
  const configFilePath = "./Projects/WatchApp/xcconfigs/SeeYouAgain.shared.xcconfig";
  const commitMessage = `:bookmark: v${newVersionNumber}-${newBuildNumber}`;
  const infoPlistFilePath = "./Projects/WatchApp/Info.plist"

  if (shell.exec(`git add ${infoPlistFilePath} ${configFilePath} && git commit -m "${commitMessage}" && git push`).code > 0) {
    shell.echo("❌ 'createReleaseCommit' failed");
    shell.exit(1);
  }
}

async function fetchEnv() {
  const appleID = await question(`🙏 Apple Developer 이메일을 입력해 주세요. (ex. humains@nate.com) \n> `);

  const currentVersion = fetchCurrentVersion();
  const bumpType = await question(
    `\n🙏 bump type (no, patch, minor, major) 또는, 특정 버전(1.1.0)을 입력하세요. / 현재 버전은, '${currentVersion}' 입니다. \n> `
  );

  /** @type {string} */
  const newVersionNumber = _newVersion(currentVersion, bumpType);
  const newBuildNumber = _newBuildNumber();

  shell.echo(`\n===입력 정보 확인===\n🔑 Account: ${appleID}\n🎯 Version: '${newVersionNumber} - ${newBuildNumber}'\n`);

  return {
    appleID,
    newVersionNumber,
    newBuildNumber,
  };
}

async function deploy(appleID, newVersionNumber, newBuildNumber) {
  const { execa } = await import("execa");
  await execa("grunt", ["gp"]);
  await execa(
    "bundle",
    ["exec", "fastlane", "ios", "beta", `new_version_number:${newVersionNumber}`, `new_build_number:${newBuildNumber}`],
    {
      env: { ...process.env, APPLE_ID: appleID },
      stdio: "inherit",
    }
  );
}

async function checkoutBranch(newVersionNumber, newBuildNumber) {
  const { execa } = await import("execa");
  const res = await question("⚠️ 'git reset --h' 명령어가 실행됩니다. 커밋되지 않은 변경사항은 모두 삭제됩니다. [y/n]\n>");

  switch (res) {
    case "Y":
    case "y":
      shell.echo("\n🌀 'git reset --h' 실행중");
      await execa("git", ["reset", "--h"]);
      shell.echo("✅ 'git reset --h' 완료\n");
      break;

    case "N":
    case "n":
      shell.echo("👋 종료됨");
      shell.exit(1);
    default:
      shell.echo("👋 선택지에 없는 입력입니다.");
      shell.exit(1);
  }

  await execa("git", ["fetch"]);
  shell.echo("✅ 'git fetch' 완료\n");

  shell.echo("🌀 'git checkout infraTest' 실행중");
  await execa("git", ["checkout", "infraTest"]);
  shell.echo("✅ 'git checkout infraTest' 완료\n");

  await execa("git", ["pull"]);
  shell.echo("✅ 'git pull' 완료\n");

  shell.echo(`🌀 'git checkout -b release/v${newVersionNumber}-${newBuildNumber}' 실행중`);
  await execa("git", ["checkout", "-b", `release/v${newVersionNumber}-${newBuildNumber}`]);
  shell.echo(`✅ 'git checkout -b release/v${newVersionNumber}-${newBuildNumber}' 완료\n`);

  shell.echo(`🌀 'git push --set-upstream origin release/v${newVersionNumber}-${newBuildNumber}'실행중`);
  await execa("git", ["push", "--set-upstream", `origin`, `release/v${newVersionNumber}-${newBuildNumber}`]);
  shell.echo(`✅ 'git push --set-upstream origin release/v${newVersionNumber}-${newBuildNumber}' 완료\n`);
}

function fetchCurrentVersion() {
  const configFilePath = "./Projects/WatchApp/xcconfigs/SeeYouAgain.shared.xcconfig";

  const currentVersion = _getXCConfigValue("MARKETING_VERSION", configFilePath);

  if (currentVersion === undefined) {
    shell.echo("failed to get xcconfig value 'MARKETING_VERSION'");
    shell.exit(1);
  }

  return currentVersion;
}

function _newVersion(currentVersion, bumpType) {
  switch (bumpType) {
    case "patch":
    case "minor":
    case "major":
      return semver.inc(currentVersion, bumpType);
    case "no":
      return currentVersion;
    default:
      const specificVersion = bumpType;
      return specificVersion;
  }
}

function _newBuildNumber() {
  const now = new Date();
  const year = now.getFullYear().toString().padStart(4, "0");
  const month = (now.getMonth() + 1).toString().padStart(2, "0");
  const date = now.getDate().toString().padStart(2, "0");
  const hour = now.getHours().toString().padStart(2, "0");
  const minute = now.getMinutes().toString().padStart(2, "0");
  return `${year}${month}${date}${hour}${minute}`;
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
 * @param {string} key
 * @param {string} configFilePath
 * @returns {(string|undefined)} value
 */
function _getXCConfigValue(key, configFilePath) {
  const entities = _xcconfigEntities(configFilePath);
  const entity =
    entities.find((entity) => {
      return entity[0] === key;
    }) ?? [];
  return entity[1];
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

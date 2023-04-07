const fs = require("fs");
const { question } = require("./helpers");
const shell = require("shelljs");
const semver = require("semver");
const { Octokit } = require("octokit");

module.exports = async function pr() {
  const done = this.async();
  const token = _getXCConfigValue("PERSONAL_PRIVATE_TOKEN", "./.grunt-env");
  const octokit = new Octokit({
    auth: token,
  });

  const { prefix, title, headBranch, baseBranch, taskName, taskURL, notes } = await fetchEnv();

  const body = `
## Task

[${taskName}](${taskURL})

## 참고

${notes}
`;

  await createPullRequest(octokit, `${prefix}: ${title}`, body, headBranch, baseBranch);
  done();
};

/**
 * @param {Octokit} octokit
 * @param {string} title
 * @param {string} body
 * @param {string} headBranch
 * @param {string} baseBranch
 */
async function createPullRequest(octokit, title, body, headBranch, baseBranch) {
  try {
    await octokit.rest.pulls.create({
      owner: "mash-up-kr",
      repo: "SeeYouAgain_iOS",
      title: title,
      body: body,
      head: headBranch,
      base: baseBranch,
    });
  } catch (err) {
    console.log(err);
  }
}

async function fetchEnv() {
  const prefix = await question(
    `\n🙏 PR의 prefix를 입력해 주세요.\n(인프라, 문서, 기능, 버그, 수정, 성능, 리팩터, 스타일, 릴리즈, 제거, 테스트)\n> `
  );

  const title = await question(`\n🙏 PR의 제목을 입력해 주세요. \n> `);

  const headBranch = await question(`\n🙏 head(머지시킬)branch 이름을 입력해 주세요. \n> `);

  const baseBranch = await question(`\n🙏 head(머지당할)branch 이름을 입력해 주세요. \n> `);

  const taskName = await question(`\n🙏 해당 PR에 해당하는 Task 이름을 입력해 주세요. \n> `);

  const taskURL = await question(`\n🙏 해당 PR에 해당하는 참고할 URL을 입력해 주세요. \n> `);

  const notes = await question(`\n🙏 해당 PR과 관련하여 참고할 사항을 입력해 주세요. \n> `);

  shell.echo(
    `\n===입력 정보 확인===\n🎯 headBranch: ${headBranch}\n🎯 baseBranch: ${baseBranch}\n🎯 TaskName: ${taskName}\n🎯 TaskURL: ${taskURL}\n🎯 notes: ${notes}\n`
  );

  return { prefix, title, headBranch, baseBranch, taskName, taskURL, notes };
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

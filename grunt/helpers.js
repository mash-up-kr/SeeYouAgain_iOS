/**
 *
 * @param {string} questionText The question text to prompt to user
 * @returns {Promise<string>}
 */
async function question(questionText) {
  return new Promise((resolve, reject) => {
    const readline = require("readline").createInterface({
      input: process.stdin,
      output: process.stdout,
    });
    readline.question(questionText, (answer) => {
      resolve(answer);
      readline.close();
      readline.removeAllListeners();
    });
  });
}

module.exports = {
  question,
};

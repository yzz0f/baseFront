// Conventional Commits: https://www.conventionalcommits.org
// Se usa en el hook commit-msg (pre-commit) y en .github/workflows/commitlint.yml
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      ['feat', 'fix', 'docs', 'style', 'refactor', 'perf', 'test', 'build', 'ci', 'chore', 'revert'],
    ],
    'subject-case': [2, 'never', ['sentence-case', 'start-case', 'pascal-case', 'upper-case']],
    'header-max-length': [2, 'always', 72],
    'body-max-line-length': [1, 'always', 100],
  },
};

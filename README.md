# bump-maven-version-action

A simple GitHub Actions to bump the version of Maven projects.

When triggered, this action will find the current version in pom.xml , the version format MUST be: x.y.z
At moment, it will only increase the version: x.y+2.z
The change will then be committed.

## Sample Usage

```yaml
name: Bump Maven Version on PR merged to develop branch

on:
  pull_request:
    types:
    - closed
    branches:
    - develop

jobs:
  build:
    if: github.event.pull_request.merged == true
    name: build and bump version
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
        with:
          fetch-depth: 0  # Shallow clones should be disabled for a better relevancy of analysis
          token: ${{secrets.GIT_REPO_ADMIN_PAT}}  # A PAT token which has permission to commit the code

      - name: Bump Version
        id: bump
        uses: DaveXiong/bump-maven-version@main
        with:
          git-username: ${{secrets.GIT_BOT_USERNAME}}

      - run: echo -e ${{ steps.bump.outputs.old-version }} => ${{ steps.bump.outputs.new-version}}
        shell: bash  
```


## Outputs

* `old-version` - the version before bump
* `new-version` - the version after bump


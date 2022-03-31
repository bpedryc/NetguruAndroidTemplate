[![Dependabot Status](https://api.dependabot.com/badges/status?host=github&repo=netguru/netguru-android-template&identifier=60598586)](https://dependabot.com)
<!-- 
    Couple of points about editing:
    
    1. Keep it SIMPLE.
    2. Refer to reference docs and other external sources when possible.
    3. Remember that the file must be useful for new / external developers, and stand as a documentation basis on its own.
    4. Try to make it as informative as possible.
    5. Do not put data that can be easily found in code.
    6. Include this file on ALL branches.

    Below are links that should be replaced!
-->

[cdLink1]: ${CONTINUOUS_DELIVERY_STAGING_LINK}
[cdLink2]: ${CONTINUOUS_DELIVERY_PROD_LINK}
[jiraBoardLink]: ${JIRA_BOARD_LINK}
[confluenceLink]: ${CONFLU_WIKI_LINK}
[projectSlackChannel]: ${PROJECT_SLACK_CHANNEL}
[bitriseLink]: ${BITRISE_LINK}
[firebaseLink]: ${FIREBASE_LINK}

<!-- Remove this section after project setup -->
## Configure NAT as new project

### Running the script

#### Console arguments

To **configure** NAT as new project, you should run the [configuration script](android-nat-script.sh). To do that, you should download the script manually and run it like this:
```./android-nat-script.sh```

The script clones the NAT repository to a directory of your choosing and attempts to modify the project's files and structure of directories to match the application id that you provided at the beginning. A script can optionally set a remote URL of git vcs and make an initial commit.

#### Execution arguments

If you would like to run script with execution arguments add `-manual`  option and arguments to script execution.

Execution arguments to define: 

 - git_protocol - ssh or https
 - app_id - application Id
 - project_dir - project directory
 - make_initial_commit - should make initial commit y or n
 - remoate_name - name of the remote directory
 - remote_url  - remote url
 - branch_name - branch name to push changes
 - commit_message - commit message of changes

```./android-nat-script.sh -manual ssh ...```

### Bitrise setup and branching strategy
 - manual setup:  
 copy bitrise-wrapper.yml into 'bitrise.yml' tab in workflow editor.
 - automatic setup:  
 use mobile devops bitrise script to automatically setup bitrise with configuration from this repo. 
 
You can edit configuration by editing bitrise.yml file. If you don't feel confortable with editing 
file directly you can use offline workflow editor. 
Please refer to this [instruction](https://devcenter.bitrise.io/bitrise-cli/offline-workflow-editor/) 
 
Default workflow triggers:  
 - `build-staging` workflow will be triggered on push to master branch  
 - `build-release` workflow will be triggered on any tag push  
 - `build-pull-request` workflow will be triggered on any pull request that targets master branch.
 
<!-- Put your project's name -->
# ${PROJECT NAME}

<!-- Add links to CD places like AppCenter, Firebase Distribution or other  -->
<!-- Add links to CI configs with build status and deployment environment, e.g.: -->
| environment | deployment            | status             |
|-------------|-----------------------|--------------------|
| staging     | [link][cdLink1]  | bitrise status tag |
| production  | [link][cdLink2]  | bitrise status tag |

Welcome to the **${PROJECT NAME}** project.

${PROJECT_DESCRIPTION}

- [JIRA][jiraBoardLink]
- [CONFLUENCE][confluenceLink]
- [SLACK CHANNEL][projectSlackChannel]
- 1Password: ${VAULT_NAME}
- [Netguru development workflow](https://netguru.atlassian.net/wiki/display/DT2015/Netguru+development+flow)

## Services
* [Bitrise][bitriseLink]
* [Firebase][firebaseLink]
* etc.

## Configuration

### Prerequisites
Things that you need to have before starting working with a project.
<!-- This should be rather obvious for Android Developer, but could be helpful for anyone else. -->

For example:
- [Install Android Studio](https://developer.android.com/studio)
- Set up Android emulator or real Android device

### Installation
Write down step-by-step instructions what you need to do after fulfilling the prerequisites to launch the application.

For example:
1. Clone project from GIT
2. Download `secret.properties` file from 1Password Vault
3. Sync project with Gradle

##  Linter and Code Style

When committing to the repository, please, format your code according to the team code style guide.
By default, it should be consistent with formatter from IDE.

- [Style guide for Kotlin](https://kotlinlang.org/docs/reference/coding-conventions.html)
- [Android linter](https://developer.android.com/studio/write/lint)

## Code quality guidelines
<!-- Avoid entering all the rules here; Rather point to appropriate WIKI pages / guides -->

For example:

Ensure at least ${REQUIRED_UNIT_TEST_COVERAGE} Unit Test coverage for application.

Accessibility guidelines for the project.

## Project guide

### Build types and flavors
<!--- If You build types are not used in a standard manner, please note here how to use them - in other case feel free to include a link to build file-->

#### [Build types](app/build.gradle#L33-L53)
#### [Flavors](app/build.gradle#L57-L70)

### Build properties & Secrets
<!-- List all build properties that have to be supplied, including secrets. Describe the method of supplying them, both on local builds and CI -->

| Property         | Environment variable |
|------------------|----------------------|
| AppCenter App ID | APP_CENTER_APP_ID    |
| Third Party APIKey| SOME_API_KEY |

Follow [this guide](https://netguru.atlassian.net/wiki/pages/viewpage.action?pageId=33030753) for using secrets.

<!-- If developer has to build/upload manually production App describe this process here -->

### Supported devices
<!-- Describe the supported and target devices (do not put stuff that can be easily found in build.gradle files) --> 
For example:

Client-specific devices list.

### Danger
Follow [this guide](https://docs.google.com/document/d/1vdpgBLNmccz_OswIPWxh5DNEBcGpuPkLRleMk7eTjH0/edit?usp=sharing) to use Danger in your setup
In short - adjust your /Dangerfile and add required data to your Bitrise PR workflow

### Reporting data to Francis
Follow [this guide](https://netguru.atlassian.net/wiki/spaces/MOB/pages/2665939594/Reporting+project+data+to+Francis+via+Danger) to find Francis Project ID. Update `FRANCIS_PROJECT_ID` in `bitrise.yml` or by using offline workflow editor.

### Known Issues
Describe all workarounds and unresolved issues that are presented in code.

### (Optionally) Navigation
<!-- rather as a link to WIKI + maybe link to clickable prototype [InVision for example] -->

### Related repositories
- [${RELATED_REPOSITORY_NAME}](RELATED_REPOSITORY_LINK)
# Cyber Security Risk profiler Dashboard

System of Records for all the LCCE Applications built on salesforce platform

## Self Study Tutorials

> Estimated Time for New Joiners ~ 2 Hours [Only Concepts]

1. Complete the following three Tutorials - Max Estimated Time : 2 Hours

    - [Learn Automation with CumulusCI](https://cumulusci.readthedocs.io/en/stable/intro.html#learn-more-through-demos)
    - [Developing inside a Container](https://code.visualstudio.com/docs/remote/containers)
    - [Remote development in Containers](https://code.visualstudio.com/docs/remote/containers-tutorial)

## Prerequisites

> Estimated Time for New Joiners ~ 4 Hours

1. Add SSH key to your [GitHub Profile](https://github.com/settings/keys)

    - Follow the Steps as in [GitHub Docs: ](https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account)

1. Join [Shift Left Security](https://eurl.io/#L1zXw5q-Z) and request for

    - Git Guardian API Key
    - Cisco Dev Hub Org username and password

1. (Optional) Get your own [Salesforce Developer Hub](https://developer.salesforce.com/signup). Developer Hub (Dev Hub) is the main Salesforce org that you will use to create and manage the scratch orgs. Scratch org is a dedicated, configurable, and short-term Salesforce environment that you can quickly spin up when starting a new project, a new feature branch, or a feature test.

    > To enable Dev Hub in an org:
    >
    > 1. Log in as System Administrator to Salesforce
    > 1. From Setup, enter Dev Hub in the Quick Find box and select Dev Hub.
    > 1. To enable Dev Hub, click Enable. After you enable Dev Hub.

1. Install [Visual Studio Code](https://code.visualstudio.com/download)

1. [Remote-Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

    - In the terminal `code --install-extension ms-vscode-remote.remote-containers`
    - For robot files extension `code --install-extension tomiturtiainen.rf-intellisense`

1. [Docker](https://www.docker.com/)

## Getting Started


1.  Clone repository

    ```
    git clone https://github.com/rajasoun/ci-container.git
    cd ci-container
    code .
    ```

1.  Click the Green Button as shown in the image below and select
    Open Folder in Container... command and select the local folder.

    ![Click the Green Button](docs/images/remote-status-bar.png)

1.  Grab a Coffee ☕️. Based on your internet speed might take 5 mins to 7 mins with ~50 mbps speed

1. Open Terminal and Run `.devcontainer/tests/system/e2e_tests.sh` for automated test of the setup

## Setup

1. Open Terminal in Visual Studio Code

    ```
    $ .devcontainer/tests/system/e2e_tests.sh
    $ source automator/ghelp.bash
    $ ghelp
    $ gsetup
    ```

## Development Rythm

1. Create Feature Branch

    ```
    $ git flow feature start <description_MICROSVCS-jira_id>
    ```

1. Run `gaa` for git add

1. Run `gc` for git commit

1. Once you completed developing the feature
    ```
    $ git flow feature finish <short_name_MICROSVCS-jira_id>
    ```

## Automate Release

Following steps to be executed to do an automate release.

1. Open Terminal in Dev Container
1. Ensure all Open Pull Requests are Closed by running `gh pr list `
1. Get latest code base from main
    ```
    git checkout main #Checkout main branch
    git pull --rebase #Get the Latest Code
    ```

1. Run Automated Release
    ```
    release
    ```

## Refernces

1. [Shift Left Security Tooling Guide](SLS.md)


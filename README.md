AgileNotifier
=============

[![Gem Version](https://badge.fury.io/rb/agile_notifier.svg)](http://badge.fury.io/rb/agile_notifier)
[![Code Climate](https://codeclimate.com/github/thyrlian/AgileNotifier/badges/gpa.svg)](https://codeclimate.com/github/thyrlian/AgileNotifier)
[![Build Status](https://travis-ci.org/thyrlian/AgileNotifier.svg?branch=master)](https://travis-ci.org/thyrlian/AgileNotifier)

Agile Notifier - an easy way of monitoring Agile SW Engineering by auralization change.  It supports most of the popular tools including **CI** (Continuous Integration), **SCM** (Source Control Management), and **ITS** (Issue Tracking System).  Of course you can integrate more tools as you want.  And the simple beautiful DSL syntax gives you a rocket start.

In a modern agile team, members would like to be notified immediately once their Continuous Integration job fails (but building process usually takes quite a while).  That's the initial idea of this tool.

The joy of this tool is that, whenever a build fails, it can blame whoever submitted the commit (or praises the committer who fixed it), in whatever language you want, and even the sentenses can be randomly chosen each time :)

Have fun with it!

## Examples of Usage
```ruby
AgileNotifier::Configuration.set do
  ci_url 'http://x.x.x.x:8080'
  ci_job 'your-project-continuous-build'
  ci_get 'Jenkins'

  scm_url 'https://github.xyzcompany.com'
  scm_repo user: 'your_user_name', repo: 'your_repository_name'
  # scm_auth is optional, depends on if your github API access requires authentication
  # if authentication is required, please choose either username & password or OAuth access token (latter one is recommended)
  scm_auth username: 'github_login_username', password: 'github_login_password' # optional
  scm_auth token: 'a1b2c3d4e5f6f0f0f0f0f0f0f0f0f6e5d4c3b2a1' # optional
  scm_get 'Github', enterprise: true

  # for non-enterprise version
  # scm_url 'https://github.com'
  # scm_repo user: 'your_user_name', repo: 'your_repository_name'
  # scm_get 'Github'
  
  its_url 'https://jira.atlassian.com'
  its_auth 'jira_username', 'jira_password'
  its_get 'Jira'
  its_set_wip 'BAM', 'project = BAM AND status = Resolved AND resolution = Unresolved', 3
  its_set_wip 'XXX', 'project = XXX AND status = Resolved AND resolution = Unresolved', 5

  speak 'en'
  play 'Boing' # Mac OSX TTS voice name(optional field), unnecessary for other OS

  alert_on_fail
  alert_on_fix
  alert_on_unstable
  alert_on_wip
end
```

## Deploy to CI
First create a config file based on above DSL syntax.  (let's say the file name is [your_own_config].rb)
### Jenkins
* The **easy** way:
  * Create [The_Notification_Job], Configure -> Build -> Execute shell -> ruby [your_own_config].rb
  * Your Main Job -> Configure -> Add post-build action -> Build other projects -> Projects to build -> [The_Notification_Job]
* The **hard** but **precise** way: (imagine there are a few developers pushing all the time, which makes your CI build one after one without rest)
  * Create [The_Notification_Job], Configure -> Build -> Execute shell -> ruby [your_own_config].rb -b $UPSTREAM_BUILD_NUMBER
  * Your Main Job -> Configure -> Add post-build action -> Trigger parameterized build on other projects -> Projects to build -> [The_Notification_Job] -> Add Parameters -> Predefined parameters -> UPSTREAM_BUILD_NUMBER=${BUILD_NUMBER}

## Notes
* TTS (Text To Speech) on Linux used here has two dependencies:

  * TTS service benefits from online MARY TTS Web Client: http://mary.dfki.de:59125/  While it has limited languages support, please check before use.
  * play command comes from package sox which is not pre-installed, you have to install manually beforehand by:
  * ```sudo apt-get install sox libsox-fmt-all```

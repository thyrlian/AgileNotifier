AgileNotifier
=============

Agile Notifier - an easy way of monitoring Agile SW Engineering by auralization change.  It supports most of the popular tools including CI (Continuous Integration), SCM (Source Control Management), and ITS (Issue Tracking System).  Of course you can integrate more tools as you want.  And the simple beautiful DSL syntax gives you a quick start.

In a modern agile team, members would like to be notified once their Continuous Integration job fails which may be caused by anyone's recent commit.  This is the initial idea of this tool.

The funny thing is that, whenever a build fails, it can blame whoever submitted the commit, in whatever language you want, and even the sentenses can be randomly chosen each time :)

E.g.:
```
include AgileNotifier

Configuration.set do
  ci_url 'http://10.250.0.1:8080'
  ci_job 'your-project-continuous-build'
  ci_get Jenkins

  scm_url 'https://github.xyzcompany.com'
  scm_repo user: 'your_user_name', repo: 'your_repository_name'
  scm_get Github, enterprise: true
end
```

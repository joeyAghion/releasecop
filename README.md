# Releasecop

Given a list of projects and environments pipelines, report which environments are "behind" and by which commits.

## Installation

    gem install releasecop

## Usage

Open the manifest file, which defines projects to monitor:

    releasecop edit

In the manifest, each project lists the environments to which code is deployed _in order of promotion_. Environments are defined by a `name` and `git` remote. E.g., a github repo for development and heroku apps for staging and production. Optionally, an environment can include a `branch`. E.g.:

    {
      "projects": {
        "charge": [
          {"name": "master", "git": "git@github.com:artsy/charge.git"},
          {"name": "staging", "git": "git@heroku.com:charge-staging.git"},
          {"name": "production", "git": "git@heroku.com:charge-production.git"}
        ],
        "heat": [
          {"name": "master", "git": "git@github.com:artsy/heat.git"},
          {"name": "master-succeeded", "git": "git@github.com:artsy/heat.git", "branch": "master-succeeded"},
          {"name": "production", "git": "git@github.com:artsy/heat.git", "branch": "production"}
        ]
      }
    }

To check the release status of a project:

    releasecop check [PROJECT]

Example output:

    charge...
      staging is up-to-date with master
      production is up-to-date with staging
    heat...
      master-succeeded is up-to-date with master
      production is behind master-succeeded by:
        4557f60 2015-03-24 Upgrade to 3.9 (timsmith)
        f33acc4 2015-03-25 Add support for avatars (janeR)
    2 project(s) checked. 1 environment(s) out-of-date.

To check all projects:

    releasecop check --all

### Heroku Pipelines

At this time releasecop is not compatible with projects using [Heroku Pipelines](https://devcenter.heroku.com/articles/pipelines) to promote apps. For these apps, promoting a staging app to production simply copies the slug to the production app, so no git remote is updated.


Copyright (c) 2015 Joey Aghion, Artsy

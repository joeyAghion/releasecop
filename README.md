# Releasecop

Given a list of projects and environments pipelines, report which environments are "behind" and by which commits.

## Installation

    gem install releasecop

## Usage

Open the manifest file, which defines projects to monitor:

    releasecop edit

In the manifest, each project lists the environments to which code is deployed _in order of promotion_. Environments are defined by a `name` and `git` remote. E.g., a github repo for development and heroku apps for staging and production. Optionally, an environment can include `branch` or `hokusai` properties. E.g.:

    {
      "projects": {
        "charge": [
          {"name": "master", "git": "git@github.com:artsy/charge.git"},
          {"name": "staging", "git": "git@heroku.com:charge-staging.git"},
          {"name": "production", "git": "git@heroku.com:charge-production.git"}
        ],
        "heat": [
          {"name": "main", "git": "git@github.com:artsy/heat.git", "branch": "main"},
          {"name": "succeeded", "git": "git@github.com:artsy/heat.git", "branch": "succeeded"},
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
      succeeded is up-to-date with main
      production is behind succeeded by:
        4557f60 2015-03-24 Upgrade to 3.9 (timsmith)
        f33acc4 2015-03-25 Add support for avatars (janeR)
    2 project(s) checked. 1 environment(s) out-of-date.

To check all projects:

    releasecop check --all

### Heroku Pipelines

At this time releasecop is not compatible with projects using [Heroku Pipelines](https://devcenter.heroku.com/articles/pipelines) to promote apps. For these apps, promoting a staging app to production simply copies the slug to the production app, so no git remote is updated.

### Hokusai Pipelines

[Hokusai](https://github.com/artsy/hokusai) is a tool developed by Artsy for managing apps on [Kubernetes](https://kubernetes.io/). Releasecop's manifest can include environments with a `hokusai` property containing a docker image tag corresponding to the pipeline stage. (The `hokusai` executable and access to the image repository must be available locally.) E.g.:

```json
{
    "test-api": [
      {"name": "master", "git": "git@github.com:artsy/test-api.git" },
      {"name": "staging", "git": "git@github.com:artsy/test-api.git", "hokusai": "staging"},
      {"name": "production", "git": "git@github.com:artsy/test-api.git", "hokusai": "production"}
    ]
}
```

Releasecop will determine the git SHAs corresponding with each pipeline stage via the `hokusai registry images` command.

### Tagged Releases

Many teams create git tags corresponding to each milestone or release. The `tag_pattern` property can be used to match sets of tags corresponding to an environment. E.g.:

```json
{
    "causality": [
      {"name": "main", "git": "git@github.com:artsy/causality.git", "branch": "main" },
      {"name": "staging", "git": "git@github.com:artsy/causality.git", "tag_pattern": "staging-*"},
      {"name": "production", "git": "git@github.com:artsy/causality.git", "tag_pattern": "release-*"}
    ]
}
```

The most recent commit matching each tag expression is presumed to correspond with the state of each environment. Tag patterns follow `git` conventions, so, e.g., `staging-*` will be treated as `/refs/tags/staging-*`.

### A note about default branch names

For backwards compatibility, `releasecop` assumes a default branch name of `master`. To override this behavior, set the `RELEASECOP_DEFAULT_BRANCH` environment variable (to e.g. `main`).

Copyright (c) 2015-2018 Joey Aghion, Artsy

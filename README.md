# Releasecop

Given a list of projects and environments pipelines, report which environments are "behind" and by which commits.

## Installation

    gem install releasecop

## Usage

Open the manifest file, which defines projects to monitor:

    releasecop edit

In the manifest, each project lists the repositories/branches to whch code is deployed _in order of promotion_. E.g., master branch for development, a heroku remote for staging, and a different heroku remote for production. An example manifest:

    {
      "projects": {
        "charge": [
          {"name": "master", "git": "git@github.com:artsy/charge.git"},
          {"name": "staging", "git": "git@heroku.com:charge-staging.git"},
          {"name": "production", "git": "git@heroku.com:charge-production.git"}
        ],
        "lattice": [
          {"name": "master", "git": "git@github.com:artsy/lattice.git"},
          {"name": "production", "git": "git@heroku.com:artsy-lattice-production.git"}
        ]
      }
    }

To check the release status of a project:

    releasecop check [PROJECT]

Example output:

    charge...
      staging is up-to-date with master
      production is up-to-date with staging
    lattice...
      production is behind master by:
        4557f60 2015-02-02 upgrade to 3.9 (joeschmo19)
    2 project(s) checked. 1 environment(s) out-of-date.

To check all:

    releasecop check --all

Copyright (c) 2015 Joey Aghion

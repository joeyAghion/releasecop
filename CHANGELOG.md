(Next)
------------
* Your contribution here...

0.0.16 (2022-07-27)
------------
* Update README to document both master and main branch approaches.
* Require fileutils (fixes uninitialized constant Releasecop::Cli::FileUtils (NameError))

0.0.15 (2019-04-05)
---
* Update for compatibility with hokusai >=0.5.4 (now incompatible with earlier versions) (57ee7ae56)

0.0.14 (2019-01-07)
---
* Fix `tag_pattern`-matching to respect annotated tags (c7eda3599)

0.0.13 (2018-11-15)
---
* Add email to diff output (081d270)

0.0.12 (2018-11-14)
---
* (Fixes)

0.0.11 (2018-11-14)
---
* Allow AWS credentials to be customized per manifest item (e6397b4)

0.0.10 (2018-11-09)
---
* Allow working directory to be overridden (d728567)

0.0.9 (2018-08-20)
------------

* Properly namespace internal classes (5439cc9)
* Expose `Result#name` and `#comparisons` (2ea111c)

0.0.8 (2018-07-23)
---
* Add `--version` command

0.0.7 (2018-06-15)
---
* Support `tag_pattern` expressions for matching git tags (fixes [#6](https://github.com/joeyAghion/releasecop/issues/6), [@joeyAghion](https://github.com/joeyAghion))

0.0.6 (2018-04-24)
------------------

* Fix transposed `git log` arguments ([@joeyAghion](https://github.com/joeyAghion))

0.0.5 (2018-04-24)
------------------

* [#5](https://github.com/joeyAghion/releasecop/pull/5): Add support for Hokusai ([@ashkan18](https://github.com/ashkan18))

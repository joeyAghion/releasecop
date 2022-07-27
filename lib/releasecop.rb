
require "releasecop/version"
require 'thor'
require 'shellwords'
require 'json'
require 'releasecop/manifest_item'
require "releasecop/comparison"
require "releasecop/result"
require "releasecop/checker"
require 'fileutils'
require "releasecop/cli"

module Releasecop
  CONFIG_DIR = File.join(Dir.home, '.releasecop')
  MANIFEST_PATH = File.join(CONFIG_DIR, 'manifest.json')
  DEFAULT_MANIFEST = "{\n  \"projects\": {\n  }\n}"
end

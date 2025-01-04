#!/usr/bin/env ruby

require 'json'

raise 'ARG: read_packages [package].json' if ARGV.empty?

input = ARGV[0]

raise 'Not a valid file' unless File.exist? input

content = File.read input

begin
  package_info = JSON.parse(content)
rescue JSON::ParserError
  raise 'Invalid JSON File'
end

scripts = package_info.fetch("scripts", {}).keys

raise 'Scripts is not an array!' unless scripts.is_a?(Array)

scripts.each do |item|
  puts item
end

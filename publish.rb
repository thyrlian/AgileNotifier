#!/usr/bin/env ruby -w

def print_msg_in_color(msg, color)
  case color
  when :red
    "\e[31m#{msg}\e[0m"
  when :green
    "\e[32m#{msg}\e[0m"
  else
    msg
  end
end

def get_gemspec_file(dir)
  gemspec_files = Dir[(dir + '/*.gemspec')]
  case gemspec_files.size
  when 1
    gemspec_file = gemspec_files.first
  when 0
    raise print_msg_in_color('No gemspec file has been found.', :red)
  else
    raise print_msg_in_color('More than one gemspec file have been found.', :red)
  end
  return gemspec_file
end

def build_gem(dir, gemspec_file)
  stdout = `gem build #{gemspec_file}`
  puts stdout
  stdout.split(/\n/).each do |line|
    md = line.strip.match(/[\w\-\.]+\.gem/)
    if md
      return md[0]
    end
  end
  return nil
end

def setup_rubygems_account(user)
  system "curl -u #{user} https://rubygems.org/api/v1/api_key.yaml > ~/.gem/credentials; chmod 0600 ~/.gem/credentials"
end

def push(gem_file)
  system("gem push #{gem_file}")
end

user = 'thyrlian'
current_dir = File.expand_path(File.dirname(__FILE__))
gemspec_file = get_gemspec_file(current_dir)
gem_file = build_gem(current_dir, gemspec_file)
setup_rubygems_account(user)
push(gem_file)

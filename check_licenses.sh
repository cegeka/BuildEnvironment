#!/usr/bin/env ruby

require 'rubygems'
gem 'cocoapods'
require 'cocoapods'
require 'optparse'

$configuration = {
    :allowed_licenses => ['MIT','BSD','Apache'],
    :dep_exceptions => []
}

OptionParser.new do |o|
    o.on('-l', '--licenses MIT,BSD,Apache', Array, "Allowed licenses (default MIT,BSD,Apache)") do |list|
        $configuration[:allowed_licenses] = list
    end
    o.on('-e', '--exceptions Project', Array, "Names of projects you want to make an exception for") do |list|
        $configuration[:dep_exceptions] = list
    end
    o.parse!
end

def license_allowed(spec) 
    return $configuration[:allowed_licenses].map(&:upcase).include?(spec.specification.license[:type].upcase)
end

def exception_for_dep(spec)
    return $configuration[:dep_exceptions].map(&:upcase).include?(spec.specification.name.upcase)
end

pods_with_fishy_license = Pod::Config.new().lockfile.pod_names.
    map { |pod_name| 
        Pod::SourcesManager.search(Pod::Dependency.new(pod_name))
    }.
    reject {|spec| 
        spec == nil || license_allowed(spec) || exception_for_dep(spec)
    }

if pods_with_fishy_license.empty?
    puts "All pods using good software licenses"
    exit 0
else
    pods_with_fishy_license.each {|spec|
        puts "error: #{spec.specification.name} has a non-standard license: #{spec.specification.license[:type]}"
        puts spec.specification.license[:text] if spec.specification.license[:text]
        puts
    }
    exit 1
end
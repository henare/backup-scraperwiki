#! /usr/bin/env ruby
# -*- encoding: utf-8 -*-

require 'rubygems'
require 'json'
require 'open-uri'
require 'grit'

username = ENV['SCRAPERWIKI_USERNAME'] || raise("SCRAPERWIKI_USERNAME not defined!!!! pls, define it.")

repository = File.dirname(__FILE__)

user_info = JSON.parse(open("http://api.scraperwiki.com/api/1.0/scraper/getuserinfo?format=jsondict&username=#{username}").read)[0]
scrapers = user_info["coderoles"]["owner"]

scrapers.each do |scraper_name|
  puts "Fetching #{scraper_name}"
  scraper_info = JSON.parse(open("http://api.scraperwiki.com/api/1.0/scraper/getinfo?format=jsondict&name=#{scraper_name}&version=-1").read)[0]

  File.open(File.join(repository, "scrapers", "#{scraper_name}.rb"), 'w') do |f|
    f << scraper_info['code']
  end
end

repo = Grit::Repo.new(repository)

Dir.chdir(repository) do
  repo.add("scrapers/*.rb")
  # FIXME: Unfortunately we have to commit all to get this to work for changed files
  repo.commit_all("Backed up ScraperWiki scrapers at #{Time.now}")
end

ENV["RACK_ENV"] = ENV["RAILS_ENV"]
require 'rubygems'
require 'bundler/setup'
require 'open-uri'
Bundler.require


class Bobangry < Sinatra::Base
  URL = Bobangry.test? ? 'http://localhost:3333' : 'http://bobanky.howaboutwe.com:3333'

  get '/bobangry' do
    begin
      xml = Nokogiri::XML(open("#{URL}/XmlStatusReport.aspx"))
      xml_projects = xml.xpath("//Project")
      @projects = xml_projects.map do |project|
        {
          name: project['name'],
          success: project['lastBuildStatus'] == 'Success',
          sha: project['lastBuildLabel']
        }
      end
    rescue
      @failure = true
    end
    haml :index
  end
end

#!/usr/bin/env ruby
require 'octokit'
require 'sinatra'
require 'json'

client = Octokit::Client.new :netrc => true, :netrc_file => '/vagrantCredentials/.netrc'

def setStatus(client, repo, commit, state, description)
	puts 'setStatus with parameters:', repo, commit, state, {'description' => description}, ' '
	client.create_status repo, commit, state, {'description' => description}
end

arguments = Array.new
ARGV.each do|a|
  arguments.push a
end 

#setStatus client, 'PalSzak/yolo-octo-dubstep', '474bf4725801b060a2840bd4983e9c67dac85b49', 'error', 'MERGE FREEZ!'

set :public_folder, File.dirname(__FILE__) + '/public'
set :bind, '0.0.0.0'


get "/" do
  redirect '/index.html'
end

get '/repos/*' do |organization|
	begin
		repos_json = Array.new
		repos = client.org_repos organization
		
		for repo in repos
			repos_json.push( {:name => repo.name, :full_name => repo.full_name} )
		end
		return repos_json.to_json
	rescue 
		return repos_json.to_json
	end
end

get '/pullrequests/*' do |repoName|
	begin
		prs_json = Array.new
		prs = client.pull_requests(repoName, :state => 'open')
		for pr in prs
			prs_json.push( {:login => pr.user.login, :title => pr.title, :sha => pr.head.sha} )
		end
		return prs_json.to_json
	rescue
		return prs_json.to_json
	end
end

post '/message' do
	status = JSON.parse request.body.read
	setStatus client, status['full_name'], status['sha'], status['state'], status['description']
	return '200 OK'
end

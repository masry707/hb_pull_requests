# frozen_string_literal: true

require 'octokit'
require 'pry-remote'
require 'dotenv'
require_relative 'hb_pull_request'

def load_env
  Dotenv.load('.env')
end

def repo
  @repo ||= ENV['REPO']
end

def access_token
  @access_token ||= ENV['PERSONAL_ACCESS_TOKEN']
end

def grouping_label
  @grouping_label ||= ENV['GROUPING_LABEL']
end

def diff_limit
  @diff_limit ||= ENV['DIFF_LIMIT'].to_i
end

def configure_client
  @configure_client ||= Octokit::Client.new(access_token: access_token)
end

def hb_pulls
  load_env

  all_pulls = configure_client.pull_requests(repo, state: 'open', per_page: 50)
  all_pulls.map do |pull|
    reviews = pull_reviews(pull)
    files = pull_files(pull)
    # pr = @client.pull_request(repo, pull.number)
    HbPullRequest.new(pr: pull, reviews: reviews, files: files)
  end
end

def pull_files(pull)
  configure_client.pull_request_files(repo, pull.number)
end

def pull_reviews(pull)
  configure_client.pull_request_reviews(repo, pull.number)
end

def sorted(pulls)
  grouped = pulls.group_by { |pull| pull.labels_list.include?(grouping_label) }
  grouped
    .each { |key, values| grouped[key] = values.sort_by(&:changes) }
    .values.flatten
end

def reviewed_by_me_count(pulls)
  pulls.select(&:reviewed_by_me?).count
end

def reached_diff_limit?(pulls)
  pulls.any? { |pr| !pr.reviewed_by_me? && pr.changes <= diff_limit }
end

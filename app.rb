# frozen_string_literal: true

require 'sinatra'
require_relative 'models/homebase_pulls'

set :bind, '0.0.0.0'

get '/' do
  @pulls = sorted(hb_pulls)
  @reviewed_by_me_count = reviewed_by_me_count(@pulls)
  @reached_diff_limit = reached_diff_limit?(@pulls)
  erb :index
end

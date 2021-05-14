require 'spec_helper'
require 'mongoid-rspec'
require 'mongoid'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'

abort("The Rails environment is running in production mode!") if Rails.env.production?
Object.send(:remove_const, :ActiveRecord)
RSpec.configure do |config|
  config.use_active_record = false

  config.use_transactional_fixtures = false

  # config.include FactoryBot::Syntax::Methods
  config.include Mongoid::Matchers, type: :model

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end

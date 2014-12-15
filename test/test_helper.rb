require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

#require 'simplecov'
#SimpleCov.start

ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
    ActiveRecord::Migration.check_pending!

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    #
    # Note: You'll currently still have to declare fixtures explicitly in integration tests
    # -- they do not yet inherit this setting
    fixtures :all

end

class ActionController::TestCase

    # Make Devise' test helpers available, like sign_in and sign_out
    include Devise::TestHelpers
    include Warden::Test::Helpers
    Warden.test_mode!

end

require 'ansi/code'
require 'turn'
require 'minitest/autorun'
require_relative '../lib/blog'

Mongoid.configure do |config|
  config.connect_to 'test-blog'
end

class MiniTest::Unit::TestCase
  def teardown
    Mongoid.default_session.collections.each do |collection|
      collection.drop unless collection.name =~ /^system\./
    end
  end
end
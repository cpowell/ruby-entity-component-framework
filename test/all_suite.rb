# This is a whole test suite.
# $ ruby test/all_suite.rb

require 'minitest/autorun' # from minitest
#require 'purdytest'
begin; require 'turn/autorun'; rescue LoadError; end
Turn.config.format = :progress

require "test/test_entity_manager"

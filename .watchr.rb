##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
#
# The Ruby Entity-Component Framework is free software: you can redistribute it
# and/or modify it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# The Ruby Entity-Component Framework is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
# General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License along
# with The Ruby Entity-Component Framework.  If not, see
# <http://www.gnu.org/licenses/>.

watch( 'test/.*_test\.rb' )     { |m| run_test_file(m[0]) }
watch( 'lib/ruby/**/(.*)\.rb' ) { |m| run_test_file("test/#{m[1]}_test.rb") }

def run(cmd)
  puts cmd
  `#{cmd}`
end

def run_test_file(file)
  system('clear')
  result = run "ruby #{file}"
  puts result
end

def run_all_tests
  @interrupted = false
  system('clear')
  result = run "ruby test/all_suite.rb"
  puts result
end

@interrupted = false

# Ctrl-C
Signal.trap 'INT' do
  if @interrupted then
    @wants_to_quit = true
    abort("\n")
  else
    puts "Interrupt a second time to quit"
    @interrupted = true
    Kernel.sleep 1.5
    # raise Interrupt, nil # let the run loop catch it
    run_all_tests
  end
end

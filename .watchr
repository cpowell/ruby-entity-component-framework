watch( 'test/test_.*\.rb' )          { |m| run_test_file(m[0]) }
watch( 'lib/lunar_lander/(.*)\.rb' ) { |m| run_test_file("test/test_#{m[1]}.rb") }

def run(cmd)
  puts cmd
  `#{cmd}`
end

def run_test_file(file)
  system('clear')
  result = run(%Q(ruby -I"minitest" -rpurdytest #{file}))
  puts result
end

def run_all_tests
  @interrupted = false
  system('clear')
  result = run "ruby --tty test/all_suite.rb"
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

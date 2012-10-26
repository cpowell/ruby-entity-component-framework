watch( 'test/test_.*\.rb' )          { |m| run_test_file(m[0]) }
watch( 'lib/lunar_lander/(.*)\.rb' ) { |md| system("ruby test/test_#{md[1]}.rb") }

def run(cmd)
  puts cmd
  `#{cmd}`
end

def run_test_file(file)
  system('clear')
  result = run(%Q(ruby -I"lib:test" -rubygems #{file}))
  #growl result.split("\n").last rescue nil
  puts result
end

def run_all_tests
  system('clear')
  result = run "rake test"
  #growl result.split("\n").last rescue nil
  puts result
end

def run_suite
  run_all_tests
end

# Ctrl-\
#Signal.trap 'QUIT' do
#  puts " --- Running all tests ---\n\n"
#  run_all_tests
#end

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
    run_suite
  end
end

configuration do |config|
  config.project_name = 'pong'
  config.output_dir = 'package'

  config.main_ruby_file = 'bin/pong'
  config.main_java_file = 'org.rubyforge.rawr.Main'

  # Compile all Ruby and Java files recursively
  # Copy all other files taking into account exclusion filter
  config.source_dirs = ['src', 'lib/ruby']
  config.source_exclude_filter = []

  config.compile_ruby_files = true
  #config.java_lib_files = []  
  config.java_lib_dirs = ['lib/java']
  #config.files_to_copy = []

  config.target_jvm_version = 1.6
  #config.jars[:data] = { :directory => 'data/images', :location_in_jar => 'images', :exclude => /bak/}
  #config.jvm_arguments = ""

  # Bundler options
  # config.do_not_generate_plist = false
end

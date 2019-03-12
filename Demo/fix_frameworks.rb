def fix_frameworks(version, relative_path = nil)
  puts " * #{$cpp_controller_name} version: " + version
  podspec_file = ''
  unless relative_path.nil?
    podspec_file = File.join(relative_path, "#{$cpp_controller_name}.podspec")
  end
  unless File.exist?(podspec_file)
    podspec_file = find_podspec_from_repo(version)
  end
  raise 'Podspecs not found!' unless File.exist?(podspec_file)
  puts ' * Podspec path ' + podspec_file
  (dynamic, static) = resolve_frameworks read_file(podspec_file)
  xcs = find_xcconfigs(File.join(__dir__, 'Pods', 'Target Support Files'))
  fix_xcconfigs(xcs, dynamic, static)
  puts 'Done!'
end

def find_xcconfigs(dir)
  xcconfigs = []
  Dir.foreach(dir) do |x|
    path = File.join(dir, x)
    if x == '.' || x == '..'
      next
    elsif File.directory?(path)
      xcconfigs += find_xcconfigs(path)
    elsif path.end_with?('.xcconfig')
      xcconfigs.push(path)
    end
  end
  xcconfigs
end

def find_podspec_from_repo(version)
  result = `pod repo list`
  begin_index = result.index('git@git.sbis.ru:sbis/core-cocoapods-specs.git')
  path_index = result.index('Path:', begin_index)
  end_index = result.index("\n", path_index)
  prefix_length = 6 # 'Path: '.length
  path = result[path_index + prefix_length, end_index - path_index - prefix_length]
  File.expand_path File.join(path, $cpp_controller_name, version, "#{$cpp_controller_name}.podspec")
end

def fix_xcconfigs(configs, dynamic, _static)
  puts '===> Processing xcconfigs'
  touched = false
  configs.each do |conf|
    text = read_file conf
    begin_index = text.index('OTHER_LDFLAGS =')
    if begin_index.nil?
      puts ' skipped: ' + conf
      next
    end
    end_index = text.index("\n", begin_index)
    prefix_length = 16 # 'OTHER_LDFLAGS = '.length
    ld_flags_text = text[begin_index + prefix_length, end_index - begin_index - prefix_length]

    result_flags = []
    ld_flags_text.split(' ').each do |flag|
      if dynamic.include? flag[1, flag.length - 2]
        touched = true
        result_flags.pop
      else
        result_flags.push flag
      end
    end

    if touched
      fixed_ld_flags_text = result_flags.join(' ')
      f = open(conf, 'w')
      f.write(text.sub(ld_flags_text, fixed_ld_flags_text))
      f.close
      puts ' fixed: ' + conf
      next
    end
    puts ' skipped: ' + conf
  end
end

def resolve_frameworks(text)
  puts '===> Resolving frameworks from podspec'
  framework_suffix = '.framework'
  begin_index = text.index('vendored_frameworks')
  end_index = text.index("\n", begin_index)
  prefix_length = 22 # 'vendored_frameworks = '.length
  frameworks = []
  text[begin_index + prefix_length, end_index - begin_index - prefix_length].split("'").each do |e|
    if e.include? framework_suffix
      e.slice!(framework_suffix)
      frameworks.push e
    end
  end
  static = []
  dynamic = []
  frameworks.each do |e|
    if !e.end_with? 'Impl' and frameworks.include?(e + 'Impl')
      static.push e
    else
      dynamic.push e
    end
  end
  [dynamic, static]
end

def read_file(file_name)
  file = File.open(file_name, 'r')
  data = file.read
  file.close
  data
end

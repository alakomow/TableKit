def dependency(name, relative_path, version = nil, source = nil)
  path = File.join(File.dirname(__FILE__), relative_path)
  puts
  puts "\e[1m\e[34m=== #{name} ===\e[0m\e[22m"
  if File.exist?(path)
    puts "\e[32m==> use local directory:\e[0m \e[37m#{path}\e[0m"
    pod name, path: path
  else
    puts "\e[31m==> directory: #{path} is not exist\e[0m"
    puts "\e[36m==> use cloud version\e[0m"
    if !version.nil? && !source.nil?
      pod name, version, source
    elsif !version.nil?
      pod name, version
    else
      pod name
    end
  end
end

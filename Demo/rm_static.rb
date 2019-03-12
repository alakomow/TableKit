def rm_static(target)
	path = File.join(File.dirname(__FILE__), "Pods/Target\ Support\ Files/#{target}/#{target}-frameworks.sh")

	oldText = '  if [[ "$(file "$binary")" == *"dynamically linked shared library"* ]]; then
    strip_invalid_archs "$binary"
  fi'

  	newText = '  if [[ "$(file "$binary")" == *"dynamically linked shared library"* ]]; then
    strip_invalid_archs "$binary"
  else
    cp FakeLib $binary
  fi'
	
	if File.exist?(path)
		text = File.read(path)
		text.sub!(oldText, newText)
		
		File.open(path, "w") { |file| file.puts text }
	end
end

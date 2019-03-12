def fix_couchbase()
	path = File.join(File.dirname(__FILE__), "Pods/couchbase-lite-ios/CouchbaseLite.framework/CouchbaseLite")
	command = "xcrun bitcode_strip -r " + path + " -o " + path
	system( command )
end


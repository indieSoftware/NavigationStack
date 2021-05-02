Pod::Spec.new do |spec|
  spec.name         = "NavStack"
	spec.version = "1.0.3" # auto-generated
	spec.swift_version = "5.3.2" # auto-generated
  spec.summary      = "A custom SwiftUI navigation framework."
  spec.description  = <<-DESC
  NavigationStack is a custom SwiftUI solution for navigating between views. It's a more flexible alternative to SwiftUI's own navigation.
                   DESC

  spec.homepage     = "https://github.com/indieSoftware/NavigationStack"
  spec.screenshots  = "https://github.com/indieSoftware/NavigationStack/blob/master/img/swiftuiTransitions.gif?raw=true", "https://github.com/indieSoftware/NavigationStack/blob/master/img/animationTransitions.gif?raw=true", "https://github.com/indieSoftware/NavigationStack/blob/master/img/customTransitions.gif?raw=true"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Sven Korset" => "sven.korset@indie-software.com" }
  spec.ios.deployment_target = "13.0"
  spec.source       = { :git => "https://github.com/indieSoftware/NavigationStack.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/NavigationStack", "Sources/NavigationStack/**/*.{swift}"
  spec.module_name   = 'NavigationStack'
end

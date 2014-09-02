Pod::Spec.new do |s|
  s.name             = "BuildEnvironment"
  s.version          = "0.1.4"
  s.summary          = "Bundles a couple of useful build scripts, and a way of keeping environment dependent properties"
  s.description      = <<-DESC
                       BuildEnvironment bundles a couple of useful build scripts

                       * Upload app to HockeyApp
                       * Translate storyboard strings
                       * Check software licenses of the used CocoaPod dependencies
                       * Automatically increment build number
                       DESC
  s.homepage         = "https://github.com/cegeka/BuildEnvironment"
  s.license          = 'MIT'
  s.author           = { "Jan Sabbe" => "jan.sabbe@cegeka.be" }
  s.source           = { :git => "https://github.com/cegeka/BuildEnvironment.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/jansabbe'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.preserve_paths = '*.sh'
  s.xcconfig = {
    'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) HOCKEYAPP_APP_ID="@\"$(HOCKEYAPP_APP_ID)\"" BUILD_ENVIRONMENT="@\"$(CONFIGURATION)\""'
  }
end

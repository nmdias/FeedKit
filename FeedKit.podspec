Pod::Spec.new do |s|
  s.name = 'FeedKit'
  s.version = '9.1.2'
  s.license = 'MIT'
  s.summary = 'An RSS, Atom and JSON Feed parser written in Swift'
  s.homepage = 'https://github.com/nmdias/FeedKit'
  s.authors = { 'Nuno Manuel Dias' => 'nmdias.pt@gmail.com' }
  s.source = { :git => 'https://github.com/nmdias/FeedKit.git', :tag => s.version }
  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '3.0'
  s.source_files = 'Sources/**/*.swift'
  s.swift_versions = ['5.0', '5.1']
end

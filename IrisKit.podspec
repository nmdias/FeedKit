Pod::Spec.new do |s|
  s.name = 'IrisKit'
  s.version = '1.1.0'
  s.license = 'MIT'
  s.summary = 'An RSS/Atom feed parser'
  s.homepage = 'https://github.com/nmdias/IrisKit'
  s.authors = { 'Nuno Manuel Dias' => 'nmdias.pt@gmail.com' }
  s.source = { :git => 'https://github.com/nmdias/IrisKit.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'
  s.source_files = 'Sources/**/*.swift'
end

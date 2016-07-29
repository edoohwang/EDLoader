Pod::Spec.new do |s|
  s.name         = 'EDLoader'
  s.version      = '0.0.4'
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.homepage     = 'https://github.com/edoohwang'
  s.authors      = { 'edoohwang' => 'edoohwang@gmail.com' }
  s.summary      = 'This is a View can add to UIScrollView, then load more data through pull and drag action'

  s.platform     =  :ios, '9.0'
  s.source       =  { :git => 'https://github.com/edoohwang/EDLoader.git', :tag => s.version }
  s.source_files = 'EDLoader/EDLoader/**/*.{swift}'
  s.resource     = 'EDLoader/EDLoader/**/*.bundle'
  s.requires_arc = true
  
# Pod Dependencies

end
Pod::Spec.new do |s|
s.name = 'HDCommonTools'
s.version = '1.0.0'
s.license= { :type => "MIT", :file => "LICENSE" }
s.summary = 'HDCommonTools，一个常用功能函数的封装库'
s.homepage = 'https://github.com/DamonHu/HDCommonTools'
s.authors = { 'DamonHu' => 'dong765@qq.com' }
s.source = { :git => "https://github.com/DamonHu/HDCommonTools.git", :tag => s.version}
s.requires_arc = true
s.ios.deployment_target = '9.0'
s.source_files = "HDCommonTools/HDCommonTools/SimulateIDFA/*.{h,m}","HDCommonTools/HDCommonTools/*.{h,m}"
s.frameworks = 'UIKit','Foundation'
s.documentation_url = 'http://www.hudongdong.com/ios/758.html'
end
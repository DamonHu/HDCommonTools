Pod::Spec.new do |s|
s.name = 'HDCommonTools'
s.version = '2.5.4'
s.license= { :type => "MIT", :file => "LICENSE" }
s.summary = 'HDCommonTools,一句代码即可实现多种常用功能.A short code can achieve a variety of commonly used functions.'
s.homepage = 'https://github.com/DamonHu/HDCommonTools'
s.authors = { 'DamonHu' => 'dong765@qq.com' }
s.source = { :git => "https://github.com/DamonHu/HDCommonTools.git", :tag => s.version}
s.requires_arc = true
s.ios.deployment_target = '9.0'
s.source_files = "HDCommonTools/HDCommonTools/SimulateIDFA/*.{h,m}","HDCommonTools/HDCommonTools/*.{h,m}","HDCommonTools/HDCommonTools/CalenderConverter/*.{h,m}"
s.frameworks = 'UIKit','Foundation'
end
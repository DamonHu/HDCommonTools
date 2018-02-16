Pod::Spec.new do |s|
s.name = 'HDCommonTools'
s.version = '1.1.1'
s.license= { :type => "MIT", :file => "LICENSE" }
s.summary = 'HDCommonTools,一句代码即可实现多种常用功能.数据处理、文件管理、多媒体管理、权限管理、系统信息等几种不同的类型封装.'
s.homepage = 'https://github.com/DamonHu/HDCommonTools'
s.authors = { 'DamonHu' => 'dong765@qq.com' }
s.source = { :git => "https://github.com/DamonHu/HDCommonTools.git", :tag => s.version}
s.requires_arc = true
s.ios.deployment_target = '9.0'
s.source_files = "HDCommonTools/HDCommonTools/SimulateIDFA/*.{h,m}","HDCommonTools/HDCommonTools/*.{h,m}"
s.frameworks = 'UIKit','Foundation'
s.documentation_url = 'http://www.hudongdong.com/ios/796.html'
end
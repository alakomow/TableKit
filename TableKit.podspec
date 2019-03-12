Pod::Spec.new do |s|
    s.name                  = 'SbisTableKit'
    s.module_name           = 'SbisTableKit'

    s.version               = '0.0.0.1'

    s.homepage              = 'www.tensor.ru'
    s.summary               = 'Type-safe declarative table views with Swift.'

    s.author                = { 'Lakomov Artem' }
    s.license               = { 'Tensor' }
    s.platforms             = { :ios => '11.0' }
    s.ios.deployment_target = '11.0'
    spec.requires_arc = true

    s.source                = { :git => 'git@git.sbis.ru:mobileworkspace/ios-sbis-components.git', :tag => 'rc-' + s.version.to_s }

    s.subspec 'Code' do |ss|
        ss.source_files     = 'Sources/**/*.swift'
    end
end

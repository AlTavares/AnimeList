
platform :ios, '12.0'
plugin 'cocoapods-binary'
use_frameworks!
all_binary!


# Utility
def utility
    pod 'SwiftyBeaver', :configurations => ['Debug']
    pod 'Weakify', :configurations => ['Debug']
end

# UI
def ui
    pod 'SkeletonView', :configurations => ['Debug']
    pod 'MKProgress', :configurations => ['Debug']
    pod 'AloeStackView', :configurations => ['Debug']
    pod 'SwiftRichString', :configurations => ['Debug']
end

# RX 
def rx
    pod 'RxSwift', :configurations => ['Debug']
    pod 'RxAtomic', :configurations => ['Debug']
    pod 'RxCocoa', :configurations => ['Debug']
    pod 'RxBiBinding', :configurations => ['Debug']
    pod 'RxSwiftExt', :configurations => ['Debug']
    pod 'RxViewController', :configurations => ['Debug']
end

# Networking
def networking
    pod 'Nappa', :configurations => ['Debug']
    pod 'Kingfisher', :configurations => ['Debug']
end

target 'AnimeList' do
    utility
    ui
    rx
    networking
end

target 'AnimeListTests' do
    rx
end

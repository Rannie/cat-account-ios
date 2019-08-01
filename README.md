# CatAccounting

记账类工具**喵账簿** iOS 客户端仓库

[<img src="https://cloud.githubusercontent.com/assets/219689/5575342/963e0ee8-9013-11e4-8091-7ece67d64729.png" width="120" alt="AppStore"/>](https://apps.apple.com/cn/app/id1308678908)

<img src="https://github.com/Rannie/cat-account-ios/blob/master/screens/Screen%20Shot%202019-08-01%20at%209.25.41%20AM.png" width="25%"><img src="https://github.com/Rannie/cat-account-ios/blob/master/screens/Screen%20Shot%202019-08-01%20at%209.27.13%20AM.png" width="25%"><img src="https://github.com/Rannie/cat-account-ios/blob/master/screens/Screen%20Shot%202019-08-01%20at%209.27.26%20AM.png" width="25%"><img src="https://github.com/Rannie/cat-account-ios/blob/master/screens/Screen%20Shot%202019-08-01%20at%209.27.35%20AM.png" width="25%"> 

只是一款本地记账工具，不支持同步功能。

应该不再更新了，开源出来方便一些初学者学习 iOS , 当然如果有好的功能建议也可以提 issue   或者 PR 。

## Setup

1. clone
2. pod install
3. 在 Pods 里找到 Chart Target 的编译设置, 并将其中的 Swift 版本切换到 Swift 4

## Stack

* 语言为 Objective-C
* 布局大部分使用 Masonry
* UI 基于 QMUI
* 数据库及 Key-Value 使用的 WCDB
* 图表为 Charts
* 打包一开始 TF 还不属于 Apple，那时候使用的 FIR， 后来用的 TF + Fastlane，由于里面有些账号信息所以不放上来了

## License

MIT License



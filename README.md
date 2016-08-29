#EDLoader
---

These UIScrollView categories makes it super easy to add pull-to-refresh or pull-to-load and infinite scrolling fonctionalities to any UIScrollView (or any of its subclass). Instead of relying on delegates and/or subclassing UIViewController, EDLoader uses the Swift to build,faster and easier:

```
tableView.ed_topLoader = EDNormalTopLoader(target: self, action: #selector(myLoadDataMethod))
tableView.ed_footLoader = EDNormalFootLoader(target: self, action: #selector(myLoadMorDataMethod))
```

![](http://note.youdao.com/yws/public/resource/94b2683f6df79feaa5a01f42b81491ec/WEBRESOURCEe0d548c7844f4758dfbae90afa98b725)
![](http://note.youdao.com/yws/public/resource/94b2683f6df79feaa5a01f42b81491ec/WEBRESOURCE2e34d0ddda0131e0c5f79f19a0bc4b97)
![](http://note.youdao.com/yws/public/resource/94b2683f6df79feaa5a01f42b81491ec/WEBRESOURCEd3edca91b80a2430a76e8ba3a7edd21d)

##Installation
---
### CocoaPods

Add pod 'EDLoader' to your Podfile or pod 'EDLoader', :head if you're feeling adventurous.

### Manually
Drag the EDLoader/EDLoader folder into your project.

##Usage
---

###Adding Pull to Refresh
(see sample Xcode project in DownloadZip)

```Swift
tableView.ed_topLoader = EDNormalTopLoader(target: self, action: #selector(myLoadDataMethod))
```
if you want to load data immediately,you can follow it:

```Swift
tableView.ed_topLoader.beginLoading()
```

or if you want pull to refresh from the bottom

```Swift
tableView.ed_footLoader = EDNormalFootLoader(target: self, action: #selector(myLoadMorDataMethod))
```

if you like to finish loader animation and stop load, you can do with:

```Swift
tableView.ed_topLoader.endLoading()
tableView.ed_footLoader.endLoading()
```

if your app can't not load more data, you can't stop footLoaer invoke the method and change the state with:

```Swift
tableView.ed_footLoader.noMoreData()
```

###Customization
---

The EDTopLoader and subclass view can be customized using your class inherit and override the setupSurface method:

```Swift
import UIKit

class MyTopLoader: EDCustomTopLoader {
    override func setupSurface() {
        super.setupSurface()
        setImage(UIImage(named: "loaderFreeImage")!, state: EDLoaderState.free)
        setImage(UIImage(named: "loaderWollLoadImage")!, state: EDLoaderState.willLoad)
        setImage(UIImage(named: "LoaderloadingImage")!, state: EDLoaderState.loading)
    }
}
```

###Adding Infinite Scrolling
---

```Swift
tableView.ed_footLoader = EDAutoFootLoader(target: self, action: #selector(myLoadMorDataMethod))
```
the footloader automatic to begin loading when the percentage of footLoader did show, default is 0.8, and you can set it what you like:

```Swift
tableView.ed_footLoader.percentFootLoaderDidShowToLoading = whatYouLikePercentage
```

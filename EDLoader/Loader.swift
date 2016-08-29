

import UIKit

class Loader: EDCustomTopLoader {
    override func setupSurface() {
        super.setupSurface()
        setImage(UIImage(named: "tableview_pull_refresh")!, state: EDLoaderState.free)
        setImage(UIImage(named: "tableview_pull_refresh-1")!, state: EDLoaderState.willLoad)
        setImage(UIImage(named: "tableview_loading")!, state: EDLoaderState.loading)
    }
}

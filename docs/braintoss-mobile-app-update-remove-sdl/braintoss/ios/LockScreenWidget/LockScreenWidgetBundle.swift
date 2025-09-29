import WidgetKit
import SwiftUI

@main
struct LockScreenWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        LockScreenWidget()  
    }
}

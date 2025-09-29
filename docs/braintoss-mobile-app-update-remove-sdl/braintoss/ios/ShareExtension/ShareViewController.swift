import UIKit
import Social
import MobileCoreServices
import Photos
import receive_sharing_intent


class ShareViewController: RSIShareViewController {

}

extension Array {
    subscript (safe index: UInt) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
    }
}

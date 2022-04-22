//
// Copyright © 2018 ProovGroup. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    // use `topViewController` properties
    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let visibleViewController = self.visibleViewController {
            // `UIAlertController` call `UINavigationController` methods
            if visibleViewController is UIAlertController {
                return super.preferredInterfaceOrientationForPresentation
            }

            return visibleViewController.preferredInterfaceOrientationForPresentation
        }

        return super.preferredInterfaceOrientationForPresentation
    }

    // use `topViewController` properties
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let visibleViewController = self.visibleViewController {
            // `UIAlertController` call `UINavigationController` methods
            if visibleViewController is UIAlertController {
                return super.supportedInterfaceOrientations
            }

            return visibleViewController.supportedInterfaceOrientations
        }

        return super.supportedInterfaceOrientations
    }
}

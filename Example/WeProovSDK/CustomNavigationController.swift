//
// Copyright © 2018 ProovGroup. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    // use `topViewController` properties
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
    
}

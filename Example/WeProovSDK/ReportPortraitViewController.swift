//
// Copyright © 2018 ProovGroup. All rights reserved.
//

import UIKit
import WeProovSDK

class ReportPortraitViewController: WPReportViewController {
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

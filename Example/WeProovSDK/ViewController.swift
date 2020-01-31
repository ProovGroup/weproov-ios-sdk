//
// Copyright © 2018 ProovGroup. All rights reserved.
//

import UIKit
import WeProovSDK

class ViewController: UIViewController, WPUserDelegate {
    
    func userDidConnect(user: WPUser){
        print("WeProov Connected")
    }
    
    /// Tells the delegate when the user failed to connect
    func userFailedToConnect(user: WPUser, error: Error?){
        print("WeProov Connect Error \(error!.localizedDescription)")
    }

    private var downloader = WPReportDownloader()
    private let useCustomView = true

    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var proovCodeField: UITextField!

    @objc
    func openReport() {
         if let proovCode = self.proovCodeField.text {
            if useCustomView {
                let controller = CustomViewController()
                controller.proovCode = proovCode
                controller.view.backgroundColor = UIColor.white
                if let nc = navigationController {
                    nc.pushViewController(controller, animated: true)
                } else {
                    present(controller, animated: true, completion: nil)
                }

            } else {
                self.downloader.delegate = self
                self.downloader.load(proovCode: proovCode)
            }
        }
    }

    override func viewDidLoad() {
    	super.viewDidLoad()
        WPUser.shared.logout()
        WPUser.shared.delegate = self
        if !WPUser.shared.connected {
            WPUser.shared.connect(token: "<TOKEN>", secret: "<SECRET>")
        }
        openButton.addTarget(self, action: #selector(openReport), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        WPLocationService.shared.startUpdateLocation()
    }

}

extension ViewController: WPReportDownloadViewControllerDelegate {
    func reportCancelDownload() {
        downloader.delegate = nil
        downloader = WPReportDownloader()
        downloader.delegate = self
    }
}

extension ViewController: WPReportDownloaderDelegate {
    func reportLoading(downloader _: WPReportDownloader) {}

    func reportLoadingProgress(downloader _: WPReportDownloader, progress: Float) {
        if let controller = presentedViewController as? WPReportDownloadViewController {
            controller.updateProgression(value: progress)
        }
    }
    // appeler lors de la fin du chargement du raport
    func reportDidLoad(downloader _: WPReportDownloader, report: WPReport) {
        if let controller = presentedViewController as? WPReportDownloadViewController {
            controller.updateProgression(value: 1)
            controller.dismiss(animated: true)
        }
        // Creation d'un theme pour changer les couleur
        let theme = WPTheme()
        // change la couleur pour le rapport initial
        theme.reportInitialColor = UIColor(red: 103 / 255, green: 187 / 255, blue: 15 / 255, alpha: 1)
        // change la couleur pour le rapport final
        theme.reportFinalColor = UIColor(red: 103 / 255, green: 187 / 255, blue: 15 / 255, alpha: 1)
        // creer une vue totalement manager en chengant le theme
        let controller = WPReportViewController(report: report, theme: theme)
        if let nc = navigationController {
            nc.pushViewController(controller, animated: true)
        } else {
            present(controller, animated: true, completion: nil)
        }
    }

    func reportFailedToLoad(downloader _: WPReportDownloader, error: Error?) {
        if let controller = presentedViewController as? WPReportDownloadViewController {
            controller.dismiss(animated: true)
        }
        print("reportFailedToLoad", error ?? "unknown error")
    }

    func reportCanShowSection(downloader _: WPReportDownloader, section: Int) -> Bool {
        if section < 1 {
            return false
        }
        return true
    }

    func reportCanShowSectionImport(downloader _: WPReportDownloader, section _: Int) -> Bool {
        return false
    }
}

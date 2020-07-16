//
// Copyright © 2018 ProovGroup. All rights reserved.
//

import UIKit
import WeProovSDK

class CustomViewController: UIViewController {
    var proovCode: String = ""
    private var downloader = WPReportDownloader()
    private var manager: WPReportManager?

    var reportView  = WPReportView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(reportView)
        reportView.snp.makeConstraints {make in
            make.bottom.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp.topMargin)
        }
        downloader.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = manager {
            return
        }
        
        // initialise la popup de telechargement
        let controller = WPReportDownloadViewController()

        // set la classe actuel comde delegate
        controller.delegate = self
        // presente la page de download
        present(controller, animated: true) { [weak self] in
            guard let sself = self else {
                return
            }
            sself.downloader.load(proovCode: sself.proovCode)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // permet de fermer proprement le rapport
        manager?.closeReport()
    }
}

extension CustomViewController: WPReportDownloaderDelegate {
    func reportLoading(downloader _: WPReportDownloader) {}

    func reportLoadingProgress(downloader _: WPReportDownloader, progress: Float) {
        if let controller = presentedViewController as? WPReportDownloadViewController {
            controller.updateProgression(value: progress)
        }
    }

    func reportDidLoad(downloader _: WPReportDownloader, report: WPReport) {
        if let controller = presentedViewController as? WPReportDownloadViewController {
            controller.updateProgression(value: 1)
            controller.dismiss(animated: true)
        }
        let theme = WPTheme()
        // Personalise les couleurs principal du framework
        theme.reportInitialColor = UIColor(red: 103 / 255, green: 187 / 255, blue: 15 / 255, alpha: 1)
        theme.reportFinalColor = UIColor(red: 103 / 255, green: 187 / 255, blue: 15 / 255, alpha: 1)
        theme.termsOfService = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."
        theme.termsOfServiceURL = URL(string: "https://www.example.com/tos")!
        theme.privacyURL = URL(string: "https://www.example.com/privacy")!
        
        manager = WPReportManager(controller: self, report: report, theme: theme, enableDamageList: true)
        manager?.delegate = self
        manager?.load(reportView: reportView)
    }

    func reportFailedToLoad(downloader _: WPReportDownloader, error: Error?) {
        if let controller = presentedViewController as? WPReportDownloadViewController {
            controller.dismiss(animated: true)
        }
        dismiss(animated: true)
        print("reportFailedToLoad", error ?? "unknown error")
    }

    // permet de savoir si le la page d'une section dois etre visible ou non
    func reportCanShowSection(downloader _: WPReportDownloader, section: Int) -> Bool {
        return true
    }

    // permet de savoir si la page peremet d'importer depuis son part / profile
    // attention permet de voire tout le carnet d'adresse / parc de bien
    func reportCanShowSectionImport(downloader _: WPReportDownloader, section _: Int) -> Bool {
        return false
    }
}

extension CustomViewController: WPReportManagerDelegate {
    func reportCurrentSectionDidChange(manager: WPReportManager, section: Int) {
        title = manager.sections[section]
    }

    func reportDidClose(manager _: WPReportManager, state: WPReportCloseState) {
        navigationController?.popViewController(animated: true)
    }
}

extension CustomViewController: WPReportDownloadViewControllerDelegate {
    func reportCancelDownload() {
        // Cannot stop downloader, so create a new one
        downloader.delegate = nil
        downloader = WPReportDownloader()
        downloader.delegate = self
    }
}

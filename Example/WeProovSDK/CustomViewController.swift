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
            controller.dismiss()
        }
        var theme = WPTheme()
        // Personalise les couleurs principal du framework
        theme.reportInitialColor = UIColor(hexString: "#67BB0F9")
        theme.reportFinalColor = UIColor(hexString: "#67BB0F9")

        manager = WPReportManager(controller: self, report: report, theme: theme)
        manager?.delegate = self
        manager?.load(reportView: reportView)
    }

    func reportFailedToLoad(downloader _: WPReportDownloader, error: Error?) {
        if let controller = presentedViewController as? WPReportDownloadViewController {
            controller.dismiss()
        }
        dismiss()
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
    func reportCurrentSectionDidChanged(manager: WPReportManager, section: Int) {
        title = manager.sections[section]
    }

    func reportClosed(manager _: WPReportManager) {
        dismiss()
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

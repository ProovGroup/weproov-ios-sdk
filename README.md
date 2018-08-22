# WeProovSDK

[![CI Status](https://img.shields.io/travis/ProovGroup/weproov-ios-sdk.svg?style=flat)](https://travis-ci.org/ProovGroup/weproov-ios-sdk)
[![Version](https://img.shields.io/cocoapods/v/WeProovSDK.svg?style=flat)](https://cocoapods.org/pods/WeProovSDK)
[![License](https://img.shields.io/cocoapods/l/WeProovSDK.svg?style=flat)](https://cocoapods.org/pods/WeProovSDK)
[![Platform](https://img.shields.io/cocoapods/p/WeProovSDK.svg?style=flat)](https://cocoapods.org/pods/WeProovSDK)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

WeProovSDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WeProovSDK'
```

### Include Framwork

Dans le build setting verifier que la variable ``Enable bitcode`` est parametrer sur ``no`` (``ENABLE_BITCODE = NO``)

### Info.plist

Allouer à l'app les droits de mise a jour en tache de fond  
```
Background Fetch: capabilities -> Background Mode -> Background Fetch
```

Ajouter les clées n'ecessaire pour avoir access a la camera et au gps dans 
``Info.plist``
```
<key>NSCameraUsageDescription</key>
<string>Camera is required</string> 
<key>NSContactsUsageDescription</key>
<string>Contacts required</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Location required</string>
```

### Import

```
import WeProovSDK
```

### Connection 

Pour connceter le SDK avec WeProov 
```
// permet de s'avoire si le SDK est connecté
WPUser.shared.connected
// permet de se connecter avec un token et un secret
WPUser.shared.connect(token: "<TOKEN>", secret: "<SECRET>")
// pour changer la lang default: "en"
WPUser.shared.lang = "fr"
```

### Upload background

Allouer à l'app les droits de mise a jour en tache de fond :   
``Background Fetch``  capabilities -> Background Mode -> Background Fetch
WeProov utilise les BackgroundURLSession pour upload le rapport en background
au lancement de l'app appeler: `` WPReportUploader.shared.sync() ``
gerer l'evenement dans le ``AppDelegate``:

```
    func application(_: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        if WPReportUploader.shared.handleEventsForBackgroundURLSession(identifier: identifier, completionHandler: completionHandler) {
            return
        }
        
        completionHandler()
    }
```

## Exemple:

### AppDelegate

```

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        ...
        if !WPUser.shared.connected {
            WPUser.shared.connect(token: "<TOKEN>", secret: "<SECRET>")
        }
        WPReportUploader.shared.sync()
        ...
        return true
    }


    func application(_: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        if WPReportUploader.shared.handleEventsForBackgroundURLSession(identifier: identifier, completionHandler: completionHandler) {
            return
        }
        
        completionHandler()
    }
```

### Custom View 

Nous allons faire en sorte que des que la vue est charger nous lancer un proovcode contenue dans le viewController
```
class CustomViewController: UIViewController {
  // Contiens le proovCode à ouvrir 
  var proovCode:String = ""
  // downloader: permet de télécharger un rapport
  private var downloader = WPReportDownloader()
  // permet d'etre prevenue quand le rapport se termine
  private var manager: WPReportManager?
  
  // Initialise une vue raport qui vas etre imbriquer
  var reportView: WPReportView = WPReportView()
  
  override func viewDidLoad() {
      super.viewDidLoad()
      // ajoute la vue rapport an laissans la marge pour le header des iPhone X
      self.view.addSubview(reportView)
      reportView.snp.makeConstraints{make in
          make.bottom.left.right.equalTo(self.view)
          make.top.equalTo(self.view.snp.topMargin)
      }
      // ajoute comme delegate au downloader cette class
      downloader.delegate = self
  }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
```
### WPReportManagerDelegate
```
extension CustomViewController: WPReportManagerDelegate {
    // permet de recuperer quand l'utiliser change de page  
    func reportCurrentSectionDidChanged(manager: WPReportManager, section: Int) {
        title = manager.sections[section]
    }
    // appeler quand le rapport est fermer  
    func reportClosed(manager _: WPReportManager) {
        dismiss()
    }
}
```

### WPReportDownloadViewControllerDelegate

```
extension CustomViewController: WPReportDownloadViewControllerDelegate {
    func reportCancelDownload() {
        // Cannot stop downloader, so create a new one
        downloader.delegate = nil
        downloader = WPReportDownloader()
        downloader.delegate = self
    }
}
```

### WPReportDownloaderDelegate
```
extension CustomViewController: WPReportDownloaderDelegate {
    func reportLoading(downloader _: WPReportDownloader) {}
    
    // appeler lors de la progression du telechargement
    func reportLoadingProgress(downloader _: WPReportDownloader, progress: Float) {
        if let controller = presentedViewController as? WPReportDownloadViewController {
            controller.updateProgression(value: progress)
        }
    }

    // appeler lorsque le rapport est pres a etre afficher
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
    
    // si une erreur survient 
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
```

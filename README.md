# WeProovSDK

[![CI Status](https://img.shields.io/travis/ProovGroup/weproov-ios-sdk.svg?style=flat)](https://travis-ci.org/ProovGroup/weproov-ios-sdk)
[![Version](https://img.shields.io/cocoapods/v/WeProovSDK.svg?style=flat)](https://cocoapods.org/pods/WeProovSDK)
[![License](https://img.shields.io/cocoapods/l/WeProovSDK.svg?style=flat)](https://cocoapods.org/pods/WeProovSDK)
[![Platform](https://img.shields.io/cocoapods/p/WeProovSDK.svg?style=flat)](https://cocoapods.org/pods/WeProovSDK)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Migration 1.4.x to 1.5.x

If you were using version 1.4.x and need to update to 1.5.x please contact us to upgrade you access to the version. Thank you.

## Installation

WeProovSDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WeProovSDK', :git => 'https://github.com/ProovGroup/weproov-ios-sdk'
```

Le repository utilise git lfs avant de faire un pod install verifier que se dernier est installé.
https://git-lfs.github.com/

### Info.plist

Allouer à l'app les droits de mise à jour en tache de fond  
```
Background Fetch: capabilities -> Background Mode -> Background Fetch
```

Ajouter les clées nécessaires pour avoir accès à la camera et au gps dans 
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

Pour connecter le SDK avec WeProov avant 1.5.x
```
// permet de s'avoire si le SDK est connecté
WPUser.shared.connected
// permet de se connecter avec un token et un secret
WPUser.shared.connect(token: "<TOKEN>", secret: "<SECRET>")
// pour changer la lang default: "en"
WPUser.shared.lang = "fr"
```
Pour connecter le SDK avec WeProov a partir de 1.5.x
```
// permet de s'avoire si le SDK est connecté
WPUser.shared.connected
//Donne les credentials au sdk
WPUser.shared.setAppAuthCredentials(clientID: "<TOKEN>", secret: "<SECRET>")
// permet de se connecter avec un token et un secret
// A partir de > 1.5.1 cette methode ne prendra plus d'arguments
WPUser.shared.connect(token: "<TOKEN>", secret: "<SECRET>")
// pour changer la lang default: "en"
WPUser.shared.lang = "fr"
```

### Upload background

Allouer à l'app les droits de mise à jour en tâche de fond :   
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
	    WPUser.shared.setAppAuthCredentials(clientID: "<TOKEN>", secret: "<SECRET>")
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
WPUserDelegate
```
    func userDidConnect(user: WPUser){
        print("WeProov Connected")
    }
    
    /// Tells the delegate when the user failed to connect
    func userFailedToConnect(user: WPUser, error: Error?){
        print("WeProov Connect Error \(error!.localizedDescription)")
    }
```

### Custom View 

Nous allons faire en sorte que lorsque la vue est chargée nous lançons un proovcode contenu dans le viewController
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // permet de fermer proprement le rapport
        manager?.closeReport()
    }
}
```
### WPReportManagerDelegate
```
extension CustomViewController: WPReportManagerDelegate {
    // appelé à chaque changement de page
    func reportCurrentSectionDidChange(manager: WPReportManager, section: Int) {
        title = manager.sections[section]
    }

    // appelé quand le rapport est fermé  
    func reportDidClose(manager: WPReportManager, state: WPReportCloseState) {
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
        return true
    }
}
```

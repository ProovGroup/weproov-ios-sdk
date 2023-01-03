# WeProovSDK

[![CI Status](https://img.shields.io/travis/ProovGroup/weproov-ios-sdk.svg?style=flat)](https://travis-ci.org/ProovGroup/weproov-ios-sdk)
[![Version](https://img.shields.io/cocoapods/v/WeProovSDK.svg?style=flat)](https://cocoapods.org/pods/WeProovSDK)
[![License](https://img.shields.io/cocoapods/l/WeProovSDK.svg?style=flat)](https://cocoapods.org/pods/WeProovSDK)
[![Platform](https://img.shields.io/cocoapods/p/WeProovSDK.svg?style=flat)](https://cocoapods.org/pods/WeProovSDK)

## Version 1.6.2

WeProovSDK 1.6.1 a été réaliser avec XCode 13.4.1 et le Compilateur Swift 5.6
La version minimum nécessaire est 12.1

Certaines contrainte de développement nous oblige à utiliser uniquement la version arm64 de notre build il est donc impossible d'utiliser les simulateurs.

En dehors de ces critères, nous ne sommes pas en mesure d'assurer le bon fonctionnement de notre SDK.
Tout cas en dehors de ces critères necessitera une demande de développement.

⚠️ Attention: Depuis XCode 14.0.1 utiliser bitcode est déprécié. il sera donc nécessaire de désactiver le bitcode dans les paramètres de votre projet.

La fonction init de la classe WPReportManager à changé et ne contient plus le paramètre suivant `enableDamageList:Bool`. Ceci s'explique car l'option n'est pas disponble pour les développeurs. 

🚑  Correction :

- Correction du bug empêchant le bon déroulement du traitement des photos.
- Mise à jour de la pop-up de téléchargement contenant une barre de progression pour confirmer que le rapport a bien été envoyé à un contrôleur.

## Exemple

Pour exécuter le projet exemple, cloner le repo, et exécuter la commande `pod install` depuis le dossier Example dans un premier temps.

## Prérequis

## Migration 1.4.x to 1.5.x

Si vous utilisez la version 1.4.x et nécessite une mise à jours vers la version 1.5.x merci de nous contacter pour mettre à jours vos accès à la nouvelle version. Merci.

## Instatllation

WeProovSDK est disponible sur CocoaPods [CocoaPods](https://cocoapods.org). Pour l'installer, ajouter simplement la ligne suivante à votre Podfile:

```ruby
target 'YOUR_PROJECT' do
  pod 'WeProovSDK', :git => 'https://github.com/ProovGroup/weproov-ios-sdk'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.1'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
end
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
// permet de savoir si le SDK est connecté
WPUser.shared.connected
// permet de se connecter avec un token et un secret
WPUser.shared.connect(token: "<TOKEN>", secret: "<SECRET>")
// pour changer la langue default: "en"
WPUser.shared.lang = "fr"
```
Pour connecter le SDK avec WeProov a partir de 1.5.x
```
// permet de savoir si le SDK est connecté
WPUser.shared.connected
//Donne les credentials au sdk
WPUser.shared.setAppAuthCredentials(clientID: "<TOKEN>", secret: "<SECRET>")
// permet de se connecter avec un token et un secret
// A partir de > 1.5.1 cette methode ne prendra plus d'arguments
WPUser.shared.connect(token: "<TOKEN>", secret: "<SECRET>")
// pour changer la langue default: "en"
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
    
    /// Indication du delegate quand la connexion de l'utilisateur à échoué
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
        // Il est impossible d'arreter le downloader, donc créez en un nouveau
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
    
    // appelé lors de la progression du telechargement
    func reportLoadingProgress(downloader _: WPReportDownloader, progress: Float) {
        if let controller = presentedViewController as? WPReportDownloadViewController {
            controller.updateProgression(value: progress)
        }
    }

    // appelé lorsque le rapport est prèt à être affiché
    func reportDidLoad(downloader _: WPReportDownloader, report: WPReport) {
        if let controller = presentedViewController as? WPReportDownloadViewController {
            controller.updateProgression(value: 1)
            controller.dismiss()
        }
        
        var theme = WPTheme()
        // Personalise les couleurs principales du framework
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
    
    // permet de savoir si la page d'une section dois etre visible ou non
    func reportCanShowSection(downloader _: WPReportDownloader, section: Int) -> Bool {
        return true
    }

    // permet de savoir si la page permet d'importer depuis son part / profile
    // attention permet de voir tout le carnet d'adresse / parc de bien
    func reportCanShowSectionImport(downloader _: WPReportDownloader, section _: Int) -> Bool {
        return true
    }
}
```

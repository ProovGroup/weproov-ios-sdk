// Objective-C API for talking to bitbucket.org/weproov/weproovstrucgo/config Go package.
//   gobind -lang=objc bitbucket.org/weproov/weproovstrucgo/config
//
// File is generated by gobind. Do not edit.

#ifndef __Config_H__
#define __Config_H__

@import Foundation;
#include "Universe.objc.h"


@class ConfigEnvironment;

@interface ConfigEnvironment : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
/**
 * 		Permet de savoir si le framwork est en mode production ou en mode developement
 */
- (BOOL)production;
- (void)setProduction:(BOOL)v;
/**
 * 		represent l'api prensente pour les requettes
 */
- (NSString*)baseUrl;
- (void)setBaseUrl:(NSString*)v;
/**
 * 		represent l'api qui est la pour les donner stocker en cache
		principalement des images
 */
- (NSString*)cacheUrl;
- (void)setCacheUrl:(NSString*)v;
/**
 * 		Serverless est un service qui a pour vocation de remplacer
		le server definie par BaseUrl
 */
- (NSString*)serverless;
- (void)setServerless:(NSString*)v;
/**
 * 		OldApi est utilser que pour l upload de l avatar
		il serais peut etre judicieux de la retirer
 */
- (NSString*)oldApi;
- (void)setOldApi:(NSString*)v;
- (NSString*)device;
- (void)setDevice:(NSString*)v;
/**
 * 		Permet de stocker la langue du telephone
		CETTE VARIABLE EST TRES IMPORTANTE
 */
- (NSString*)local;
- (void)setLocal:(NSString*)v;
- (NSString*)getOldUrl:(NSString*)path;
- (NSString*)getServerlessUrl:(NSString*)path;
/**
 * 	Permet de recuperer l'url de l'api pour les requete
 */
- (NSString*)getUrl:(NSString*)path;
@end

@interface Config : NSObject
/**
 * 	ATENTION LES VARIABLE PRESENTE DANS CE PACKAGE PEUVENT INFLIANCER TOUT LES AUTRE
 */
+ (ConfigEnvironment*) env;
+ (void) setEnv:(ConfigEnvironment*)v;

@end

/**
 * 	retourne la dernier lang enregistrer comme default
 */
FOUNDATION_EXPORT NSString* ConfigGetDefaultLocal(void);

FOUNDATION_EXPORT BOOL ConfigGetModeSaved(void);

FOUNDATION_EXPORT NSString* ConfigGetNotificationToken(void);

FOUNDATION_EXPORT BOOL ConfigIsAndroid(void);

FOUNDATION_EXPORT BOOL ConfigIsIos(void);

/**
 * 	Permet de savoir si l'environement est celuis de production
 */
FOUNDATION_EXPORT BOOL ConfigIsProduction(void);

/**
 * 	Restor la dernier lang designer comme default comme lang actulement utiliser
 */
FOUNDATION_EXPORT void ConfigResetLocal(void);

/**
 * 	Permet de signaler la langue souhaiter
	en premier parametre le lange formater 'fr', 'en', ...
	en second permet de savoir si il faut le sauvgarder dans comme lang par default
 */
FOUNDATION_EXPORT void ConfigSetLocal(NSString* local, BOOL isDefault);

/**
 * 	Permet de saugarder le token a utiliser pour les notification push
 */
FOUNDATION_EXPORT void ConfigSetNotificationToken(NSString* token);

/**
 * 	Change le mode utilser
	Attention a ne passer que par cette fonction car elle set aussi les varible avec les bonnes urls
 */
FOUNDATION_EXPORT void ConfigSetProductionMode(BOOL production);

FOUNDATION_EXPORT void ConfigSetVersion(NSString* version);

FOUNDATION_EXPORT NSString* ConfigVersion(void);

#endif

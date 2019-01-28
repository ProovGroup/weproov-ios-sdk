// Objective-C API for talking to bitbucket.org/weproov/weproovstrucgo/fscache Go package.
//   gobind -lang=objc bitbucket.org/weproov/weproovstrucgo/fscache
//
// File is generated by gobind. Do not edit.

#ifndef __Fscache_H__
#define __Fscache_H__

@import Foundation;
#include "Universe.objc.h"

#include "Utils.objc.h"
#include "Wperr.objc.h"

@class FscacheCache;

@interface FscacheCache : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
/**
 * 	Renvoy une structure cache et creer le path si necesaire
 */
- (instancetype)init:(NSString*)name;
/**
 * le nom du cache permet de le diferencier dans les path
 */
- (NSString*)bucket;
- (void)setBucket:(NSString*)v;
/**
 * 	 permet de crypte les donner envoyer si la longeur est
	 plus grande que 32 et quelle est en hexa
 */
- (NSString*)cryptoKey;
- (void)setCryptoKey:(NSString*)v;
/**
 * 	suprime l'integraliter des clees dans le file system
	et recreer le dossier
 */
- (void)clean;
/**
 * 	permet de recuperer le path du dossier racine former de cette facons
	BASE_PATH + /cache/ + BUCKET_NAME
 */
- (NSString*)getBasePath;
/**
 * 	Recuper le path d'un fichier en verifient au prealable si il existe si il n'hexiste pas renvois
	une chaine de character vide
 */
- (NSString*)getPath:(NSString*)key;
- (NSString*)getPathWrite:(NSString*)key;
/**
 * 	Recupere de facons synchrone la valeur d'une clee
	atention ne pas utiliser cette methode pour renvoyer dans les app ios/android
	il y a des risque que le gabage collector vide la variable et/ou creer une memoryleaks
	imporante preferer les ouverture directement dans les os respectif en recuperant le path
	avec GetPath(key string)
 */
- (NSData*)getSync:(NSString*)key error:(NSError**)error;
/**
 * 	Verifie si une clee existe dans le cache
 */
- (BOOL)have:(NSString*)key;
// skipped method Cache.Keys with unsupported parameter or return types

- (void)prepareKeys;
/**
 * 	Retire les clee qui on ete creer il y a plus de 168h(7j)
 */
- (void)removeExpired;
/**
 * 	suprime une clee en la retirant du file systeme
 */
- (void)removeSync:(NSString*)key;
/**
 * 	Sauvegarde de facons synchrone le fichier
	prend en parametre la clee

	la clee est egale a au nom de du fichier seule le / son retirer
 */
- (NSString*)saveSync:(NSString*)key data:(NSData*)data error:(NSError**)error;
/**
 * 	Empact tout le cache dans un fichier tar
	retourne le path ou il a ete ecris
 */
- (NSString*)tar:(NSError**)error;
@end

@interface Fscache : NSObject
/**
 * 	Permet de stocker la base de tout les path pour les caches
 */
+ (NSString*) basE_PATH;
+ (void) setBASE_PATH:(NSString*)v;

@end

/**
 * 	Suprimme tout le contenu des caches ouvert avec RegistreNewCache
 */
FOUNDATION_EXPORT void FscacheCleanAll(void);

/**
 * 	Renvoy une structure cache et creer le path si necesaire
 */
FOUNDATION_EXPORT FscacheCache* FscacheNewCache(NSString* name);

/**
 * 	Renvoy une structure cache et stock son nom pour
	pouvoir la retrouver lors d'un clean all.

	en RemoveExpired est envoyer en background
 */
FOUNDATION_EXPORT FscacheCache* FscacheRegistreNewCache(NSString* name);

#endif



#import <Foundation/Foundation.h>
#import "TaskWrapper.h"

@protocol BrewDelegate<NSObject>

@optional
- (void) listDidComplete:	 	(NSA*) formulae;
- (void) searchDidComplete:	 	(NSA*) formulae;
- (void) outdatedDidComplete: 	(NSA*) formulae;
- (void) installDidComplete:	 	(NSS*) output;
- (void) uninstallDidComplete:	(NSS*) output;
- (void) updateDidComplete:   	(NSS*) output;
- (void) upgradeDidComplete:	 	(NSS*) output;
- (void) infoDidComplete:	 	(NSS*) output;
- (void) outputReceived:		(NSS*) output;
- (void) appendOutput:		 	(NSS*) output;
- (void) processFinished:		(NSS*) output;
- (void) descDidComplete:		(NSS*) output;
- (void) processStarted;
@end

typedef NS_ENUM(NSUI, BrewOperationType) {
	BrewOperationNone = 0,
	BrewOperationList,
	BrewOperationSearch,
	BrewOperationInfo,
	BrewOperationUpdate,
	BrewOperationUpgrade,
	BrewOperationInstall,
	BrewOperationUninstall,
	BrewOperationOutdated,
	BrewOperationDesc
};

@class Formula;
@interface Brew : NSOperation <TaskWrapperController>

@property (NATOM) BOOL 			 	isRunning;
@property (NATOM) BrewOperationType operation;
@property (STRNG) NSS 				*currentOutput, *searchString;
@property (STRNG) TaskWrapper 		*brewTask;
@property id <BrewDelegate> 	delegate;
@property     Formula 		*formula;

- (id) initWithDelegate: (id<BrewDelegate>)delegate operation:(BrewOperationType)type;
- (id) initWithFormula:  (Formula*)formula 			operation:(BrewOperationType)type;

//- (void) desc:		(NSS*)searchString;
//- (void) search:	(NSS*)searchString;
//- (void) list:		(NSA*)formulae;
//- (void) install:	(NSA*)formulae;
//- (void) uninstall:	(NSA*)formulae;
//- (void) upgrade:	(NSA*)formulae;
//- (void) info:		(NSA*)formulae;
//- (void) update;
//- (void) outdated;


@end

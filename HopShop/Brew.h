

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

typedef NS_ENUM(NSUI, BrewOperation) {
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


@interface Brew : NSObject <TaskWrapperController>

@property (NATOM) BOOL 			 isRunning;
@property (NATOM) BrewOperation  currentOperation;
@property (STRNG) NSS 			*currentOutput;
@property (STRNG) TaskWrapper 	*brewTask;
@property (STRNG)id <BrewDelegate> delegate;

- (id)   initWithDelegate:(id<BrewDelegate>)delegate;

- (void) desc:		(NSS*)searchString;
- (void) search:	(NSS*)searchString;
- (void) list:		(NSA*)formulae;
- (void) install:	(NSA*)formulae;
- (void) uninstall:	(NSA*)formulae;
- (void) upgrade:	(NSA*)formulae;
- (void) info:		(NSA*)formulae;
- (void) update;
- (void) outdated;

- (NSA*)buildCommandLine:(BrewOperation)operation arguments:(NSA*)arguments;

@end

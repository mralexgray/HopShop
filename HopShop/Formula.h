

#import <Foundation/Foundation.h>
#import "Brew.h"

// Notifications
extern NSS * const NotificationClearOutput;
extern NSS * const NotificationInfoReceived;
extern NSS * const NotificationFormulaeSelected;
extern NSS * const NotificationUpdateCompleted;
extern NSS * const NotificationOutputReceived;


@interface Formula : NSObject <BrewDelegate>

@property (NATOM,STRNG) NSS *name, *version, *info;
@property (NATOM) 		BOOL installed, outdated;
@property (RONLY)   	NSAS *fancyDescription;

- (id)initWithName: (NSS*)name;

@end

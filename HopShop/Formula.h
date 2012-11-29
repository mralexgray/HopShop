

#import <Foundation/Foundation.h>
#import "Brew.h"
#import "FormulaDescriptions.h"

// Notifications
extern NSS * const NotificationClearOutput;
extern NSS * const NotificationInfoReceived;
extern NSS * const NotificationFormulaeSelected;
extern NSS * const NotificationUpdateCompleted;
extern NSS * const NotificationOutputReceived;


@interface Formula : BaseModel <BrewDelegate>

@property (NATOM, STRNG) NSS *name, *version, *info, *desc, *url;

@property (NATOM,ASS)	BOOL googleGenerated;
@property (NATOM,ASS)	AZInstallationStatus installStatus;
// 		BOOL installed, outdated,
@property (NATOM,STRNG) NSAS *fancyDescription;

- (id)initWithName: (NSS*)name;
- (void)setDescFromGoogle:(NSString *)desc;

@end

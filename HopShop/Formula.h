

#import <Foundation/Foundation.h>
#import "Brew.h"
#import "FormulaDescriptions.h"


extern NSS*const NotificationClearOutput; extern NSS*const NotificationUpdateCompleted; extern NSS*const NotificationInfoReceived; extern NSS*const NotificationFormulaeSelected; extern NSS*const NotificationOutputReceived;


@interface    Formula : BaseModel   <BrewDelegate>

@property (NATOM,STRNG) NSAS	     *fancyDesc;

@property (NATOM,STRNG) NSS	   		   *url,
									  *info,
									  *name,
									  *desc,
								   *version;

@property (NATOM)	BOOL    googleGenerated;

@property (NATOM)	AZIS	installStatus;


- (id)   initWithName: 		(NSS*)name;
- (void) setDescFromGoogle: (NSS*)desc;

@end

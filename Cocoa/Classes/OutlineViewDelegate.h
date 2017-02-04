#import <Cocoa/Cocoa.h>
#import "SizeFormatter.h"
#import "AttributesFormatter.h"

@class Resource;

@interface OutlineViewDelegate : NSObject
{
	IBOutlet NSWindow				*window;
	IBOutlet NSOutlineView			*outlineView;
	IBOutlet SizeFormatter			*sizeFormatter;
	IBOutlet AttributesFormatter 	*attributesFormatter;
}

NSInteger compareResourcesAscending(Resource *r1, Resource *r2, void *context);
NSInteger compareResourcesDescending(Resource *r1, Resource *r2, void *context);

@end

@interface RKOutlineView : NSOutlineView
@end

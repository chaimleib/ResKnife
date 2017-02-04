#import "HexWindowController.h"
#import "FindSheetController.h"


@implementation HexWindowController

- (id)initWithResource:(id)newResource
{
	self = [self initWithWindowNibName:@"HexWindow"];
	if(!self) return nil;
	
	// one instance of your principal class will be created for every resource the user wants to edit (similar to Windows apps)
	undoManager = [[NSUndoManager alloc] init];
	liveEdit = NO;
	if(liveEdit)
	{
		resource = [newResource retain];	// resource to work on and monitor for external changes
		backup = [newResource copy];		// for reverting only
	}
	else
	{
		resource = [newResource copy];		// resource to work on
		backup = [newResource retain];		// actual resource to change when saving data and monitor for external changes
	}
	bytesPerRow = 16;
	
	// load the window from the nib file
	[self window];
	
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[undoManager release];
	[resource release];
	[backup release];
	
	[super dealloc];
}

- (void)windowDidLoad
{
	[super windowDidLoad];
	
	// insert the resources' data into the text fields
	self.hexEditField.data = [resource data];
	
	// here because we don't want these notifications until we have a window! (Only register for notifications on the resource we're editing)
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resourceNameDidChange:) name:ResourceNameDidChangeNotification object:resource];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resourceDataDidChange:) name:ResourceDataDidChangeNotification object:resource];
	if(liveEdit)	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resourceWasSaved:) name:ResourceDataDidChangeNotification object:resource];
	else			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resourceWasSaved:) name:ResourceDataDidChangeNotification object:backup];
	
	// finally, set the window title & show the window
	[[self window] setTitle:[resource defaultWindowTitle]];
	[self showWindow:self];
}


- (void)windowDidBecomeKey:(NSNotification *)notification
{
	NSMenu *editMenu = [[[NSApp mainMenu] itemAtIndex:2] submenu];
	NSMenuItem *copyItem = [editMenu itemAtIndex:[editMenu indexOfItemWithTarget:nil andAction:@selector(copy:)]];
	NSMenuItem *pasteItem = [editMenu itemAtIndex:[editMenu indexOfItemWithTarget:nil andAction:@selector(paste:)]];
	
	// swap copy: menu item for my own copy submenu
	[copyItem setEnabled:YES];
	[copyItem setKeyEquivalent:@"\0"];		// clear key equiv.
	[copyItem setKeyEquivalentModifierMask:0];
	[editMenu setSubmenu:copySubmenu forItem:copyItem];
	
	// swap paste: menu item for my own paste submenu
	[pasteItem setEnabled:YES];
	[pasteItem setKeyEquivalent:@"\0"];
	[pasteItem setKeyEquivalentModifierMask:0];
	[editMenu setSubmenu:pasteSubmenu forItem:pasteItem];
}

- (void)windowDidResignKey:(NSNotification *)notification
{
	NSMenu *editMenu = [[[NSApp mainMenu] itemAtIndex:2] submenu];
	NSMenuItem *copyItem = [editMenu itemAtIndex:[editMenu indexOfItemWithSubmenu:copySubmenu]];
	NSMenuItem *pasteItem = [editMenu itemAtIndex:[editMenu indexOfItemWithSubmenu:pasteSubmenu]];
	
	// swap my submenu for plain copy menu item
	[editMenu setSubmenu:nil forItem:copyItem];
	[copyItem setTarget:nil];
	[copyItem setAction:@selector(copy:)];
	[copyItem setKeyEquivalent:@"c"];
	[copyItem setKeyEquivalentModifierMask:NSCommandKeyMask];
	
	// swap my submenu for plain paste menu item
	[editMenu setSubmenu:nil forItem:pasteItem];
	[pasteItem setTarget:nil];
	[pasteItem setAction:@selector(paste:)];
	[pasteItem setKeyEquivalent:@"v"];
	[pasteItem setKeyEquivalentModifierMask:NSCommandKeyMask];
}

- (BOOL)windowShouldClose:(id)sender
{
	if([[self window] isDocumentEdited])
	{
		NSBeginAlertSheet(@"Do you want to keep the changes you made to this resource?", @"Keep", @"Don't Keep", @"Cancel", sender, self, @selector(saveSheetDidClose:returnCode:contextInfo:), nil, nil, @"Your changes cannot be saved later if you don't keep them.");
		return NO;
	}
	else return YES;
}

- (void)saveSheetDidClose:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	switch(returnCode)
	{
		case NSAlertDefaultReturn:		// keep
			[self saveResource:nil];
			[[self window] close];
			break;
		
		case NSAlertAlternateReturn:	// don't keep
			[[self window] close];
			break;
		
		case NSAlertOtherReturn:		// cancel
			break;
	}
}

- (void)saveResource:(id)sender
{
	[backup setData:[[resource data] copy]];
}

- (void)revertResource:(id)sender
{
	[resource setData:[[backup data] copy]];
}

- (void)showFind:(id)sender
{
	// bug: HexWindowController allocs a sheet controller, but it's never disposed of
	FindSheetController *sheetController = [[FindSheetController alloc] initWithWindowNibName:@"FindSheet"];
	[sheetController showFindSheet:self];
}

- (void)resourceNameDidChange:(NSNotification *)notification
{
	[[self window] setTitle:[(id <ResKnifeResourceProtocol>)[notification object] defaultWindowTitle]];
}

- (void)resourceDataDidChange:(NSNotification *)notification
{
	// ensure it's our resource which got changed (should always be true, we don't register for other resource notifications)
	// bug: if liveEdit is false and another editor changes backup, if we are dirty we need to ask the user whether to accept the changes from the other editor and discard our changes, or vice versa.
	if([notification object] == (id)resource)
	{
		self.hexEditField.data = [resource data];
		[self setDocumentEdited:YES];
	}
}

- (void)resourceWasSaved:(NSNotification *)notification
{
	id <ResKnifeResourceProtocol> object = [notification object];
	if(liveEdit)
	{
		// haven't worked out what to do here yet
	}
	else
	{
		// this should refresh the view automatically
		[resource setData:[[object data] copy]];
		[self setDocumentEdited:NO];
	}
}


- (id)resource
{
	return resource;
}

- (NSData *)data
{
	return [resource data];
}

- (int)bytesPerRow
{
	return bytesPerRow;
}

- (NSMenu *)copySubmenu
{
	return copySubmenu;
}

- (NSMenu *)pasteSubmenu
{
	return pasteSubmenu;
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)sender
{
	return undoManager;
}


- (void)hexTextView:(HFTextView *)view didChangeProperties:(HFControllerPropertyBits)properties;
{
	[resource setData: view.data];
}


/* range conversion methods */

+ (NSRange)byteRangeFromHexRange:(NSRange)hexRange
{
	// valid for all window widths
	NSRange byteRange = NSMakeRange(0,0);
	byteRange.location = (hexRange.location / 3);
	byteRange.length = (hexRange.length / 3) + ((hexRange.length % 3)? 1:0);
	return byteRange;
}

+ (NSRange)hexRangeFromByteRange:(NSRange)byteRange
{
	// valid for all window widths
	NSRange hexRange = NSMakeRange(0,0);
	hexRange.location = (byteRange.location * 3);
	hexRange.length = (byteRange.length * 3) - ((byteRange.length > 0)? 1:0);
	return hexRange;
}

+ (NSRange)byteRangeFromAsciiRange:(NSRange)asciiRange
{
	// one-to-one mapping
	return asciiRange;
}

+ (NSRange)asciiRangeFromByteRange:(NSRange)byteRange
{
	// one-to-one mapping
	return byteRange;
}

@end

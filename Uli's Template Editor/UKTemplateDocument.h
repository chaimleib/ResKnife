/*
 *     Generated by class-dump 3.3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2011 by Steve Nygard.
 */

#import "NSDocument.h"

@class NSMutableArray, NSMutableData, NSMutableDictionary, NSOutlineView;

@interface UKTemplateDocument : NSDocument
{
    NSOutlineView *fieldList;
    NSMutableData *fileData;
    NSMutableArray *fields;
    NSMutableDictionary *fieldDefaults;
    NSMutableDictionary *variables;
}

- (id)init;
- (void)dealloc;
- (id)windowNibName;
- (void)windowControllerDidLoadNib:(id)arg1;
- (id)dataRepresentationOfType:(id)arg1;
- (BOOL)readFromFile:(id)arg1 ofType:(id)arg2;
- (id)loadOneFieldFromDictionary:(id)arg1;
- (BOOL)loadFieldsFromDictionary:(id)arg1;
- (void)loadDataForField:(id)arg1 offset:(int *)arg2;
- (void)reloadTemplateFields;
- (void)updateGUI;
- (void)fieldChanged:(id)arg1;
- (void)alertDidEnd:(id)arg1 returnCode:(int)arg2 contextInfo:(void *)arg3;
- (void)copyFileAsPList:(id)arg1;
- (id)outlineView:(id)arg1 child:(int)arg2 ofItem:(id)arg3;
- (BOOL)outlineView:(id)arg1 isItemExpandable:(id)arg2;
- (int)outlineView:(id)arg1 numberOfChildrenOfItem:(id)arg2;
- (id)outlineView:(id)arg1 objectValueForTableColumn:(id)arg2 byItem:(id)arg3;
- (void)outlineView:(id)arg1 setObjectValue:(id)arg2 forTableColumn:(id)arg3 byItem:(id)arg4;
- (BOOL)outlineView:(id)arg1 shouldEditTableColumn:(id)arg2 item:(id)arg3;
- (BOOL)outlineView:(id)arg1 shouldSelectItem:(id)arg2;
- (void)field:(id)arg1 gotUnknownValueKey:(id)arg2;
- (id)objectForSettingsKey:(id)arg1;
- (BOOL)respondsToSelector:(SEL)arg1;
- (void)forwardInvocation:(id)arg1;
- (id)methodSignatureForSelector:(SEL)arg1;

@end


/*
 *     Generated by class-dump 3.3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2011 by Steve Nygard.
 */

#import "UKTemplateField.h"

@interface UKBooleanTemplateField : UKTemplateField
{
    BOOL booleanValue;
}

+ (void)load;
- (id)initWithSettingsDictionary:(id)arg1;
- (void)readFromData:(id)arg1 offset:(int *)arg2;
- (void)writeToData:(id)arg1 offset:(int *)arg2;
- (id)plistRepresentation;
- (id)fieldValue;
- (void)setFieldValue:(id)arg1 forKey:(id)arg2;

@end


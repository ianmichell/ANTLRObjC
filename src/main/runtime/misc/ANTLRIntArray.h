//
//  ANTLRIntArray.h
//  ANTLR
//
//  Created by Ian Michell on 27/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreFoundation/CoreFoundation.h>

#define ANTLR_INT_ARRAY_INITIAL_SIZE 10

@interface ANTLRIntArray : NSObject 
{
	NSAutoreleasePool *pool;
	NSMutableArray *data;
	NSInteger p;
}

-(void) add:(NSInteger) v;
-(void) push:(NSInteger) v;
-(NSInteger) pop;
-(NSInteger) get:(NSInteger) i;
-(NSInteger) size;
-(void) clear;

@property(readwrite, retain) NSMutableArray *data;

@end

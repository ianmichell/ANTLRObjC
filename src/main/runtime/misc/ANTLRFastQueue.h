//
//  ANTLRFastQueue.h
//  ANTLR
//
//  Created by Ian Michell on 26/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ANTLRFastQueue : NSObject 
{
	NSAutoreleasePool *pool;
	NSMutableArray *data;
	NSInteger p;
}

-(void) reset;
-(id) remove;
-(void) add:(id) o;
-(NSInteger) size;
-(id) head;
-(id) get:(NSInteger) i;
-(void) clear;

@end

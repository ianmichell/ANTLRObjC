//
//  ANTLRMissingTokenException.h
//  ANTLR
//
//  Created by Ian Michell on 24/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ANTLR/ANTLRMismatchedTokenException.h>
#import <ANTLR/ANTLRIntStream.h>

@interface ANTLRMissingTokenException : ANTLRMismatchedTokenException 
{
	id inserted;
}

-(id) initWithExpectedType:(NSInteger) expected forInputStream:(id<ANTLRIntStream>) input withObject:(id) o;

@property(readonly) NSInteger missingType;
@property(readwrite, retain) id inserted;

@end

//
//  ANTLRMismatchedTokenException.h
//  ANTLR
//
//  Created by Ian Michell on 24/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ANTLR/ANTLRRecognitionException.h>
#import <ANTLR/ANTLRIntStream.h>

@interface ANTLRMismatchedTokenException : ANTLRRecognitionException 
{
	NSInteger expecting;
}

-(id) initWithExpectedType:(NSInteger) exp forStream:(id<ANTLRIntStream>) input;

@property(readwrite) NSInteger expecting;

@end

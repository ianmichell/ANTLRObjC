//
//  ANTLREarlyExitException.h
//  ANTLR
//
//  Created by Ian Michell on 04/07/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ANTLR/ANTLRIntStream.h>
#import <ANTLR/ANTLRRecognitionException.h>

@interface ANTLREarlyExitException : ANTLRRecognitionException 
{
	NSInteger decisionNumber;
}

-(id) initWithDecisionNumber:(NSInteger) d withInputStream:(id<ANTLRIntStream>) str;

@property(readwrite) NSInteger decisionNumber;

@end

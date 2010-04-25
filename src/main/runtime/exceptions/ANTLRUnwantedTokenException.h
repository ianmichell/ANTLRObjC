//
//  ANTLRUnwantedTokenException.h
//  ANTLR
//
//  Created by Ian Michell on 25/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ANTLR/ANTLRMismatchedTokenException.h>
#import <ANTLR/ANTLRToken.h>

@interface ANTLRUnwantedTokenException : ANTLRMismatchedTokenException 
{

}

@property(readonly) id<ANTLRToken> unexpectedToken;

@end

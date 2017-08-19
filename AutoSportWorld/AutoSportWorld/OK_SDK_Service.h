//
//  OK_SDK_Service.h
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 18/08/2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//
#import "UIKit/UIKit.h"
#import <Foundation/Foundation.h>

@interface OK_SDK_Service : NSObject
@property UIViewController* viewController;


-(void) initAPI;
-(void) prepareViewController;
-(void) logIn;
-(void) emulateLogin;
@end

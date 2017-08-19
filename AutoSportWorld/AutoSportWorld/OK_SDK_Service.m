//
//  OK_SDK_Service.m
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 18/08/2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//
#import "UIKit/UIKit.h"
#import "OK_SDK_Service.h"
#import "OKSDK.h"

@implementation OK_SDK_Service

-(void) emulateLogin{
    [self initAPI];
    [self logIn];
    
}

-(void) initAPI{
    OKSDKInitSettings *settings = [OKSDKInitSettings new];
    settings.appKey = @"CBAKEGNFEBABABABA";
    settings.appId = @"1154828544";
    //INPUT VIEW CONTROLLER TO HANDLE
    settings.controllerHandler = nil;
    [OKSDK initWithSettings: settings];
}

static OKErrorBlock commonError = ^(NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    });
    
};

-(void) prepareViewController{
    [OKSDK getInstallSource:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = [NSString stringWithFormat:@"install source: %d", [data intValue]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"getInstallSource"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        });
    } error:commonError];
}

-(void) logIn{
    [OKSDK authorizeWithPermissions:@[@"VALUABLE_ACCESS",@"LONG_ACCESS_TOKEN",@"PHOTO_CONTENT"] success:^(id data) {
        
//        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"authorized"];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.navigationController pushViewController:controller animated:YES];
//        });
        [OKSDK invokeMethod:@"users.getCurrentUser" arguments:@{} success:^(NSDictionary* data) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [controller.navigationItem setTitle:[NSString stringWithFormat:@"Hello %@ %@!!!", data[@"first_name"], data[@"last_name"]]];
            });
        } error: commonError];
        
        
    } error:commonError];
}

//-(void)openOKURL:(NSURL*)url{
//    [OKSDK openUrl:url];
//}
//need to override openURL -> PEACE OF FUCKING SHIT


//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    [OKSDK openUrl:url];
//    return YES;
//}

@end

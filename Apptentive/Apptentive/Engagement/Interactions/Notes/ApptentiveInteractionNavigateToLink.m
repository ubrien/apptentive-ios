//
//  ApptentiveInteractionNavigateToLink.m
//  Apptentive
//
//  Created by Peter Kamb on 12/19/14.
//  Copyright (c) 2014 Apptentive, Inc. All rights reserved.
//

#import "ApptentiveInteractionNavigateToLink.h"
#import "ApptentiveInteraction.h"
#import "Apptentive_Private.h"
#import "ApptentiveBackend+Engagement.h"

NS_ASSUME_NONNULL_BEGIN

NSString *const ATInteractionNavigateToLinkEventLabelNavigate = @"navigate";


@implementation ApptentiveInteractionNavigateToLink

+ (void)load {
	[self registerInteractionControllerClass:self forType:@"NavigateToLink"];
}

- (void)presentInteractionFromViewController:(nullable UIViewController *)viewController {
	[super presentInteractionFromViewController:viewController];

	BOOL openedURL = NO;
	NSString *urlString = self.interaction.configuration[@"url"];
	NSURL *url = [NSURL URLWithString:urlString];
    
    if(!url) {
        ApptentiveLogError(@"No URL was included in the NavigateToLink Interaction's configuration.");
    }
    
    if (url && [self intentToProcessNotificationCenterDispatch:url]){
        openedURL=YES;
    }
    
    if (url && [self intentToProcessURLLink:url]){
        openedURL=YES;
    }
		
	NSDictionary *userInfo = @{ @"url": (urlString ?: [NSNull null]),
		@"success": @(openedURL),
	};

	[Apptentive.shared.backend engage:ATInteractionNavigateToLinkEventLabelNavigate fromInteraction:self.interaction fromViewController:nil userInfo:userInfo];
}

-(BOOL)intentToProcessNotificationCenterDispatch:(NSURL*)url{
    
    
    NSParameterAssert(url);
    
    if(![url.scheme isEqualToString:ApptentiveCustomNotificationCenterScheme]){
        //early abort intent
        return NO;
    }
    
    NSString *scheme = [NSString  stringWithFormat:@"%@://",ApptentiveCustomNotificationCenterScheme];
    NSString *notificationPayload=[[url absoluteString]stringByReplacingOccurrencesOfString:scheme withString:@""];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ApptentiveCustomNotificationCenterPayload object:notificationPayload];
    return YES;

}


-(BOOL)intentToProcessURLLink:(NSURL*)url{
    
    BOOL attemptToOpenURL = [[UIApplication sharedApplication] canOpenURL:url];
    BOOL openedURL=NO;
    
    // In iOS 9, `canOpenURL:` returns NO unless that URL scheme has been added to LSApplicationQueriesSchemes.
    if (!attemptToOpenURL) {
        // is this really intentional it seems like we can just skip this logic?
        attemptToOpenURL = YES;
    }
    
    if (attemptToOpenURL) {
        openedURL = [[UIApplication sharedApplication] openURL:url];
        if (!openedURL) {
            ApptentiveLogError(@"Could not open URL: %@", url);
        }
    } else {
        ApptentiveLogError(@"No application can open the Interaction's URL: %@", url);
    }
    
    return openedURL;
}

@end

NS_ASSUME_NONNULL_END

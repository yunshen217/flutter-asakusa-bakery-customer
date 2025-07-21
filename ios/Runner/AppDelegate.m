#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"
#import <FirebaseMessaging/FirebaseMessaging.h>

@import FirebaseCore;
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [FIRApp configure];
  [GMSServices provideAPIKey:@"AIzaSyAdVLWH5dqjst4RLcfo5oIfZauKC84DsBA"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
//    if (@available(iOS 10.0, *)) {
//           UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//           center.delegate = self;
//           [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
//               if (granted) {
//                   dispatch_async(dispatch_get_main_queue(), ^{
//                       [application registerForRemoteNotifications];
//                   });
//               }
//           }];
//       } else {
//           UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil];
//           [application registerUserNotificationSettings:settings];
//           [application registerForRemoteNotifications];
//       }
//       
//       [FIRMessaging messaging].delegate = self;
  return YES;
}
// 接收 FCM 令牌
- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"Firebase registration token: %@", fcmToken);
    // 可以将 FCM 令牌发送到服务器
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to register for remote notifications: %@", error.localizedDescription);
}


@end

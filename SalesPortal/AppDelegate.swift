    //
    //  AppDelegate.swift
    //  InventoryPortal
    //
    //  Created by administrator on 8/10/15.
    //  Copyright (c) 2015 Polaner Selections. All rights reserved.
    //
    
    import UIKit
    import XuniCoreKit
    
    
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        
        var window: UIWindow?
        
        
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            // Override point for customization after application launch.
            XuniLicenseManager.setKey(License().key)
            TestFairy.begin("83214e25cc75ac626e343dd7738c46b1f37c920e")
            NSTimeZone.setDefaultTimeZone(TimeZone(identifier: "America/New_York")!)
            return true
        }
        
        func applicationWillResignActive(_ application: UIApplication) {
            // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
            // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
            saveUserDefaults()
        }
        
        func applicationDidEnterBackground(_ application: UIApplication) {
            // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
            // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
            saveUserDefaults()
        }
        
        func applicationWillEnterForeground(_ application: UIApplication) {
            // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        }
        
        func applicationDidBecomeActive(_ application: UIApplication) {
            // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        }
        
        func applicationWillTerminate(_ application: UIApplication) {
            // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
            saveUserDefaults()
        }
        
        func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
            var myRootViewController = rootViewController
            if myRootViewController == nil {
                myRootViewController = UIApplication.shared.keyWindow?.rootViewController
            }
            
            if myRootViewController?.presentedViewController == nil {
                return rootViewController
            }
            
            if let presented = myRootViewController?.presentedViewController {
                if presented.isKind(of: UINavigationController.self) {
                    let navigationController = presented as? UINavigationController
                    return navigationController?.viewControllers.last
                }
                
                if presented.isKind(of: UITabBarController.self) {
                    let tabBarController = presented as? UITabBarController
                    return tabBarController?.selectedViewController
                }
                
                return getVisibleViewController(presented)
            }
            return nil
        }
        
        func saveUserDefaults() {
            
            if let viewController = getVisibleViewController(nil) {
                if viewController.isKind(of: InventoryViewController.self) {
                    if let myViewController = viewController as? InventoryViewController {
                        myViewController.flexGrid.saveUserDefaults(Module.Inventory)
                    }
                } else if viewController.isKind(of: AccountsViewController.self) {
                    if let myViewController = viewController as? AccountsViewController {
                        myViewController.flexGrid.saveUserDefaults(Module.Accounts)
                    }
                } else if viewController.isKind(of: AccountOrderHeaderViewController.self) {
                    if let myViewController = viewController as? AccountOrderHeaderViewController {
                        myViewController.flexGrid.saveUserDefaults(Module.AccountOrder)
                    }
                }else if viewController.isKind(of: SampleOrderHeaderViewController.self) {
                    if let myViewController = viewController as? SampleOrderHeaderViewController {
                        myViewController.flexGrid.saveUserDefaults(Module.SampleOrder)
                    }
                } else if viewController.isKind(of: AccountOrderInventoryViewController.self) {
                    if let myViewController = viewController as? AccountOrderInventoryViewController {
                        myViewController.flexGrid.saveUserDefaults(Module.AccountOrderInventory)
                    }
                } else if viewController.isKind(of: SampleOrderInventoryViewController.self) {
                    if let myViewController = viewController as? SampleOrderInventoryViewController {
                        myViewController.flexGrid.saveUserDefaults(Module.SampleOrderInventory)
                    }
                } else if viewController.isKind(of: AccountOrderHistoryViewController.self) {
                    if let myViewController = viewController as? AccountOrderHistoryViewController {
                        myViewController.flexGrid.saveUserDefaults(Module.AccountOrderHistory)
                    }
                } else if viewController.isKind(of: SampleOrderHistoryViewController.self) {
                    if let myViewController = viewController as? SampleOrderHistoryViewController {
                        myViewController.flexGrid.saveUserDefaults(Module.SampleOrderHistory)
                    }
                } else if viewController.isKind(of: OrderMobosViewController.self) {
                    if let myViewController = viewController as? OrderMobosViewController {
                        myViewController.flexGrid.saveUserDefaults(Module.OrderMobos)
                    }
                } else if viewController.isKind(of: OrderListViewController.self) {
                    if let myViewController = viewController as? OrderListViewController {
                        myViewController.flexGrid.saveUserDefaults(Module.OrderList)
                    }
                } else if viewController.isKind(of: SampleListViewController.self) {
                    if let myViewController = viewController as? SampleListViewController {
                        myViewController.flexGrid.saveUserDefaults(Module.SampleList)
                    }
                }
            }
        }
    }

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
            XuniLicenseManager.setKey(License().key)
            let credentials = Credentials.getCredentials()
            TestFairy.setUserId(credentials?["username"] ?? "New user")
            TestFairy.begin("83214e25cc75ac626e343dd7738c46b1f37c920e")
            NSTimeZone.default = TimeZone(identifier: "America/New_York")!
            return true
        }
        
        func applicationWillResignActive(_ application: UIApplication) {
            saveUserDefaults()
        }
        
        func applicationDidEnterBackground(_ application: UIApplication) {
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
                        myViewController.flexGrid.saveUserDefaults(Module.inventory)
                    }
                } else if viewController.isKind(of: AccountsViewController.self) {
                    if let myViewController = viewController as? AccountsViewController {
                        myViewController.flexGrid.saveUserDefaults(Module.accounts)
                    }
                } else if viewController.isKind(of: AccountOrderHeaderViewController.self) {
                    if let myViewController = viewController as? AccountOrderHeaderViewController {
                        myViewController.flexGrid.saveUserDefaults(Module.accountOrder)
                    }
                }else if viewController.isKind(of: SampleOrderHeaderViewController.self) {
                    if let myViewController = viewController as? SampleOrderHeaderViewController {
                        myViewController.flexGrid.saveUserDefaults(Module.sampleOrder)
                    }
                } else if viewController.isKind(of: AccountOrderInventoryViewController.self) {
                    if let myViewController = viewController as? AccountOrderInventoryViewController {
                        myViewController.flexGrid.saveUserDefaults(Module.accountOrderInventory)
                    }
                } else if viewController.isKind(of: SampleOrderInventoryViewController.self) {
                    if let myViewController = viewController as? SampleOrderInventoryViewController {
                        myViewController.flexGrid.saveUserDefaults(Module.sampleOrderInventory)
                    }
                } else if viewController.isKind(of: AccountOrderHistoryViewController.self) {
                    if let myViewController = viewController as? AccountOrderHistoryViewController {
                        myViewController.flexGrid.saveUserDefaults(Module.accountOrderHistory)
                    }
                } else if viewController.isKind(of: SampleOrderHistoryViewController.self) {
                    if let myViewController = viewController as? SampleOrderHistoryViewController {
                        myViewController.flexGrid.saveUserDefaults(Module.sampleOrderHistory)
                    }
                } else if viewController.isKind(of: OrderMobosViewController.self) {
                    if let myViewController = viewController as? OrderMobosViewController {
                        myViewController.flexGrid.saveUserDefaults(Module.orderMobos)
                    }
                } else if viewController.isKind(of: OrderListViewController.self) {
                    if let myViewController = viewController as? OrderListViewController {
                        myViewController.flexGrid.saveUserDefaults(Module.orderList)
                    }
                } else if viewController.isKind(of: SampleListViewController.self) {
                    if let myViewController = viewController as? SampleListViewController {
                        myViewController.flexGrid.saveUserDefaults(Module.sampleList)
                    }
                }
            }
        }
    }

//
//  AppDelegate.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import UIKit
import CoreData
import Swinject
import Reachability

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var container: Container = {
        let container = Container()
        container.register(AnyEnvironmentProvider.self) { resolver in
            EnviromentProvider()
        }
        container.register((any AnyConnectivity).self) { resolver in
            ReachabilityConnectivity(reachability: try? Reachability())
        }
        container.register(Calendar.self) { resolver in Calendar.current }
        container.register(TimeZone.self) { resolver in TimeZone.current }
        container.register((any AnyImageLoader).self) { resolver in KFImageLoader() }
        container.register((any RemoteClient).self) { resolver in
            AFRemoteClient(baseUrl: AppConfigs.baseUrl)
        }
        container.register((any AnyDecoder).self) { resolver in
            JsonDecoder()
        }
        container.register((any AnyRemoteListFetchStrategy).self) { resolver in
            RemoteListFetchStrategy(remoteClient: resolver.require((any RemoteClient).self),
                                    decoder: resolver.require((any AnyDecoder).self))
        }
        container.register((any AnyDataFetchCacheStrategy).self) { resolver in
            DataFetchCacheStrategy(connectivity: resolver.require((any AnyConnectivity).self))
        }
        
        container.register(NSManagedObjectContext.self) { [weak self] resolver in
            guard let self = self else { fatalError("Unresolved self") }
            return self.persistentContainer.viewContext
        }
        container.register((any AnyNotificationCenter).self) { resolver in
            NotificationCenter.default
        }
        container.register(LeagueDatabase.self) { resolver in
            LeagueDatabase(context: resolver.require(NSManagedObjectContext.self),
                           notificationCenter: resolver.require((any AnyNotificationCenter).self)
            )
        }
        container.register((any Database<League>).self) { resolver in
            resolver.require(LeagueDatabase.self)
        }
        container.register((any AnyLeagueDatabase).self) { resolver in
            resolver.require(LeagueDatabase.self)
        }
        container.register((any DynamicDatabase<League>).self) { resolver in
            resolver.require(LeagueDatabase.self)
        }
        container.register((any FavouritesDatabase<League>).self) { resolver in
            resolver.require(LeagueDatabase.self)
        }
        
        container.register(TeamDatabase.self) { resolver in
            TeamDatabase(context: resolver.require(NSManagedObjectContext.self),
                         notificationCenter: resolver.require((any AnyNotificationCenter).self)
            )
        }
        container.register((any Database<Team>).self) { resolver in
            resolver.require(TeamDatabase.self)
        }
        container.register((any AnyTeamDatabase).self) { resolver in
            resolver.require(TeamDatabase.self)
        }
        container.register((any FavouritesDatabase<Team>).self) { resolver in
            resolver.require(TeamDatabase.self)
        }
        
        
        
        container.register(PlayerDatabase.self) { resolver in
            PlayerDatabase(context: resolver.require(NSManagedObjectContext.self),
                           notificationCenter: resolver.require((any AnyNotificationCenter).self)
            )
        }
        container.register((any Database<Player>).self) { resolver in
            resolver.require(PlayerDatabase.self)
        }
        container.register((any AnyPlayerDatabase).self) { resolver in
            resolver.require(PlayerDatabase.self)
        }
        
        container.register((any AnyLeaguesRemoteService).self) { [weak self] resolver in
            return LeaguesRemoteService(fetchStrategy: resolver.require((any AnyRemoteListFetchStrategy).self),
                                        context: resolver.require(NSManagedObjectContext.self),
                                        environment: resolver.require(AnyEnvironmentProvider.self))
        }
        container.register((any AnyLeagueEventsRemoteService).self) { [weak self] resolver in
            return LeagueEventsRemoteService(fetchStrategy: resolver.require((any AnyRemoteListFetchStrategy).self),
                                             context: resolver.require(NSManagedObjectContext.self),
                                             environment: resolver.require(AnyEnvironmentProvider.self))
        }
        container.register((any AnyLivescoresRemoteService).self) { [weak self] resolver in
            return LivescoresRemoteService(fetchStrategy: resolver.require((any AnyRemoteListFetchStrategy).self),
                                             context: resolver.require(NSManagedObjectContext.self),
                                             environment: resolver.require(AnyEnvironmentProvider.self),
                                           timezone: resolver.require(TimeZone.self))
        }
        container.register((any AnyTeamsRemoteService).self) { [weak self] resolver in
            return TeamsRemoteService(fetchStrategy: resolver.require((any AnyRemoteListFetchStrategy).self),
                                      context: resolver.require(NSManagedObjectContext.self),
                                      environment: resolver.require(AnyEnvironmentProvider.self))
        }
        container.register((any AnyLeaguePlayersRemoteService).self) { [weak self] resolver in
            return LeaguePlayersRemoteService(fetchStrategy: resolver.require((any AnyRemoteListFetchStrategy).self),
                                        context: resolver.require(NSManagedObjectContext.self),
                                        environment: resolver.require(AnyEnvironmentProvider.self))
        }
        container.register((any AnyPlayersRemoteService).self) { [weak self] resolver in
            return PlayersRemoteService(fetchStrategy: resolver.require((any AnyRemoteListFetchStrategy).self),
                                        context: resolver.require(NSManagedObjectContext.self),
                                        environment: resolver.require(AnyEnvironmentProvider.self))
        }
        
        container.register((any AnyLeaguePlayersModelFactory).self) { resolver in
            return LeaguePlayersModelFactory(resolver: resolver)
        }
        
        container.register((any AnyTeamViewModelFactory).self) { resolver in
            return TeamViewModelFactory(resolver: resolver)
        }
        
        container.register((any AnyPlayersViewModelFactory).self) { resolver in
            return PlayersViewModelFactory(resolver: resolver)
        }
        
        container.register((any AnyLeagueViewModelFactory).self) { resolver in
            return LeagueViewModelFactory(resolver: resolver)
        }
        
        container.register((any AnyLeagueEventsModelFactory).self) { resolver in
            return LeagueEventsModelFactory(resolver: resolver)
        }
        
        container.register((any AnyLeagueEventsViewModelFactory).self) { resolver in
            return LeagueEventsViewModelFactory(resolver: resolver)
        }
        
        container.register((any AnyTeamsViewModelFactory).self) { resolver in
            return TeamsViewModelFactory(resolver: resolver)
        }
        
        container.register((any AnyLeaguesViewModelFactory).self) { resolver in
            return LeaguesViewModelFactory(resolver: resolver)
        }
        
        container.register((any AnyFavouriteLeaguesViewModelFactory).self) { resolver in
            return FavouriteLeaguesViewModelFactory(resolver: resolver)
        }
        
        container.register((any AnyFavouriteTeamsViewModelFactory).self) { resolver in
            return FavouriteTeamsViewModelFactory(resolver: resolver)
        }

        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "BallPark")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        return container
    }()
    
}


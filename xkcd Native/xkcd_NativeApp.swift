//
//  xkcd_NativeApp.swift
//  xkcd Native
//
//  Created by Alf Jørgen Bråtane on 23/06/2022.
//

import SwiftUI

@main
struct xkcd_NativeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ComicOverviewView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

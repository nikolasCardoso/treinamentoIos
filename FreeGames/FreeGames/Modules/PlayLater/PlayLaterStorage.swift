//
//  PlayLaterStorage.swift
//  FreeGames
//
//  Created by Nikolas Cardoso de Oliveira on 10/08/22.
//

import Foundation

class PlayLaterStorage {
    
    static let shared = PlayLaterStorage()
    
    private let userDefaults = UserDefaults.standard
    
    private let databaseKey = "FreeGamesPlayLater"
    
    var games: [GameDetails] = []
    
    private init() {
        fetchFromDatabase()
    }
    
    func setPlayLater(game: GameDetails) -> Bool {
        defer {
            updateDatabase()
        }
        
        if isInPlayLater(id: game.id) {
            remove(game: game)
            return false
        } else {
            games.append(game)
            return true
        }
    }
    
    func isInPlayLater(id: Int) -> Bool {
        return games.contains { game in
            game.id == id
        }
    }
    
    func remove(game: GameDetails) {
        if let indexOfGame = games.firstIndex(where: { $0.id == game.id }) {
            games.remove(at: indexOfGame)
        }
        updateDatabase()
    }
    
}

private extension PlayLaterStorage {
    
    func updateDatabase() {
        guard let jsonData = try? JSONEncoder().encode(games) else { return }
        
        userDefaults.setValue(jsonData, forKey: databaseKey)
    }
    
    func fetchFromDatabase() {
        guard let jsonData = userDefaults.data(forKey: databaseKey),
              let data = try? JSONDecoder().decode([GameDetails].self, from: jsonData)
        else { return }
        
        self.games = data
    }
    
}

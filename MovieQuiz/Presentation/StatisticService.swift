import Foundation

// MARK: - StatisticService

final class StatisticService {
    
    // MARK: - Properties
    private let storage: UserDefaults = .standard
    
    private var totalCorrectAnswers: Int {
        get {
            storage.integer(forKey: StatisticStorageKeys.totalCorrectAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: StatisticStorageKeys.totalCorrectAnswers.rawValue)
        }
    }
    
    private var totalQuestionsAsked: Int {
        get {
            storage.integer(forKey: StatisticStorageKeys.totalQuestionsAsked.rawValue)
        }
        set {
            storage.set(newValue, forKey: StatisticStorageKeys.totalQuestionsAsked.rawValue)
        }
    }
    
}

// MARK: - StatisticServiceProtocol
extension StatisticService: StatisticServiceProtocol {
    
    // MARK: - Public Properties
    var gamesCount: Int {
        get {
            storage.integer(forKey: StatisticStorageKeys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: StatisticStorageKeys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: StatisticStorageKeys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: StatisticStorageKeys.bestGameTotal.rawValue)
            let date = storage.object(forKey: StatisticStorageKeys.bestGameDate.rawValue) as? Date ?? Date()
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: StatisticStorageKeys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: StatisticStorageKeys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: StatisticStorageKeys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        if totalQuestionsAsked == 0 {
            return 0.0
        }
        
        let accuracy = Double(totalCorrectAnswers) / Double(totalQuestionsAsked)
        return accuracy * 100
    }
    
    // MARK: - Public Methods
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        
        totalCorrectAnswers += count
        totalQuestionsAsked += amount
        
        let newGame = GameResult(correct: count, total: amount, date: Date())
        
        if newGame.correct > bestGame.correct {
            bestGame = newGame
        }
    }
    
    
}

import Foundation
import Observation

@Observable
class BooksViewModel {
    var books: [Book] = []
    var favorites: Set<String> = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    private let apiUrl = "https://openlibrary.org/search.json?q=oliver+sacks&limit=5"
    
    @MainActor
    func fetchBooks() async {
        isLoading = true
        errorMessage = nil
        
        do {
            guard let url = URL(string: apiUrl) else {
                throw URLError(.badURL)
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(OpenLibraryResponse.self, from: data)
            
            self.books = response.docs
        } catch {
            self.errorMessage = "Failed to load books. Please try again."
        }
        
        isLoading = false
    }
    
    func toggleFavorite(bookId: String) {
        if favorites.contains(bookId) {
            favorites.remove(bookId)
        } else {
            favorites.insert(bookId)
        }
    }
}

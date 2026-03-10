import SwiftUI

struct BooksListView: View {
    @State private var viewModel = BooksViewModel()
    @State private var selectedTab: Tab = .all
    
    enum Tab {
        case all, favorites
    }
    
    var displayBooks: [Book] {
        switch selectedTab {
        case .all:
            return viewModel.books
        case .favorites:
            return viewModel.books.filter { viewModel.favorites.contains($0.id) }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.05), Color.indigo.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "book.open.fill")
                                    .foregroundColor(.indigo)
                                    .font(.system(size: 32))
                                Text("Oliver Sacks Books")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            }
                            Text("Explore and favorite books using @Observable")
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 20)
                        
                        // Custom Tabs
                        HStack(spacing: 4) {
                            TabButton(title: "All Books (\(viewModel.books.count))", isSelected: selectedTab == .all) {
                                selectedTab = .all
                            }
                            
                            TabButton(icon: "heart", title: "Favorites (\(viewModel.favorites.count))", isSelected: selectedTab == .favorites) {
                                selectedTab = .favorites
                            }
                        }
                        .padding(4)
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                        
                        // Content
                        if viewModel.isLoading {
                            ProgressView("Loading books...")
                                .padding(.top, 40)
                        } else if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(8)
                        } else if displayBooks.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 48))
                                    .foregroundColor(Color.gray.opacity(0.3))
                                Text(selectedTab == .favorites ? "No favorites yet. Add some books to your favorites!" : "No books found.")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.top, 40)
                        } else {
                            LazyVStack(spacing: 16) {
                                ForEach(displayBooks) { book in
                                    BookCardView(
                                        book: book,
                                        isFavorite: viewModel.favorites.contains(book.id),
                                        onToggleFavorite: {
                                            viewModel.toggleFavorite(bookId: book.id)
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .task {
                if viewModel.books.isEmpty {
                    await viewModel.fetchBooks()
                }
            }
        }
    }
}

// Custom Tab Button helper
struct TabButton: View {
    var icon: String? = nil
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(isSelected ? Color.indigo : Color.clear)
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(6)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

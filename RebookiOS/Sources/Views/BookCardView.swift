import SwiftUI

struct BookCardView: View {
    let book: Book
    let isFavorite: Bool
    let onToggleFavorite: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Thumbnail
            if let coverId = book.coverId,
               let url = URL(string: "https://covers.openlibrary.org/b/id/\(coverId)-M.jpg") {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(Image(systemName: "book.closed").foregroundColor(.gray))
                }
                .frame(width: 96, height: 128)
                .cornerRadius(4)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay(Image(systemName: "book.closed").foregroundColor(.gray))
                    .frame(width: 96, height: 128)
                    .cornerRadius(4)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    Text(book.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Button(action: onToggleFavorite) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .gray)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Text(book.authorNames?.joined(separator: ", ") ?? "Unknown Author")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let published = book.firstPublishYear {
                    Text("First Published: \(String(published))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

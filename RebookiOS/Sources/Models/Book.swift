import Foundation

struct Book: Identifiable, Codable {
    let id: String
    let title: String
    let authorNames: [String]?
    let coverId: Int?
    let firstPublishYear: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "key"
        case title
        case authorNames = "author_name"
        case coverId = "cover_i"
        case firstPublishYear = "first_publish_year"
    }
}

struct OpenLibraryResponse: Codable {
    let docs: [Book]
}

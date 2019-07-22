import Networking

enum GetBooks {
  typealias Result = Swift.Result<[Book], Error>
  
  open class Service {
    init() {}
    open func solve() -> Result { fatalError() }
  }
  
  enum Error: Swift.Error {
    case connectionProblem
    case unexpected(Swift.Error?)
  }
}

extension GetBooks {
  class ServerService : Service {
    let server: Server
    
    public init(server: Server) {
      self.server = server
    }
    
    override public func solve() -> Result {
      let request = Request(endpoint: Endpoint(.get, "test/books"), auth: .none)
      let response = self.server.process(request)
      return ResponseHandler().handle(response)
    }
  }
  
  class ResponseHandler {
    func handle(_ response: Networking.Response) -> Result {
      switch response.result {
      case .noConnnection:
        return .failure(.connectionProblem)
      case .notProcessed(let error):
        return .failure(.unexpected(error))
      case .processed(200, .success(.string(let stringData, _))):
        guard let json: [[String: Any]] = (try? JSONSerialization.jsonObject(with: stringData, options: [])).flatMap({ $0 as? [[String: Any]] }) else {
          return .failure(.unexpected(nil))
        }
        let books = json.compactMap { BookParser().parse($0) }
        return .success(books)
      case .processed(_, _):
        return .failure(.unexpected(nil))
      case .unauthorized(_):
        return .failure(.unexpected(nil))
      }
    }
  }
}

class BookParser {
  func parse(_ json: [String: Any]) -> Book? {
    guard let id = json["id"] as? Int else { return nil }
    guard let name = json["nombre"] as? String else { return nil }
    guard let author = json["autor"] as? String else { return nil }
    guard let isAvailable = json["disponibilidad"] as? Bool else { return nil }
    guard let imageURLString = json["imagen"] as? String else { return nil }
    guard let imageURL = URL(string: imageURLString) else { return nil }
    guard let popularity = json["popularidad"] as? Int else { return nil }
    return Book(id: id, name: name, author: author, isAvailable: isAvailable, imageURL: imageURL, popularity: popularity)
  }
}

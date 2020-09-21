import UIKit

struct TopLevelObject: Decodable {
    //to get an object out of a dictionary you pass in the key
    var results: [Person]
}

struct Person: Decodable {
    //note JSON has name written as "name"
    var name: String
    var films: [URL]
}

struct Film: Decodable {
    var title: String
    var opening_crawl: String
    var release_date: String
}

class SwapiService {
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    static let personEndPoint = "people"
    static let filmEndPoint = "films"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
      // 1 - Prepare URL
        guard let baseURL = baseURL else { return completion(nil) }
        let id = String(id)
        let finalURL = baseURL.appendingPathComponent(personEndPoint).appendingPathComponent(id)
        print(finalURL)
        
      // 2 - Contact server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            // 3 - Handle errors
            if let error = error {
                print("There was an error PART1 \(error.localizedDescription).")
                return completion(nil)
            }
            // 4 - Check for data
            guard let data = data else { return completion(nil) }
            // 5 - Decode Person from JSON
            do {
                let decoder = JSONDecoder()
                //print(String(data: data, encoding: .utf8)!)
                let person = try decoder.decode(Person.self, from: data)
                return completion(person)
            } catch {
                print("There was an error PART2 \(error.localizedDescription)")
                return completion(nil)
            }
        }.resume()
    }
    
    // Film function
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
      // 1 - Contact server
//        guard let baseURL = baseURL else { return completion(nil) }
//        let completeURL = baseURL.appendingPathComponent("films")
//       print(completeURL)
        //let finalURL = baseURL.appendingPathComponent("people")
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            // 2 - Handle errors
            if let error = error {
                print("Error handling errors: \(error.localizedDescription)")
                return completion(nil)
            }
            // 3 - Check for data
            guard let data = data else { return completion(nil) }
            // 4 - Decode Film from JSON
            do {
                //print(String(data: data, encoding: .utf8)!)
                let film = try JSONDecoder().decode(Film.self, from: data)
                return completion(film)
            } catch {
                print("Catch Error: \(error.localizedDescription)")
            }
        }.resume()
    }
}//End of Class

SwapiService.fetchPerson(id: 1) { (person) in
    if let person = person {
        print(person)
        for film in person.films {
            fetchFilm(url: film)
        }
    }
}

//var testFilm = "http://swapi.dev/api/films/1/"

func fetchFilm(url: URL) {
    //print("Made it to func fetchFilm")
  SwapiService.fetchFilm(url: url) { film in
      if let film = film {
        print(film.title)
      }
  }
}

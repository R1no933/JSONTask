import UIKit

struct Card: Decodable {
    let name: String
    let type: String
    let manaCost: String?
    let setName: String
    var power: String?
}

struct Cards: Decodable {
    var cards: [Card]
    
    func printCardInfo() {
        cards.forEach {card in
            print("Информайия о карте: \n   Имя карты: \(card.name)\n   Тип карты: \(card.type)\n   Стоимость разыгрывания карты: \(card.manaCost ?? "0") маны\n   Коллекция карты: \(card.setName)\n   Сила карты: \(card.power ?? "0")")
        }
    }
}

func createUrl(_ name: String) -> URL? {
    var urlComponent = URLComponents()
    urlComponent.scheme = "https"
    urlComponent.host = "api.magicthegathering.io"
    urlComponent.path = "/v1/cards"
    urlComponent.queryItems = [URLQueryItem(name: "name", value: name)]
    
    return urlComponent.url
}

let url = createUrl("Opt|Black Lotus")

func getData(for urlRequest: URL?) {
    guard let url = urlRequest else {
        print("Fatal Error")
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, responce, error in
        if let _ = error {
            print(error?.localizedDescription ?? "")
        }
        
        guard let responce = responce as? HTTPURLResponse, responce.statusCode == 200 else {
            print("Invalid responce from server")
            return
        }
        
        guard let data = data else {
            print("Invalid data")
            return
        }
        
        do {
            let _ = try JSONDecoder().decode(Cards.self, from: data).printCardInfo()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    task.resume()
}

getData(for: url)



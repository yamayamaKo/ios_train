//
//  OkashiData.swift
//  MyOkashi
//
//  Created by 山田紘暉 on 2023/05/21.
//

import Foundation

struct OkashiItem: Identifiable {
    let id = UUID()
    let name: String
    let link: URL
    let image: URL
}

// おかしデータ検索用クラス
class OkashiData: ObservableObject {
    struct ResultJson: Codable {
        struct Item: Codable {
            let name: String?
            let url: URL?
            let image: URL?
        }
        
        let item: [Item]?
    }
    
    @Published var okashiList: [OkashiItem] = []
    var okashiLink: URL?
    
    func searchOkashi(keyword: String) {
        Task {
            await search(keyword: keyword)
        }
    }
    
    @MainActor
    private func search(keyword: String) async {
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            return
        }
        
        guard let req_url = URL(string: "https://sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r")
        else {
            return
        }
        
        print(req_url)
        
        do {
            let (data, _) = try await URLSession.shared.data(from: req_url)
            let decoder = JSONDecoder()
            
            let json = try decoder.decode(ResultJson.self, from: data)
            
            guard let items = json.item else { return }
            self.okashiList.removeAll()
            
            for item in items {
                if let name = item.name,
                   let link = item.url,
                   let image = item.image {
                    let okashi = OkashiItem(name: name, link: link, image: image)
                    
                    self.okashiList.append(okashi)
                }
            }
        } catch {
            print("エラーです")
        }
    }
}

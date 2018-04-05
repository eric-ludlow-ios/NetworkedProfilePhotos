//
//  User.swift
//  NetworkedProfilePhotos
//
//  Created by Eric Ludlow on 4/5/18.
//  Copyright © 2018 EricLudlow. All rights reserved.
//

import UIKit

class User: Codable {
    enum CodingKeys: String, CodingKey {
        case idString = "id", firstName, lastName, title, bio, avatarUrl = "avatar"
    }
    
    var idString: String
    var firstName: String
    var lastName: String
    var title: String
    var bio: String
    var avatarUrl: URL
    
    var avatar: UIImage? = nil
    
    var id: Int {
        return Int(idString) ?? -1
    }
    
    func fetchAvatar(completion: ((Bool, NSError?) -> Void)?) {
        URLSession.shared.dataTask(with: avatarUrl) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion?(false, error as NSError)
                } else if let data = data {
                    self.avatar = UIImage(data: data)
                    completion?(true, nil)
                } else {
                    let error = NSError(domain: "Missing Data Error", code: 400, userInfo: nil)
                    completion?(false, error)
                }
            }
        }.resume()
    }
    
    //MARK:- static methods
    static func getUsers() -> [User]? {
        guard let path = Bundle.main.path(forResource: "SoFiTeam", ofType: "json") else { return nil }
        let url = URL(fileURLWithPath: path)
        do {
            let jsonData = try Data(contentsOf: url, options: .mappedIfSafe)
            let decodedUsers = try JSONDecoder().decode([User].self, from: jsonData)
            return decodedUsers
        } catch {
            print(error)
            return nil
        }
    }
}

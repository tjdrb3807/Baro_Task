//
//  LoginManager.swift
//  Baro_Task
//
//  Created by 전성규 on 3/16/25.
//

import Foundation

final class LoginManager {
    private enum Keys {
        static let loggedInUserID = "loggedInUserID"
        static let loggedInUserNickname = "loggedInUserNickname"
    }
    
    // 로그인 정보 저장
    static func saveLoginSession(id: String, nickname: String) {
        UserDefaults.standard.set(id, forKey: Keys.loggedInUserID)
        UserDefaults.standard.set(nickname, forKey: Keys.loggedInUserNickname)
        UserDefaults.standard.synchronize()
    }
    
    // 로그인한 유저의 아이디 가져오기
    static func getLoggedInUserID() -> String? {
        UserDefaults.standard.string(forKey: Keys.loggedInUserID)
    }
    
    // 로그인한 유저의 닉네임 가져오기
    static func getLoggedInUserNickname() -> String? {
        UserDefaults.standard.string(forKey: Keys.loggedInUserNickname)
    }
    
    // 로그인 정보 삭제 (로그아웃 시)
    static func clearLoginSession() {
        UserDefaults.standard.removeObject(forKey: Keys.loggedInUserID)
        UserDefaults.standard.removeObject(forKey: Keys.loggedInUserNickname)
        UserDefaults.standard.synchronize()
    }
}

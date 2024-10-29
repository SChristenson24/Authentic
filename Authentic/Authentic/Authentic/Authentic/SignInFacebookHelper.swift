//
//  SignInFacebookHelper.swift
//  Authentic
//
//  Created by John Mark Taylor on 9/29/24.
//

import Foundation
import FBSDKLoginKit

struct FacebookSignInResultModel{
    let accessToken: String
    let tokenString: String
}

final class SignInFacebookHelper{
    @MainActor
    func signIn() async throws -> FacebookSignInResultModel{
        let loginManager = LoginManager()
        let result: LoginManagerLoginResult = try await withCheckedThrowingContinuation { continuation in
            loginManager.logIn(permissions: ["public_profile", "email"], from: nil) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let result = result, result.isCancelled {
                    continuation.resume(throwing: NSError(domain: "FacebookLoginError", code: 1, userInfo: [NSLocalizedDescriptionKey: "User cancelled login."]))
                } else if let result = result {
                    continuation.resume(returning: result)
                } else {
                    continuation.resume(throwing: NSError(domain: "FacebookLoginError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unknown login error."]))
                }
            }
        }
        
        guard let tokenString = result.token?.tokenString else {
            throw NSError(domain: "FacebookLoginError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get Facebook access token."])
        }
        let accessToken = tokenString
                let tokens = FacebookSignInResultModel(accessToken: accessToken, tokenString: tokenString)
                return tokens
    }
}

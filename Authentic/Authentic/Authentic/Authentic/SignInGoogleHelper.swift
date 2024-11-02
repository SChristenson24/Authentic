//
//  SignInGoogleHelper.swift
//  Authentic
//
//  Created by John Mark Taylor on 9/24/24.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel{
    let idToken: String
    let accessToken: String
    
}

final class SignInGoogleHelper{
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel{
        guard let TopVC = Utilities.shared.topViewController() else{
            throw URLError(.cannotFindHost)
        }
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: TopVC)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken = gidSignInResult.user.accessToken.tokenString
        
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
        return tokens
    }
}

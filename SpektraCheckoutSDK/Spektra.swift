//
//  Spektra.swift
//  SpektraCheckoutSDK
//
//  Created by Haron Ongaki on 16/04/2020.
//  Copyright © 2020 Spektra Inc. All rights reserved.
//

import Foundation
import SwiftUI

public class Spektra : NSObject {

    var publicKey: String
    var secretKey: String
    
     public init(_ private_key: String, _ secret_key: String) {
        self.publicKey = private_key
        self.secretKey = secret_key
    }
       
       func toBase64(str: String) -> String {
           let base64Encoded = str.data(using: String.Encoding.utf8)!.base64EncodedString()
           return base64Encoded
       }

       struct AuthResponse: Codable {
           let access_token: String
           let token_type: String
           let expires_in: Int
           let scope: String
       }

       struct CheckoutResponse: Codable {
           let checkoutID: String
           let message: String
           let status: String
       }
    

        public func checkout(currency: String, amount: Double, description: String, spektraAccountName: String, successURL: String, cancelURL: String) -> Void {
            let Url = String(format: "https://api.spektra.co/oauth/token?grant_type=client_credentials")
            let str = publicKey + ":" + secretKey
            let token = toBase64(str: str)
           
           
                  guard let serviceUrl = URL(string: Url) else { return }
                   let parameters: [String: Any] = [:]
                  var request = URLRequest(url: serviceUrl)
                  request.httpMethod = "POST"
                  request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
                  request.setValue("Basic " + token, forHTTPHeaderField: "Authorization")
                  guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                      return
                  }
                  request.httpBody = httpBody
                  request.timeoutInterval = 20
           
                  let session = URLSession.shared
                  session.dataTask(with: request) { (data, response, error) in
                      if let response = response {
                          print(response)
                       
                      }
                      if let data = data {
                        do {
                          let json = try JSONDecoder().decode(AuthResponse.self, from: data)
                          print(json)

                          let accessToken = json.access_token
                           let checkoutData: [String: Any] = [
                               "currency": currency,
                                "amount": amount,
                                "description": description,
                                "spektraAccountName": spektraAccountName,
                                "successURL": successURL,
                                "cancelURL": cancelURL
                           ]
                           
                            self.completeCheckout(checkoutData: checkoutData, accessToken: accessToken)
                          
                        } catch {
                           print(error)
                        }
                      }
                  }.resume()
       }

        func completeCheckout(checkoutData: [String: Any], accessToken: String){
             let Url = String(format: "https://api.spektra.co/api/v1/checkout/initiate")
                  guard let serviceUrl = URL(string: Url) else { return }
                  
                  var request = URLRequest(url: serviceUrl)
                  request.httpMethod = "POST"
                  request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
                  request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
                  guard let httpBody = try? JSONSerialization.data(withJSONObject: checkoutData, options: []) else {
                      return
                  }
                  request.httpBody = httpBody
                  request.timeoutInterval = 20
           
                  let session = URLSession.shared
                  session.dataTask(with: request) { (data, response, error) in
                      if let response = response {
                          print(response)
                       
                      }
                   if let data = data {
                     do {
                       let json = try JSONDecoder().decode(CheckoutResponse.self, from: data)
                       print(json)
                       
                       let checkoutUrl = "https://checkout.spektra.co/" + json.checkoutID
                       
                       guard let url = URL(string: checkoutUrl) else {
                         return //be safe
                       }

                       if #available(iOS 10.0, *) {
                           UIApplication.shared.open(url, options: [:], completionHandler: nil)
                       } else {
                           UIApplication.shared.openURL(url)
                       }
                       
                     } catch {
                        print(error)
                     }
                   }
                  }.resume()
       }


}

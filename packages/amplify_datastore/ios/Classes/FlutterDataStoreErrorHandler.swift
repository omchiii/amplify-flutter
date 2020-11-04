/*
 * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

import Foundation
import Amplify
import AmplifyPlugins

class FlutterDataStoreErrorHandler {
    
    static func handleDataStoreError(error: DataStoreError, flutterResult: FlutterResult, msg: String) {
        if case .internalOperation(let localizedError, let recoverySuggestion, let error) = error {
            let errorCode = error != nil ? "\(error!)" : "unknown"
            formatError(flutterResult: flutterResult,
                        errorCode: errorCode,
                        msg: msg,
                        localizedError: localizedError,
                        recoverySuggestion: recoverySuggestion)

        }
        if case .configuration(let localizedError, let recoverySuggestion, let error) = error {
            let errorCode = error != nil ? "\(error!)" : "configuration"
            formatError(flutterResult: flutterResult,
                        errorCode: errorCode,
                        msg: msg,
                        localizedError: localizedError,
                        recoverySuggestion: recoverySuggestion)

        }
        if case .invalidCondition(let localizedError, let recoverySuggestion, let error) = error {
            let errorCode = error != nil ? "\(error!)" : "invalidCondition"
            formatError(flutterResult: flutterResult,
                        errorCode: errorCode,
                        msg: msg,
                        localizedError: localizedError,
                        recoverySuggestion: recoverySuggestion)

        }
        if case .decodingError(let localizedError, let recoverySuggestion) = error {
            let errorCode = "decodingError"
            formatError(flutterResult: flutterResult,
                        errorCode: errorCode,
                        msg: msg,
                        localizedError: localizedError,
                        recoverySuggestion: recoverySuggestion)

        }
        if case .unknown(let localizedError, let recoverySuggestion, let error) = error {
            let errorCode = error != nil ? "\(error!)" : "unknown"
            formatError(flutterResult: flutterResult,
                        errorCode: errorCode,
                        msg: msg,
                        localizedError: localizedError,
                        recoverySuggestion: recoverySuggestion)

        }
    }
    
    static func platformExceptions(localizedError: String, recoverySuggestion: String) -> [String: String] {
        var platformDict: [String: String] = [:]
        platformDict["platform"] = "iOS"
        platformDict["localizedErrorMessage"] = localizedError
        platformDict["recoverySuggestion"] = recoverySuggestion
        return platformDict
    }
    
    static func formatError(flutterResult: FlutterResult,
                     errorCode: String,
                     msg: String,
                     localizedError: String,
                     recoverySuggestion: String) {
        var errorMap: [String: Any] = [errorCode: localizedError]
        errorMap["PLATFORM_EXCEPTIONS"] =
            platformExceptions(localizedError: localizedError, recoverySuggestion: recoverySuggestion)
        prepareError(flutterResult: flutterResult,  msg: msg, errorMap: errorMap)
    }
    
    static func prepareError(flutterResult: FlutterResult, msg: String, errorMap: [String: Any]) {
        flutterResult(FlutterError(
                        code: "AmplifyException",
                        message: msg,
                        details: errorMap)
        )
    }
}

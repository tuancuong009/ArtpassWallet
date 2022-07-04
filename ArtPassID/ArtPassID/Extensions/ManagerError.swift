//
//  ManagerError.swift
//  Ticketro
//
//  Created by David on 6/21/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit


class ErrorManager {
    static func processError(error: Error? = nil, errorCode: Int? = nil, errorMsg: String? = nil) -> ErrorModel {
        
        var errorModel: ErrorModel?
        if error == nil {
            errorModel = ErrorModel.error(errorCode: errorCode ?? 99999, errorMessage: errorMsg)
        } else {
            errorModel = ErrorModel.error(error: error!)
        }
        return errorModel!
    }
}

class ErrorModel {
    
    var title: String?
    var code: Int?
    var msg: String?
    static func error(error: Error) -> ErrorModel {
        
        let code = error._code
        let message = error.localizedDescription
        let title = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        return ErrorModel(title: title, code: code, msg: message)
    }
    
    /// For custom error
    static func error(errorCode: Int, errorMessage: String?) -> ErrorModel {
        
        let errorModel: ErrorModel?
        
        // For all errors from server
        errorModel = ErrorModel(title: nil, code: errorCode, msg: errorMessage ?? "" )
        
        return errorModel!
        
    }
    
    init(title: String?, code: Int?, msg: String? ) {
        self.title = title
        self.code = code
        self.msg = msg
    }
}

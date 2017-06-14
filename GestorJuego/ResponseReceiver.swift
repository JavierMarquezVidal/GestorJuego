//
//  ResponseReceiver.swift
//  GestorJuego
//
//  Created by dam on 5/6/17.
//  Copyright © 2017 dam. All rights reserved.
//

import Foundation
protocol ResponseReceiver {
    func onDataReceived(data: Data)
    func onErrorReceivingData(message: String)
}

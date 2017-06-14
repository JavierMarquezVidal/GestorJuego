//
//  Cliente.swift
//  GestorJuego
//
//  Created by dam on 5/6/17.
//  Copyright © 2017 dam. All rights reserved.
//

import Foundation
class Cliente {
    //let urlApi: String = "https://gestor-juegos-jmarquez-1.c9users.io/ios/"
    let urlApi: String = "https://gestor-juegos-jmarquez-1.c9users.io/ios/"
    let configuracion = URLSessionConfiguration.default
    var datos: [String:Any]?
    var metodo: String
    let respuesta: ResponseReceiver
    var sesion: URLSession
    var url: URL?
    var urlDestino: String
    var urlPeticion: URLRequest
    
    init?(destino: String, respuesta: ResponseReceiver, _ metodo: String = "PUT", _ datos : [String:Any] = [:]) {
        self.datos = datos
        self.metodo = metodo
        self.respuesta = respuesta
        self.sesion = URLSession(configuration: self.configuracion)
        self.urlDestino = destino
        guard let url = URL(string: self.urlApi + self.urlDestino) else {
            return nil
        }
        print(self.urlApi + self.urlDestino)
        self.url = url
        self.urlPeticion = URLRequest(url: self.url!)
        self.urlPeticion.httpMethod = self.metodo
    }
    
    func request()->Bool {
        if self.metodo != "GET" && self.datos != nil && self.datos!.count > 0{
            
            guard let json = try? JSONSerialization.data(withJSONObject: self.datos as Any,
                                                         options: []) else {
                                                            return false
            }
            self.urlPeticion.addValue("application/json",
                                      forHTTPHeaderField: "Content-Type")
            self.urlPeticion.httpBody = json
        }
        let tarea = self.sesion.dataTask(with: self.urlPeticion,
                                         completionHandler: self.callBack)
        tarea.resume()
        return true
    }
    
    private func callBack(_ data: Data?, _ respuesta: URLResponse?, _ error: Error?) {
        guard error == nil else {
            self.respuesta.onErrorReceivingData(message: "Error en la recepción");
            return
        }
        guard let datosRespuesta = data else {
            self.respuesta.onErrorReceivingData(message: "Sin datos");
            return
        }
        DispatchQueue.main.async{
            self.respuesta.onDataReceived(data: datosRespuesta)
        }
    }
    
}

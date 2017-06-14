//
//  ViewControllerDetalles.swift
//  GestorJuego
//
//  Created by dam on 11/5/17.
//  Copyright © 2017 dam. All rights reserved.
//

import Foundation


func viewDidLoad() {

    class Grupo {
        var id: Int!
        var nombre: String?
        
        init() {
            id = 0
            nombre = ""
        }
        
        init(id: Int, nombre: String?) {
            self.id = id
            self.nombre = nombre
        }
        init(_ diccionario: [String: Any]){
            self.id = diccionario["id"] as? Int
            self.nombre = diccionario["nombre"] as? String
        }
        
        
}

}

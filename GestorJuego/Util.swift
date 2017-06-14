//
//  Util.swift
//  GestorJuego
//
//  Created by dam on 5/6/17.
//  Copyright © 2017 dam. All rights reserved.
//

import Foundation

class Util {
    static func listadoJuegos(datos: Data)->Array<Juego>?{
        let listado: [Juego] = []
        do {
            guard let respuesta = try JSONSerialization.jsonObject(with: datos, options: []) as?[String: Any] else{
                print("error")
                return nil
            }
            guard let juegos = respuesta["juegos"] as?[[String: Any]] else {
                return nil
            }
            var listado: [Juego] = []
            for i in 0 ..< juegos.count {
                let p = Juego(juegos[i])
                listado.append(p)
                print(i, p)
            }
        } catch {
            print ("fallo")
        }
        return listado
    }
}

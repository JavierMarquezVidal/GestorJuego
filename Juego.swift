//
//  Juegos.swift
//  GestorJuego
//
//  Created by dam on 5/6/17.
//  Copyright © 2017 dam. All rights reserved.
//

import Foundation
class Juego{
    var id: Int
    var titulo: String?
    var imagen: String?
    var fecha_creacion: String?
    //var puntuacion: Int
    //var lanzador: String?
    var entradas: Entradas?
    
    init(_ id: Int, _ titulo: String?, _ imagen:String?, _ fecha_creacion: String?, /*_ puntuacion: Int,*/ _ entradas: Entradas? ){
        self.id = id
        self.titulo = titulo
        self.imagen = imagen
        self.fecha_creacion = fecha_creacion
        //self.puntuacion = puntuacion
        self.entradas = entradas
    }
    
    init(_ array: [String: Any]){
        self.id = array["id"] as! Int
        self.titulo = array["titulo"] as? String
        self.imagen = array["imagen"] as? String
        self.fecha_creacion = array["fecha_creacion"] as? String
        //self.puntuacion = array ["puntuacion"] as! Int
        //self.lanzador = array ["lanzador"] as? String
        self.entradas = Entradas (array["entradas"] as! [String: Any])
    }
    
    public func juegoToDict(juego : Juego) -> [String : Any]{
        let dict: [String: Any?] = [
            "id": juego.id,
            "titulo": juego.titulo,
            "imagen": juego.imagen,
            "fecha_creacion": juego.fecha_creacion,
            //"puntuacion": juego.puntuacion,
            //"lanzador": juego.lanzador,
            "identrada": juego.entradas!.id,]
        return dict
    }

}

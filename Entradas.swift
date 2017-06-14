//
//  Entradas.swift
//  GestorJuego
//
//  Created by dam on 5/6/17.
//  Copyright © 2017 dam. All rights reserved.
//

import Foundation
class Entradas{
    var id: Int
    var tipo: String?
    var descripcion: String?
    var imagen: String?
    var fechacreacion: String?
    var fechamodificacion: String?
    
    init(_ id: Int, _ tipo: String?, _ descripcion: String?, _ imagen: String?, _ fechacreacion: String?,  _ fechamodificacion: String?) {
        self.id = id
        self.tipo = tipo
        self.descripcion = descripcion
        self.imagen = imagen
        self.fechacreacion = fechacreacion
        self.fechamodificacion = fechamodificacion

    }
    
    init(_ array: [String: Any]){
        self.id = array["id"] as! Int
        self.tipo = array ["tipo"] as? String
        self.descripcion = array ["descripcion"] as? String
        self.imagen = array["imagen"] as? String
        self.fechacreacion = array["fechacreacion"] as? String
        self.fechamodificacion = array ["fechamodificacion"] as? String
    
    }
    
    public func entradasToDict(entradas : Entradas) -> [String : Any]{
        let dict: [String: Any?] = [
            "id": entradas.id,
            "tipo": entradas.tipo,
            "descripcion": entradas.descripcion,
            "imagen": entradas.imagen,
            "fechacreacion": entradas.fechacreacion,
            "fechamodificacion": entradas.fechamodificacion,]
        return dict
    }
    
}

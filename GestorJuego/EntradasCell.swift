//
//  EntradasCell.swift
//  GestorJuego
//
//  Created by dam on 9/6/17.
//  Copyright © 2017 dam. All rights reserved.
//

import UIKit

class EntradasCell: UITableViewCell {
    
    @IBOutlet weak var tipoLabel: UILabel!
    
    @IBOutlet weak var imagenView: UIImageView!
    
    @IBOutlet weak var fechacreacionLabel: UILabel!
    
    @IBOutlet weak var fechamodificacionLabel: UILabel!
    
    @IBOutlet weak var Descripcion: UITextView!
    
    var entradas: Entradas! {
        didSet {
            tipoLabel.text = entradas.tipo
            fechacreacionLabel.text = entradas.fechacreacion
            fechamodificacionLabel.text = entradas.fechamodificacion
            Descripcion.text = entradas.descripcion
            setImageURL(foto: entradas.imagen!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setImageURL(foto: String){
        //let ruta = "https://gestor-juegos-jmarquez-1.c9users.io/sources/images/"+foto
        let ruta = "https://gestor-juegos-jmarquez-1.c9users.io/sources/images/"+foto
        if let url = NSURL(string: ruta) {
            if let data = NSData(contentsOf: url as URL) {
                imagenView.image = UIImage(data: data as Data)
            }
        }
    }
    
}

//
//  JuegoCell.swift
//  GestorJuego
//
//  Created by dam on 7/6/17.
//  Copyright © 2017 dam. All rights reserved.
//

import UIKit

class JuegoCell: UITableViewCell {
    
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var imagenView: UIImageView!
    @IBOutlet weak var fechacreacionLabel: UILabel!

    

    
    var juego: Juego! {
        didSet {
            tituloLabel.text = juego.titulo
            fechacreacionLabel.text = juego.fecha_creacion
            //puntuacionLabel.text = juego.puntuacion
            setImageURL(foto: juego.imagen!)
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

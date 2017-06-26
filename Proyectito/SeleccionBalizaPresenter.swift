//
//  SeleccionBalizaPresenter.swift
//  Proyectito
//
//  Created by Loquat Solutions on 26/6/17.
//  Copyright © 2017 MHP. All rights reserved.
//


import Foundation
import UIKit

protocol SeleccionBalizaView: NSObjectProtocol {
    func setBalizas(balizas: [Baliza])

}


class SeleccionBalizaPresenter {
    fileprivate let seleccionBalizaService: SeleccionBalizaService
    weak fileprivate var seleccionBalizaView : SeleccionBalizaView?
    
    init(seleccionBalizaService: SeleccionBalizaService) {
        self.seleccionBalizaService = seleccionBalizaService
    }
    
    func attachView(_ view: SeleccionBalizaView){
        self.seleccionBalizaView = view
    }
    
    func detachView() {
        self.seleccionBalizaView = nil
    }
    
    func obtenerBalizas() {
        self.seleccionBalizaService.obtenerBalizas(callback: { (balizas) in
            self.seleccionBalizaView?.setBalizas(balizas: balizas)
        })
    }
    


}

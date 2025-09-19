// DESTINOS
object PuenteBrooklyn{
method puedeEntrar(mensajero) = mensajero.peso() <= 1000
}
object Matrix {
method puedeEntrar(mensajero) = mensajero.puedeLlamar()
}

//PAQUETE
object Paquete {
  var estaPagado = false
  method peso(){return 50}
  method estaPagado(){return estaPagado}
  method cambiarPago(){estaPagado = not estaPagado}
}
object Paquetito {
  method peso(){return 1}             
  method estaPagado(){return true}    
}
object PaquetonViajero {
  var destinos = []
  var montoPagado = 0
  method precio(){return destinos.size() * 100}
  method agregarDestino(unDestino){destinos.add(unDestino)}
  method pagar(monto){montoPagado += monto}
  method estaPagado(){return montoPagado >= self.precio()}
  method puedeSerEntregadoPor(mensajero){
    return self.estaPagado() and destinos.all { destino => destino.puedeEntrar(mensajero) }
  }
  method peso(){return 200}   
}

//FUNCION PARA ENTREGAR
object Entrega {
  method puedeEntregar(mensajero, paquete, destino) = 
    mensajero.peso() <= 10000 and paquete.estaPagado() and destino.puedePasar(mensajero.puedeLlamar())
}

// MENSAJEROS
object Roberto {
  var peso = 0
  var viajeEnBici = true
  var acoplados = 0
  method pesoBase(){return 90}
  method peso() {
    if (viajeEnBici) {
      peso = self.pesoBase() + 5     
    } else {
      peso = self.pesoBase() + acoplados * 500   
    }
    return peso
  }
  method puedeLlamar(){return false}
  method usarBici(){viajeEnBici = true }
  method usarCamion(){viajeEnBici = false }
  method cambiarAcoplados(cantidad){acoplados = cantidad }
}
object ChuckNorris {
  method peso() = 80
  method puedeLlamar() = true
}
object Neo {
  var vuela = true
  var credito = true
  method peso(){
    if (vuela) { 
      0 
    } else { 
      70 }
  }
  method puedeLlamar(){credito}
  method cambiarSiPuedeVolar(){vuela = not vuela}
  method cambiarCredito(){credito = not credito} 
}
object Hermes {
  method peso(){return 70}
  method puedeLlamar(){return true}
}

//Mensajeria
object EmpresaMensajeria {
  var mensajeros = []
  var pendientes = []
  var facturacion = 0
  method contratar(mensajero){mensajeros.add(mensajero)}
  method despedir(mensajero){mensajeros.remove(mensajero)}
  method despedirATodos(){mensajeros.clear()}
  method esGrande(){mensajeros.size() > 2}
  method primerPuedeEntregar(paquete, destino){
    if (mensajeros.isEmpty()) {
      false
    } else {
      Entrega.puedeEntregar(mensajeros.first(), paquete, destino)
    }
  }  
  method pesoUltimoMensajero(){
    if (mensajeros.isEmpty()){
      0
    } else {
      mensajeros.last().peso()
    }
  }  
  /*method mensajerosQuePueden(paquete) {
    return mensajeros.filter { m => self.mensajeroPuedeEntregar(m, paquete) }
  }
  method mensajeroPuedeEntregar(m, paquete){
    return paquete.estaPagado() and 
           (paquete.respondsTo("puedeSerEntregadoPor") 
              ? paquete.puedeSerEntregadoPor(m) 
              : true) and
           m.peso() <= 10000
  }
  method tieneSobrepeso(){return (mensajeros.map { m => m.peso() }.sum() / mensajeros.size()) > 500}
  method enviar(paquete){
    var disponibles = self.mensajerosQuePueden(paquete)
    if (disponibles.isEmpty()) {
      pendientes.add(paquete)
    } else {
      facturacion += (paquete.respondsTo("precio") ? paquete.precio() : 50)
    }
  }
  method facturacionTotal(){return facturacion}
  method enviarTodos(listaPaquetes) {
    listaPaquetes.forEach{ p => self.enviar(p) }
  }
  method enviarPendienteMasCaro() {
    if (pendientes.isEmpty()) return
    var masCaro = pendientes.max { p => (p.respondsTo("precio") ? p.precio() : 50) }
    self.enviar(masCaro)
    pendientes.remove(masCaro)
  }*/
} //Arreglar
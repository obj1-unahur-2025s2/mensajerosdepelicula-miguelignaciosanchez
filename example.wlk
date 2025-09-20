// DESTINOS
object puenteBrooklyn{
method puedeEntrar(mensajero){return mensajero.peso() <= 1000}
}
object matrix {
method puedeEntrar(mensajero){return mensajero.puedeLlamar()}
}

//PAQUETE
object paquete {
  var estaPagado = false
  method peso(){return 50}
  method estaPagado(){return estaPagado}
  method cambiarPago(){estaPagado = not estaPagado}
  method puedeSerEntregadoPor(mensajero, destino) {
    return self.estaPagado() && destino.puedeEntrar(mensajero)
  }
}
object paquetito {
  method peso(){return 1}             
  method estaPagado(){return true}
  method puedeSerEntregadoPor(mensajero, destino) {
    return destino.puedeEntrar(mensajero)  
  }
}
object paquetonViajero {
  var destinos = []
  var montoPagado = 0
  method peso(){return 200}
  method precio(){return destinos.size() * 100}
  method agregarDestino(unDestino){destinos.add(unDestino)}
  method pagar(monto){montoPagado += monto}
  method estaPagado(){return montoPagado >= self.precio()}
  method puedeSerEntregadoPor(mensajero, destinoIgnorado) {
  return self.estaPagado() && destinos.all { d => d.puedeEntrar(mensajero) }
}   
}

//FUNCION PARA ENTREGAR
object entrega {
  method puedeEntregar(mensajero, paquete, destino) {
    return paquete.puedeSerEntregadoPor(mensajero, destino)
  }
}

// MENSAJEROS
object roberto {
  var peso = 0
  var viajeEnBici = true
  var acoplados = 0
  method pesoBase(){return 90}
  method peso(){
    if (viajeEnBici){
      peso = self.pesoBase() + 5     
    } else {
      peso = self.pesoBase() + (acoplados * 500)   
    }
    return peso
  } 
  method puedeLlamar(){return false}
  method usarBici(){viajeEnBici = true }
  method usarCamion(){viajeEnBici = false }
  method cambiarAcoplados(cantidad){acoplados = cantidad}
}
object chuckNorris {
  method peso() = 80
  method puedeLlamar() = true
}
object neo {
  var puedeVolar = true
  var credito = true
  method peso(){
    if (puedeVolar) { 
      return 0 
    } else { 
      return 70 }
  } 
  method puedeLlamar(){credito}
  method cambiarSiPuedeVolar(){puedeVolar = not puedeVolar}
  method cambiarCredito(){credito = not credito} 
}
object hermes {
  method peso(){return 70}
  method puedeLlamar(){return true}
}

//Mensajeria
object empresaMensajeria{
  var mensajeros = []
  var paquetesPendientes = []
  var paquetesEnviados = []
  var facturacion = 0
  method contratar(nuevoMensajero){mensajeros.add(nuevoMensajero)}
  method despedir(unMensajero){mensajeros.remove(unMensajero)}
  method despedirATodos(){mensajeros.clear()}
  method esGrande(){return mensajeros.size() > 2}
  method puedeEntregarPrimero(paquete, destino){
    return entrega.puedeEntregar(mensajeros.first(), paquete, destino)
  }     
  method pesoUltimoMensajero(){return mensajeros.last().peso()}
  method puedeEntregar(paquete, destino) {
    return mensajeros.any { m => entrega.puedeEntregar(m, paquete, destino) }
  }
  method mensajerosQuePueden(paquete, destino) {
    return mensajeros.filter { m => entrega.puedeEntregar(m, paquete, destino) }
  }
  method tieneSobrepeso() {
  if (mensajeros.isEmpty()) { 
    return false 
  }
  var promedio = mensajeros.map { m => m.peso() }.sum() / mensajeros.size()
  return promedio > 500
  }
  method enviar(paquete, destino) {
  var disponibles = self.mensajerosQuePueden(paquete, destino)
  if (disponibles.isEmpty()) {
    paquetesPendientes.add(paquete)
  } else {
    paquetesEnviados.add(paquete)
      if (paquete.respondsTo("precio")) {
        facturacion += paquete.precio()
      } else if (paquete.peso() <= 50) { 
        facturacion += 50   
      } else { 
        facturacion += 100  
      }
    }
  }
  method facturacionTotal() {return facturacion}
  method enviarTodos(listaPaquetes, destino) {
    listaPaquetes.forEach { p => self.enviar(p, destino) }
  }
}

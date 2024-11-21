import metodos.*
import elementos.*
class UserException inherits Exception {}

class Persona{
    var property cosas = []
    var property salario
    var property costos = 0

    var property metodoFavorito 
    var property efectivo = new MetodoPago (saldo = 0) //Si o si tiene efectivo
    var property formasDePago = [self.efectivo()]

    var property cuotasVencidas = []
    var property cuotasPendientes = []

    var property mesInicial = new Mes(mes = 1)
    var property mesActual = mesInicial

    method comprar(metodo, cosa) = metodo.usar(cosa, self)
    method comprarFavorito(cosa) = self.comprar(metodoFavorito, cosa) 

    method cambiarFavorito(nuevo){
        metodoFavorito = formasDePago.anyOne()
    }

    method agregarCosa(cosa){
        cosas.add(cosa)
    }

    method aumentarSueldo(cantidad){
        salario += cantidad
    }

 // -----------------------
    method puedePagar(cuota) = cuota.valor() <= salario - costos

    method intentarPagar(cuota){
        cuotasPendientes.remove(cuota)
        cuotasVencidas.remove(cuota)
        if(self.puedePagar(cuota)){
            costos += cuota.valor()
        }else{
            self.noPuedePagar(cuota)
        }
    }

    method noPuedePagar(cuota){ //Metodo creado para el pagador compulsivo
        cuotasVencidas.add(cuota)
    }

    method cobrarSueldo(){
        efectivo.ganar(salario - costos)
    }

    method cambiarMes(){
        costos = 0  
        self.pagarCuotas(self.cuotasDelMes() + cuotasVencidas)
        self.cobrarSueldo()
        mesActual = mesActual.mesSiguiente()
    }

    method cuotasDelMes() = cuotasPendientes.filter({cuota => cuota.mesAsignado() == mesActual.mes()})

    method pagarCuotas(cuotas){
        cuotas.forEach({cuota => self.intentarPagar(cuota)})
    }

    method registrarCuotas(monto, cuotas){
        const cuota = new Cuota (mesAsignado = mesActual.mes() + cuotas -1, valor = monto)
        if (cuotas ==1){
            cuotasPendientes.add(cuota)
        }else if(!cuotasPendientes.contains(cuota)){
            cuotasPendientes.add(cuota)
            self.registrarCuotas(monto, cuotas-1)
        }
    }
}

// 6. Persona que mas cosas tiene
object grupo{
    var property personas = []
    method cantidadCosas(persona) = persona.cosas().length()
    method quienMasTiene() = personas.max({persona => self.cantidadCosas(persona)})
}


// Parte 2

class CompradorCompulsivo inherits Persona{
    method puedeCon(valor) = formasDePago.find({metodo => self.puede(metodo, valor)})
    method puede(metodo, valor) = metodo.condicion(valor, self)
    method noPuedeFavorito(valor) = !self.puede(metodoFavorito, valor)
    
    override method comprarFavorito (cosa) = if (self.noPuedeFavorito(cosa.valor())){self.buscarNuevoMetodo(cosa)}else{super(cosa)}
    method buscarNuevoMetodo(cosa){
        self.comprar(self.puedeCon(cosa.valor()), cosa)
    }
}

class PagadorCompulsivo inherits Persona{
    override method noPuedePagar(cuota){
        if(efectivo.condicion(cuota.valor(), self)){
            efectivo.usar(cuota, self)
        }else{
            super(cuota)
        }
    }
}

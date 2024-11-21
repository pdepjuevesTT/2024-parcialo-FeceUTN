import metodos.*
class UserException inherits Exception {}

class Persona{
    var property cosas = []
    var property metodoFavorito = efectivo
    var property salario
    var property efectivo = new Efectivo (saldo = 0) //Si o si tiene efectivo
    var property formasDePago = [efectivo]
    var property cuotasVencidas = []
    var property mesInicial = new Mes(mes = 1)
    var property mesActual = mesInicial

    method comprar(metodo, cosa) = metodo.usar(cosa, self)
    method comprarFavorito(cosa) = self.comprar(metodoFavorito, cosa) 

    method cambiarFavorito(nuevo){
        if(formasDePago.contains(nuevo)){
            metodoFavorito = nuevo
        }else{
            throw new UserException (message = "Persona no tiene este metodo de pago")
        }
        
    }

    method agregarCosa(cosa){
        cosas.add(cosa)
    }

    method aumentarSueldo(cantidad){
        salario += cantidad
    }

    method cobrarSueldo(){
        efectivo.ganar(salario - mesActual.total())
    }

    method cambiarMes(){
        const siguiente = mesActual.mesSiguiente()
        mesActual = new Mes (mes = siguiente)
    }

    method agregarCuota(monto){
        
    }

    method registrarCuotas(monto, cuotas){
        // cuotas.times(self.agregarCuota(monto))
    }

}

class Cosa{
    var property precio
}

class Mes{
    var property mes
    method mesSiguiente() = mes + 1
    
    var property gastos = [] // Lista de cuotas
    var property total = gastos.sum({cuota => cuota.valor()})
    method nuevoMes() = new Mes (mes = self.mesSiguiente())

}

class Cuota{
    var property mesAsignado
    var property valor
}

/*
Credito y gastos mensuales!!!
cuotas impagas vencidas
*/

// Parte 2

class CompradorCompulsivo inherits Persona{
    method puedeCon(precio) = formasDePago.find({metodo => self.puede(metodo, precio)})
    method puede(metodo, precio) = metodo.condicion(precio, self)
    method noPuedeFavorito(precio) = !self.puede(metodoFavorito, precio)
    
    override method comprarFavorito (cosa) = if (self.noPuedeFavorito(cosa.precio())){self.buscarNuevoMetodo(cosa)}else{super(cosa)}
    method buscarNuevoMetodo(cosa){
        self.comprar(self.puedeCon(cosa.precio()), cosa)
    }
}

class PagadorCompulsivo inherits Persona{

}

import persona.*

class MetodoPago{
    var property saldo 
    method condicion(costo, persona) = costo <= saldo

    method ganar(cantidad){
        saldo += cantidad
    }

    method gastar(cantidad, persona){
        self.ganar(-cantidad)
    }

    method usar(cosa, persona){  // ver posible optimizacion y abstraccion
        const precio = cosa.precio()
        if(self.condicion(precio, persona)){
           self.gastar(precio, persona)
           persona.agregarCosa(cosa)
        } else{
            throw new UserException (message = "No se puede usar esta forma de pago")
        }
    }

}

class Efectivo inherits MetodoPago{

}

class Debito inherits MetodoPago{

}

class CuentaMultiple inherits Debito{
    const duenios = []
    override method condicion (costo, persona) = super(costo, persona) and duenios.contains(persona)
}


class Credito inherits MetodoPago{
    var property montoPermitido
    var property cuotas
    var property interes

    method calculoGasto(monto) = monto / cuotas * interes
    override method condicion(costo, persona) = super(montoPermitido, persona)

    override method gastar(cantidad, persona){ // POSIBLE CONDICION EN SUPERCLASE
        persona.registrarCuotas(self.calculoGasto(cantidad), cuotas)
    }
}

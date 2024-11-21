class Persona{
    var property cosas = []
    var property formasDePago = [efectivo]
    var property metodoFavorito
    var property salario
    var property efectivo = new Efectivo (saldo = 0) //Si o si tiene efectivo

    method usar(metodo, cosa) = metodo.usar(cosa, self)
    method usarFavorito(cosa) = self.usar(metodoFavorito, cosa) 

    method agregarCosa(cosa){
        cosas.add(cosa)
    }

    method aumentarSueldo(cantidad){
        salario += cantidad
    }

    method cobrarSueldo(){
 // falta
    }
}

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
        persona.gastoMensual(self.calculoGasto(cantidad), cuotas)
    }
}

class Cosa{
    var property precio
}

/*
Sueldo
*/

class UserException inherits Exception {}

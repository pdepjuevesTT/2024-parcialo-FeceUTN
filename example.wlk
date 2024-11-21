class Persona{
    var property cosas = []
    var property formasDePago = []
    var property metodoFavorito 
    var property plata

    method usar(metodo, cosa) = metodo.usar(cosa, self)
    method usarFavorito(cosa) = self.usar(metodoFavorito, cosa) 

    method agregarCosa(cosa){
        cosas.add(cosa)
    }
}

class MetodoPago{
    var property saldo
    method condicion(costo) = costo <= saldo

    method ganar(cantidad){
        saldo += cantidad
    }

    method gastar(cantidad, persona){
        self.ganar(-cantidad)
    }

    method pagar(cosa,persona){
        self.gastar(cosa.precio(), persona)
        persona.agregarCosa(cosa)
    }

    method usar(cosa, persona){
        if(self.condicion(cosa.precio())){
           self.pagar(cosa, persona) 
        } else{
            throw new UserException (message = "No se puede usar esta forma de pago")
        }
    }

}

class Efectivo inherits MetodoPago {

} //Falta convertir a objeto


class Debito inherits MetodoPago{
    var property duenios = []

}

class Credito inherits MetodoPago{
    var property montoPermitido
    var property cuotas
    var property interes

    method calculoGasto(monto) = monto / cuotas * interes

    override method gastar(cantidad, persona){ // POSIBLE CONDICION EN SUPERCLASE
        persona.gastoMensual(self.calculoGasto(cantidad), cuotas)
        
    }
}

class CuentaBancaria{  // CONSIDERAR SUBCLASE CUENTACOMPARTIDA
    var property duenios = [] 
    var property saldo

    method gastar (cantidad){
        saldo -= cantidad
    }
}

class Cosa{
    var property precio
}

/*
Que falta: 
1.
Superclase metodo de pago
Cuando no se pueda pagar (saldo y restricciones)
Repeticion de codigo
*/

class UserException inherits Exception {}

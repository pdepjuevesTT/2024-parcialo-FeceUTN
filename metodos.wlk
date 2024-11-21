import persona.*
import elementos.*
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
        const valor = cosa.valor()
        if(self.condicion(valor, persona)){
           self.gastar(valor, persona)
           persona.agregarCosa(cosa)
        } else{
            throw new UserException (message = "No se puede usar esta forma de pago")
        }
    }

}

class Efectivo inherits MetodoPago{

}

class Debito inherits Efectivo{

}

class CuentaMultiple inherits Debito{
    const duenios = []
    override method condicion (costo, persona) = super(costo, persona) and duenios.contains(persona)
}


class Credito inherits MetodoPago{
    method montoPermitido() = saldo
    var property cuotas
    var property interes

    method calculoGasto(monto) = monto / cuotas * interes

    override method gastar(cantidad, persona){
        persona.registrarCuotas(self.calculoGasto(cantidad), cuotas)
    }
}

class Prestamo inherits Credito{
    override method condicion(costo, persona) = super(costo, persona) and persona.cuotasVencidas().isEmpty() // debe estar libre de deudas

    override method calculoGasto (monto) = monto / cuotas * (interes*cuotas) // interes depende de las cuotas del prestamo
}
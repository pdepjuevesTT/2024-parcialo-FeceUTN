class Persona{
    var property cosas = []
    var property formasDePago = []
    var property metodoFavorito 
    var property plata

    method ganar(cantidad){
        plata += cantidad
    }

    method gastar(cantidad){
        self.ganar(-cantidad)
    }

    method pagar(metodo, cosa) = metodo.pagar(cosa, self)
    method pagarFavorito(cosa) = self.pagar(metodoFavorito, cosa) 

    method agregarCosa(cosa){
        cosas.add(cosa)
    }
}

class Efectivo{
    method pagar(cosa, persona){
        persona.gastar(cosa.precio())
        persona.agregarCosa(cosa)
    }
}

class Debito{
    var property cuentaAsociada
    method pagar(cosa,persona){

    }
}

class CuentaBancaria{  // CONSIDERAR SUBCLASE CUENTACOMPARTIDA
    var property duenios = [] 
    var property saldo

    method gastar ()
}

class Cosa{
    var property precio
}

/*
Que falta: 
1.
Cuando no se pueda pagar (saldo y restricciones)
Sueldo
Repeticion de codigo gastar
Forma preferida
*/

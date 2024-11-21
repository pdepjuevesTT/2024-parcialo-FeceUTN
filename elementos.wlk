import persona.*
import metodos.*
class Cosa{
    var property valor
}

class Mes{
    var property mes
    method mesSiguiente() = new Mes (mes = mes + 1)
    method gastosPersona(persona) = persona.cuotasPendientes().filter({cuota => cuota.mesAsignado() == mes})
}

class Cuota{
    var property mesAsignado
    var property valor
}

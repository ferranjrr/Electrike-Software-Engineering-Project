import 'package:flutter_project/domini/vehicle.dart';

class VhCombustible extends Vehicle {
  late double capacitatDeposit;

  late double emissioCo2;

  VhCombustible.complet (String id, String marca, String model,double potencia, double consum, this.capacitatDeposit, this.emissioCo2)
  : super.complet(id,  marca, model, potencia, consum,);

  VhCombustible.onlyComb(this.capacitatDeposit, this.emissioCo2): super.buit();

  // getter

  // setters

  @override
  set potencia(double potencia) {
    super.potencia = potencia;
  }

  @override
  set consum(double consum) {
    super.consum = consum;
  }

  @override
  set marca(String marca) {
    super.marca = marca;
  }

  @override
  set model(String model) {
    super.model = model;
  }

}
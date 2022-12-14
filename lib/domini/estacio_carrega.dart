import 'package:flutter_project/domini/coordenada.dart';

class EstacioCarrega{
   late String id;
   late String nom;
   late String direccio;
   late String ciutat;
   late Set<String> endolls;
   late Coordenada coord;

  EstacioCarrega.origin(){
     id = "1";
     nom = "nom";
     direccio ="carrer";
     ciutat = "ciutat";
     endolls = <String>{};
     coord = Coordenada(0.0, 0.0);
  }
   EstacioCarrega.senseendolls(this.id,this.nom, this.direccio, this.ciutat,this.coord){
     endolls = <String>{};
   }
   EstacioCarrega.ambendolls(this.id,this.nom, this.direccio, this.ciutat, this.endolls, this.coord);

   void addEndoll(String id){
      endolls.add(id);
   }
   bool isEndoll(String id){
     return endolls.contains(id);
   }
   void deleteEndoll(String id){
      endolls.remove(id);
  }
  int numEndolls(){
      return endolls.length;
  }
}
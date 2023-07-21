String Tgrelha = '0';
String Tsensor1 = '0';
String Tsensor2 = '0';
String TempAlvo = '0';

setTemp(Grelha, Sensor1, Sensor2, TAlvo){
  Tgrelha = Grelha;
  Tsensor1 = Sensor1;
  Tsensor2 = Sensor2;
  TempAlvo = TAlvo;
}

List<String> getTemp(){
  
  return ([Tgrelha, Tsensor1, Tsensor2, TempAlvo]);
}

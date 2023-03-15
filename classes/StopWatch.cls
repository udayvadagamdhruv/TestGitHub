Global class StopWatch {
 
/* Public string jstid;
 public decimal stime ;
 public string hours;
 public string minutes;*/
 
 /* webservice static JS_TS_Details__c  StopWatchMeth(string jstid){
   decimal stime ;
   string hours;
   string minutes;
  
  
  JS_TS_Details__c objTSDetail =[select id,name, End_Watch__c,Start_Watch__c,Hours_Worked__c from JS_TS_Details__c where Id =:jstid ];

   If(objTSDetail.Start_Watch__c !=null && objTSDetail.End_Watch__c!= null){
         if(objTSDetail.Start_Watch__c.getTime() <= objTSDetail.End_Watch__c.getTime() ){
            decimal var = ((objTSDetail.End_Watch__c.getTime() - objTSDetail.Start_Watch__c.getTime()) / (1000.0*60.0*60.0));
            stime=(var-Math.Floor(var))*60;
            hours= string.valueof(Math.Floor(var));
            minutes =string.valueof(stime.setScale(0,System.RoundingMode.HALF_EVEN));
            
            //return hours+':'+minutes ;
        }
        
    }
    
      if(schema.SobjectType.JS_TS_Details__c.Fields.Hours_Worked__c.isUpdateable()){ 
          objTSDetail.Hours_Worked__c =  decimal.valueof(hours)+(decimal.valueof(minutes)/100); 
      }
      if(Schema.sObjectType.JS_TS_Details__c.isUpdateable()){
          update objTSDetail;}

  return objTSDetail;

}

*/





}
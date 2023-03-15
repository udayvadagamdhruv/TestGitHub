//This trigger is used to update POLI's Estimate line item's field when POLI is deleted.
trigger Estimate_Line_Item_Update on PO_Line_Item__c(before insert,before update,after insert,after update,before delete,after delete) 
{
 // When any POLI is created its associated ELI will be updated (its PO created field and PO # filed).
  Public Boolean ShowProductionEstimate ;
  ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
  ShowProductionEstimate =activeSettings.Active__c;
  
  
 If(Trigger.isAfter && Trigger.isInsert)
   {
           /*  String ELIId,POId;
            
             for(PO_Line_Item__c POLI:Trigger.new)
              {
               ELIId=POLI.Estimate_Line_Item__c;
               POId = POLI.Purchase_Order__c;
              } 
 
              Estimate_Line_Items__c eli=[Select id,Name,PO__c,PO_Created__c from Estimate_Line_Items__c where id=: ELIId];
 
              Purchase_Order__c PO = [select id,Name from Purchase_Order__c where id =: POId];
 
              eli.PO__c = PO.Name;
            
              eli.PO_Created__c = true;
      
              update eli;           */
              
          
                   
       //Get ELI ID’s for this trigger
       Set<id> idELI = new Set<id>();
       Set<id> idPELI = new Set<id>(); 
     
       Set<id> idPOLI = new Set<id>();
       for (PO_Line_Item__c POLI : trigger.new)
        {
         if(ShowProductionEstimate ){
         idPELI.add(POLI.Production_Estimate__c);
         }
         else{
         idELI.add(POLI.Estimate_Line_Item__c);}
         
         idPOLI.add(POLI.id);
        }
        
        //List and Map of PELIs to update the PO Value and PO Created Status of if needed
        Production_Estimate__c[] ListPELI = [Select ID, Name,PO__c,PO_Created__c From Production_Estimate__c WHERE ID IN :idPELI WITH SECURITY_ENFORCED]; 
        
        
        
        //List and Map of ELIs to update the PO Value and PO Created Status of if needed
        Estimate_Line_Items__c[] ListELI = [Select ID, Name,PO__c,PO_Created__c From Estimate_Line_Items__c WHERE ID IN :idELI WITH SECURITY_ENFORCED]; 
        
        //List and Map of POLIs to update the PO Value and PO Created Status of if needed
        PO_Line_Item__c[] LISTPOLI = [Select ID,Name,Purchase_Order__c,Purchase_Order__r.Name from PO_Line_Item__c where ID IN :idPOLI WITH SECURITY_ENFORCED];
         
        Map<id, Estimate_Line_Items__c> mapOfELI = New Map<id, Estimate_Line_Items__c>();
             
       //Build map of ELI’s from the list of ELI IDs in the trigger
       For(Estimate_Line_Items__c a : ListELI)
        {
         mapOfELI.put(a.id,a);
        }
        
        Map<id, Production_Estimate__c> mapOfPELI = New Map<id, Production_Estimate__c>();
             
       //Build map of ELI’s from the list of ELI IDs in the trigger
       For(Production_Estimate__c a : ListPELI)
        {
         mapOfPELI.put(a.id,a);
        }
        
        
     
       Set<Id> POid=new Set<Id>(); 
      
       For(PO_Line_Item__c NewPOLI : trigger.new)
        {   
           POid.add(NewPOLI.Purchase_Order__c);
          
       }
  
      Map<Id,String> mp=new Map<Id,String>();
      for( PO_Line_Item__c c:LISTPOLI)
      {
       mp.put(c.Id, c.Purchase_Order__r.Name);
      }
             
      //For each record in the Is After 
      For(PO_Line_Item__c NewPOLI1 : trigger.new)
      {
       if(ShowProductionEstimate ){
        // update PO Created Checkbox and PO Text field on PELI
        
        Production_Estimate__c thisPELI = mapOfPELI.get(NewPOLI1.Production_Estimate__c);
           if(Schema.sObjectType.Production_Estimate__c.fields.PO__c.isUpdateable()){thisPELI.PO__c = mp.get(NewPOLI1.Id);}
           if(Schema.sObjectType.Production_Estimate__c.fields.PO_Created__c.isUpdateable()){thisPELI.PO_Created__c = true;}}
       
       else{
        // update PO Created Checkbox and PO Text field on ELI
        
        Estimate_Line_Items__c thisELI = mapOfELI.get(NewPOLI1.Estimate_Line_Item__c);
        if(thisELI != null){
            if(Schema.sObjectType.Estimate_Line_Items__c.fields.PO__c.isUpdateable()){thisELI.PO__c = mp.get(NewPOLI1.Id);}
            if(Schema.sObjectType.Estimate_Line_Items__c.fields.PO_Created__c.isUpdateable()){ thisELI.PO_Created__c = true;}
        }
        }
        
       }
        if(Schema.sObjectType.Production_Estimate__c.isUpdateable()){
            Update mapOfPELI.values();}
        if(Schema.sObjectType.Estimate_Line_Items__c.isUpdateable()){
            Update mapOfELI.values();}
              
   } 
  
  
  
  
 //  When any POLI is Deleted its associated ELI will be updated (its PO created field and PO # filed).
  
 If(Trigger.isAfter && Trigger.isDelete)
   {
         /*   String ELIId;
            List<Estimate_Line_Items__c> updateELI=new List<Estimate_Line_Items__c>();
            for(PO_Line_Item__c POLI:Trigger.old)
              {
                ELIId=POLI.Estimate_Line_Item__c;
                for(Estimate_Line_Items__c eli : [Select id,Name,PO__c,PO_Created__c from Estimate_Line_Items__c where id=: ELIId])
                  {
                  eli.PO__c = null;
                  eli.PO_Created__c = false;
                  updateELI.add(eli);
                  }
              }
             update updateELI;  
         */
         
         
     //Get ELI ID’s for this trigger
     Set<id> idELI = new Set<id>();
     Set<id> idPELI = new Set<id>();
     
     for (PO_Line_Item__c POLI : trigger.old)
        {
         if(ShowProductionEstimate ){
         idPELI.add(POLI.Production_Estimate__c);
         }
         else{
         idELI.add(POLI.Estimate_Line_Item__c);}
        }
        
     //List and Map of ELIs to update the PO Value and PO Created Status of if needed
     Estimate_Line_Items__c[] ListELI = [Select ID, Name,PO__c,PO_Created__c From Estimate_Line_Items__c WHERE ID IN :idELI WITH SECURITY_ENFORCED];  
     
     Map<id, Estimate_Line_Items__c> mapOfELI = New Map<id, Estimate_Line_Items__c>();
             
     //Build map of ELI’s from the list of ELI IDs in the trigger
     For(Estimate_Line_Items__c a : ListELI)
      {
       mapOfELI.put(a.id,a);
      }
      
      //List and Map of PELIs to update the PO Value and PO Created Status of if needed
     Production_Estimate__c[] ListPELI = [Select ID, Name,PO__c,PO_Created__c From Production_Estimate__c WHERE ID IN :idPELI WITH SECURITY_ENFORCED];  
     
     Map<id, Production_Estimate__c> mapOfPELI = New Map<id, Production_Estimate__c>();
             
     //Build map of PELI’s from the list of ELI IDs in the trigger
     For(Production_Estimate__c a : ListPELI)
      {
       mapOfPELI.put(a.id,a);
      }
      
      
      
        
     Set<Id> POid=new Set<Id>();
   
     For(PO_Line_Item__c NewPOLI : trigger.old)
       {
       POid.add(NewPOLI.Purchase_Order__c);
       }
        
    //For each record in the Is After
    // thisELI = new Estimate_Line_Items__c(); 
    For(PO_Line_Item__c NewPOLI1 : trigger.old)
       {
       if(ShowProductionEstimate ){
       // update PO Created Checkbox and PO Text field on PELI
        Production_Estimate__c thisPELI = mapOfPELI.get(NewPOLI1.Production_Estimate__c);
           if(Schema.sObjectType.Production_Estimate__c.fields.PO__c.isUpdateable()){thisPELI.PO__c = null;}
           if(Schema.sObjectType.Production_Estimate__c.fields.PO_Created__c.isUpdateable()){thisPELI.PO_Created__c = false;}
       
       }else{
           // update PO Created Checkbox and PO Text field on ELI
           Estimate_Line_Items__c thisELI = mapOfELI.get(NewPOLI1.Estimate_Line_Item__c);
           if(Schema.sObjectType.Estimate_Line_Items__c.fields.PO__c.isUpdateable()){thisELI.PO__c = null;}
           if(Schema.sObjectType.Estimate_Line_Items__c.fields.PO_Created__c.isUpdateable()){thisELI.PO_Created__c = false;}
           
       }
       }
       if(Schema.sObjectType.Production_Estimate__c.isUpdateable()){ Update mapOfPELI.values();}
       if(Schema.sObjectType.Estimate_Line_Items__c.isUpdateable()){ Update mapOfELI.values();}
  }
  
}        
//End of Trigger
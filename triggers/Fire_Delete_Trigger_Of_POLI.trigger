//This Trigger is used for cascade delete functionality (Once any PO is created then after delete its childs trigger should fire)
trigger Fire_Delete_Trigger_Of_POLI on Purchase_Order__c (before insert,before update,after insert,after update,before delete,after delete) 
{
   If(Trigger.isDelete && Trigger.isBefore)
   {
             
     // create a set of all the unique PurchaseOrderID
     Set<id> POIds = new Set<id>();
     List<PO_Line_Item__c> lstPOLI = new List<PO_Line_Item__c>();
     for (Purchase_Order__c a : Trigger.Old)
     {
        POIds.add(a.id); 
     }
       
     lstPOLI = [Select id,Purchase_Order__c from PO_Line_Item__c Where Purchase_Order__c in :POIds WITH SECURITY_ENFORCED];
     if(lstPOLI.Size() > 0)
      {
       if(Schema.sObjectType.PO_Line_Item__c.isDeletable()){
           delete lstPOLI;  }
      }
        
   }

//Trigger to check Duplicate PO # and to auto populate the PO #
   If((Trigger.isBefore && Trigger.isInsert) || (Trigger.isBefore && Trigger.isUpdate))
    {
       If((Trigger.isBefore && Trigger.isInsert))
        { 
          List<Purchase_Order__c> lstForNumber=[Select Id, Name from Purchase_Order__c WITH SECURITY_ENFORCED ORDER BY CreatedDate DESC LIMIT 1 ];
         
          String autoFormat,previousPONumber,appendZero,str;
          Integer incre;
          
              if(lstForNumber.size()==0)
              {
                  incre=0;
                  previousPONumber='1';
                  autoFormat='';
              }
              
              else
              {
                  previousPONumber=String.valueOf(lstForNumber[0].Name);
                  incre=Integer.valueOf(previousPONumber);
              }
         
             for(Purchase_Order__c PO: Trigger.New)
             {
                 if(PO.flag__c==False)
                 {
                   autoFormat='';
                   incre++;
                   
                   str=String.ValueOf(incre);
                   if(str.length() == 1)
                    {
                       appendZero = '00000';
                    }
                   else if(str.length() == 2)
                    {
                       appendZero = '0000';
                    }
                   else if(str.length() == 3)
                    {
                       appendZero = '000';
                    }
                   else if(str.length() == 4)
                    {
                       appendZero = '00';
                    }
                   else if(str.length() == 5)
                    {
                       appendZero = '0';
                    }
                   
                   PO.Name = autoFormat+appendZero+incre;  
                 
                 }
             }
          }   
             //To Check Duplicate
             
             Map<String,Purchase_Order__c> POMap = new Map<String,Purchase_Order__c>();
      
             for (Purchase_Order__c PO : System.Trigger.new) 
               {
                  If ((PO.Name != null) && (System.Trigger.isInsert || (PO.Name != System.Trigger.oldMap.get(PO.Id).Name))) 
                   {
           
                   // Make sure another new PO # isn't also a duplicate 
                   If(POMap.containsKey(PO.Name)) 
                    {
                    PO.Name.addError('Another PO has the '+'same PO#.');
                    } 
                   
                   Else
                    {
                    POMap.put(PO.Name,PO);
                    }
                   
                   }  
               }
      
             for (Purchase_Order__c PO1 : [SELECT Name FROM Purchase_Order__c WHERE Name IN :POMap.KeySet() WITH SECURITY_ENFORCED]) 
               {
                  Purchase_Order__c purchaseorder = POMap.get(PO1.Name);
                  purchaseorder.Name.addError('A PO# with Name '+purchaseorder.Name+' already exists.');
               }
    }  
  
}
//End of Trigger
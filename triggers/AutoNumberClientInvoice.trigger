trigger AutoNumberClientInvoice on Client_Invoice__c (before insert,before update) {


//Trigger to check Duplicate Invoice # and to auto populate the Invoice #
   If((Trigger.isBefore && Trigger.isInsert) || (Trigger.isBefore && Trigger.isUpdate))
    {
       If((Trigger.isBefore && Trigger.isInsert))
        { 
          List<Client_Invoice__c> lstForNumber=[Select Id, Name from Client_Invoice__c WITH SECURITY_ENFORCED ORDER BY CreatedDate DESC LIMIT 1];
         
          String autoFormat,previousCINumber,appendZero,str;
          Integer incre;
          
              if(lstForNumber.size()==0)
              {
                  incre=0;
                  previousCINumber='1';
                  autoFormat='';
              }
              
              else
              {
                  previousCINumber=String.valueOf(lstForNumber[0].Name);
                  incre=Integer.valueOf(previousCINumber);
              }
         
             for(Client_Invoice__c CI: Trigger.New)
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
                   if(Schema.sObjectType.Client_Invoice__c.fields.Name.isUpdateable()){
                        CI.Name = autoFormat+appendZero+incre; } 
                 
                
             }
          }   
             //To Check Duplicate
             
             Map<String,Client_Invoice__c> CIMap = new Map<String,Client_Invoice__c>();
      
             for (Client_Invoice__c CI : System.Trigger.new) 
               {
                  If ((CI.Name != null) && (System.Trigger.isInsert || (CI.Name != System.Trigger.oldMap.get(CI.Id).Name))) 
                   {
           
                   // Make sure another new PO # isn't also a duplicate 
                   If(CIMap.containsKey(CI.Name)) 
                    {
                    CI.Name.addError('Another client invoice has the '+'same Invoice#.');
                    } 
                   
                   Else
                    {
                    CIMap.put(CI.Name,CI);
                    }
                   
                   }  
               }
      
             for (Client_Invoice__c CI1 : [SELECT Name FROM Client_Invoice__c WHERE Name IN :CIMap.KeySet() WITH SECURITY_ENFORCED]) 
               {
                  Client_Invoice__c Clientinvoice = CIMap.get(CI1.Name);
                  Clientinvoice.Name.addError('A Invoice# with Name '+Clientinvoice .Name+' already exists.');
               }
    }  
  
}
//End of Trigger
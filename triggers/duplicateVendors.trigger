/* This trigger is used to avoid duplicate Vendors */
trigger duplicateVendors on Vendor__c (before insert,before update,after insert,after update,before delete,after delete) 
{
  If((Trigger.isInsert && Trigger.isBefore) || (Trigger.isUpdate && Trigger.isBefore))
     {
     Map<String,Vendor__c> VMap = new Map<String,Vendor__c>();
     for (Vendor__c ven : System.Trigger.new) 
      {
        
        /* Make sure we don't treat an Name that isn't changing during an update as a duplicate. */  
    
        if ((ven.Name != null) && (System.Trigger.isInsert || (ven.Name != System.Trigger.oldMap.get(ven.Id).Name))) 
        {
        
            // Make sure another new Vendor isn't also a duplicate  
    
            if (VMap.containsKey(ven.Name)) 
            {
                ven.Name.addError('Another new Vendor has the '+'same Name.');
            } 
            else 
            {
                VMap.put(ven.Name,ven);
            }
        }
     }
    
    /* Using a single database query, find all the Vendors in the database that have the same Name as any of the Vendor being inserted or updated. */ 
    
    for(Vendor__c NewV:Trigger.New)
        {
         for (Vendor__c v : [SELECT Name FROM Vendor__c WHERE Name IN :VMap.KeySet() WITH SECURITY_ENFORCED]) 
          {
            if(NewV.Name == v.Name)
            NewV.Name.addError('A Vendor with Name '+v.Name+' already exists.');
          }
        }
    }
    
    
    SET<Id> ELI_Ids = new SET<Id> (); 
    SET<Id> PO_Ids = new SET<Id> ();
    SET<Id> Vendor_Quote_Ids = new SET<Id> ();
    SET<Id> INV_Ids = new SET<Id> ();
    
    If(Trigger.isDelete && Trigger.isBefore)
    {
         List<Id> Quoteids = new List<Id>();
         Vendor_Quote_Ids = trigger.oldMap.keyset(); 
           
         //check Vendor Quote association
         for(Vendor_Quote__c vq: [SELECT Id,Name,Vendor__c FROM Vendor_Quote__c WHERE Vendor__c IN :Vendor_Quote_Ids WITH SECURITY_ENFORCED])
          {        
               Quoteids.add(vq.Vendor__c);
          
               // get the object from the Trigger Context
               Vendor__c errorObj = Trigger.oldMap.get(vq.vendor__c);
        
               If(errorObj != null)
               {
                    // add an error to the object which will prevent this object from being deleted
                    errorObj.addError('You cannot delete "'+errorObj.Name+'".Because it is associated with,');
                    for(Vendor_Quote__c quote: [SELECT Id,Name,Vendor__c,Quote__r.Name FROM Vendor_Quote__c WHERE Vendor__c =: errorObj.id WITH SECURITY_ENFORCED])
                    {
                          errorObj.addError('Quote "'+Quote.quote__r.Name+'".');
                    }
               } 
               Else 
               {
                   System.debug('Somehow, Trigger.oldMap does not contain a Vendor that is assigned to Quote, even though that Vendor ID is in the Trigger.oldMap keyset');
                   System.debug('-- Trigger.oldMap: ' + Trigger.oldMap);
                   System.debug('-- Vendor Quote: ' + vq);
               }
          }
         
         //Remove STIDs from delete list that has Vendor association
         Vendor_Quote_Ids.removeAll(Quoteids);  
        
         
         List<Id> ELIids = new List<Id>();
         ELI_Ids = trigger.oldMap.keyset(); 
           
         //check Estimate Line Item associated
         for(Estimate_Line_Items__c e: [SELECT Id,Name,Vendor__c FROM Estimate_Line_Items__c WHERE Vendor__c IN : ELI_Ids WITH SECURITY_ENFORCED])
         {        
            ELIids.add(e.Vendor__c);
          
           // get the object from the Trigger Context
           Vendor__c errorObj = Trigger.oldMap.get(e.Vendor__c);
        
          If(errorObj != null)
          {
                // add an error to the object which will prevent this object from being deleted
                errorObj.addError('You cannot delete "'+errorObj.Name+'".Because it is associated with,');
    
                for(Estimate_Line_Items__c eli: [SELECT Id,Name,Vendor__c,Job__c,Job__r.Name FROM Estimate_Line_Items__c WHERE Vendor__c =: errorObj.id WITH SECURITY_ENFORCED])
                {
                   errorObj.addError('Estimate Line Item "'+eli.Name+'".');
                }
          } 
          Else 
          {
               System.debug('Somehow, Trigger.oldMap does not contain a Vendor that is linked to ELI, even though that Vendor ID is in the Trigger.oldMap keyset');
               System.debug('-- Trigger.oldMap: ' + Trigger.oldMap);
               System.debug('-- ELI: ' + e);
          }
        }
        
        //Remove ELIiDs from delete list that has Vendor association
        ELI_Ids.removeAll(ELIids);  
      
        List<Id> POids = new List<Id>();
        PO_Ids = trigger.oldMap.keyset(); 
           
        //check Purchase Order associated
        for(Purchase_Order__c p: [SELECT Id,Name,Vendor__c FROM Purchase_Order__c WHERE Vendor__c IN :PO_Ids WITH SECURITY_ENFORCED])
        {        
              POids.add(p.Vendor__c);
    
              // get the object from the Trigger Context
              Vendor__c errorObj = Trigger.oldMap.get(p.Vendor__c);
        
              If(errorObj != null)
              {
                   // add an error to the object which will prevent this object from being deleted
                    errorObj.addError('You cannot delete "'+errorObj.Name+'".Because it is associated with,');
                    for(Purchase_Order__c po: [SELECT Id,Name,Vendor__c,Job__c,Job__r.Name FROM Purchase_Order__c WHERE Vendor__c =: errorObj.id WITH SECURITY_ENFORCED])
                    {
                           errorObj.addError('Purchase Order "'+po.Name+'".');
                    }
             } 
             Else 
             {
                System.debug('Somehow, Trigger.oldMap does not contain a Vendor that is linked to PO, even though that Vendor ID is in the Trigger.oldMap keyset');
                System.debug('-- Trigger.oldMap: ' + Trigger.oldMap);
                System.debug('-- PO: ' + p);
             }
       }
       //Remove POIDs from delete list that has Vendor association
        PO_Ids.removeAll(POids);  
         
       
        List<Id> INVids = new List<Id>();
        INV_Ids = trigger.oldMap.keyset(); 
           
        //check Purchase Order associated
        for(Invoice__c i: [SELECT Id,Name,Vendor__c FROM Invoice__c WHERE Vendor__c IN :INV_Ids WITH SECURITY_ENFORCED])
        {        
              INVids.add(i.Vendor__c);
    
              // get the object from the Trigger Context
              Vendor__c errorObj = Trigger.oldMap.get(i.Vendor__c);
        
              If(errorObj != null)
              {
                   // add an error to the object which will prevent this object from being deleted
                    errorObj.addError('You cannot delete "'+errorObj.Name+'".Because it is associated with,');
                    for(Invoice__c inv: [SELECT Id,Name,Vendor__c FROM Invoice__c WHERE Vendor__c =: errorObj.id WITH SECURITY_ENFORCED])
                    {
                           errorObj.addError('Invoice "'+inv.Name+'".');
                    }
             } 
             Else 
             {
                System.debug('Somehow, Trigger.oldMap does not contain a Vendor that is linked to Invoice, even though that VendorID is in the Trigger.oldMap keyset');
                System.debug('-- Trigger.oldMap: ' + Trigger.oldMap);
                System.debug('-- Invoice: ' + i);
             }
       }
       //Remove POIDs from delete list that has Vendor association
        INV_Ids.removeAll(INVids);  
        
           
    }// End of checking for GLCode associated entry in PO's, Quote
    
    
          
}
//End of Trigger.
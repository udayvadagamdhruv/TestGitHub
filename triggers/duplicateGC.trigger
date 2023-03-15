// This trigger is used to check duplicate GLCode and also avoid its deletion if it is associated with any PO's or Quote,Estimate Line Item or Vendor GL Code
trigger duplicateGC on GL_Code__c (before insert,before update,after insert,after update,before delete,after delete)
{
    // Check fo Duplicate GLCode
    If((Trigger.isInsert && Trigger.isBefore) || (Trigger.isUpdate && Trigger.isBefore))
    {
           Map<String,GL_Code__c> GLCMap = new Map<String,GL_Code__c>();
           for (GL_Code__c GL : System.Trigger.new) 
          {
               If ((GL.Name != null) && (System.Trigger.isInsert || (GL.Name != System.Trigger.oldMap.get(GL.Id).Name))) 
              {
           
                  // Make sure another new lead isn't also a duplicate 
           
                  If (GLCMap.containsKey(GL.Name)) 
                  {
                      GL.Name.addError('Another GL has the '+'same Description.');
                  } 
                  Else
                  {
                      GLCMap.put(GL.Name,GL);
                  }
             }  
          }

          for(GL_Code__c NewGLC:Trigger.New)
          {
              for (GL_Code__c gl1 : [SELECT Name FROM GL_Code__c WHERE Name IN :GLCMap.KeySet() WITH SECURITY_ENFORCED]) 
              {
                   If(NewGLC.Name == gl1.Name)
                   NewGLC.Name.addError('A GL Code with Name '+gl1.Name+' already exists.');
              }
          }
     }// End of checking for Duplicates

    // GL Code will not be deleted if any Quote,Purchase Order is associated with this
    SET<Id> GLC_ELI_Ids = new SET<Id> (); 
    SET<Id> GLC_PO_Ids = new SET<Id> ();
    SET<Id> GLC_Quote_Ids = new SET<Id> ();
    
    If(Trigger.isDelete && Trigger.isBefore)
    {
         List<Id> Quoteids = new List<Id>();
         GLC_Quote_Ids = trigger.oldMap.keyset(); 
           
         //check Estimate Line Item associated
         for(Quote__c a: [SELECT Id,Name,GL_Code__c FROM Quote__c WHERE GL_Code__c IN :GLC_Quote_Ids WITH SECURITY_ENFORCED])
          {        
               Quoteids.add(a.GL_Code__c);
          
               // get the object from the Trigger Context
               GL_Code__c errorObj = Trigger.oldMap.get(a.GL_Code__c);
        
               If(errorObj != null)
               {
                    // add an error to the object which will prevent this object from being deleted
                    errorObj.addError('You cannot delete "'+errorObj.Name+'".Because,');
                    for(Quote__c quote: [SELECT Id,Name,GL_Code__c,Job__c,Job__r.Name FROM Quote__c WHERE GL_Code__c =: errorObj.id WITH SECURITY_ENFORCED])
                    {
                          errorObj.addError('Quote "'+Quote.Name+'" for Job "'+quote.job__r.Name+'" is associated.');
                    }
               } 
               Else 
               {
                   System.debug('Somehow, Trigger.oldMap does not contain a GLCode that is linked to Quote, even though that GL Code ID is in the Trigger.oldMap keyset');
                   System.debug('-- Trigger.oldMap: ' + Trigger.oldMap);
                   System.debug('-- Quote: ' + a);
               }
          }
         
         //Remove STIDs from delete list that has Job association
         GLC_Quote_Ids.removeAll(Quoteids);  
         
         List<Id> ELIids = new List<Id>();
         GLC_ELI_Ids = trigger.oldMap.keyset(); 
           
         //check Estimate Line Item associated
         for(Estimate_Line_Items__c a: [SELECT Id,Name,GL_Code__c FROM Estimate_Line_Items__c WHERE GL_Code__c IN :GLC_ELI_Ids WITH SECURITY_ENFORCED])
         {        
            ELIids.add(a.GL_Code__c);
          
           // get the object from the Trigger Context
           GL_Code__c errorObj = Trigger.oldMap.get(a.GL_Code__c);
        
          If(errorObj != null)
          {
                // add an error to the object which will prevent this object from being deleted
                errorObj.addError('You cannot delete "'+errorObj.Name+'".Because,');
    
                for(Estimate_Line_Items__c eli: [SELECT Id,Name,GL_Code__c,Job__c,Job__r.Name FROM Estimate_Line_Items__c WHERE GL_Code__c =: errorObj.id WITH SECURITY_ENFORCED])
                {
                   errorObj.addError('Estimate Line Item "'+eli.Name+'" for Job "'+eli.job__r.Name+'"is associated.');
                }
          } 
          Else 
          {
               System.debug('Somehow, Trigger.oldMap does not contain a GLCode that is linked to ELI, even though that GL Code ID is in the Trigger.oldMap keyset');
               System.debug('-- Trigger.oldMap: ' + Trigger.oldMap);
               System.debug('-- ELI: ' + a);
          }
        }
        
        //Remove ELIiDs from delete list that has Job association
        GLC_ELI_Ids.removeAll(ELIids);  
        
        List<Id> POids = new List<Id>();
        GLC_PO_Ids = trigger.oldMap.keyset(); 
           
        //check Purchase Order associated
        for(Purchase_Order__c a: [SELECT Id,Name,GL_Code__c FROM Purchase_Order__c WHERE GL_Code__c IN :GLC_PO_Ids WITH SECURITY_ENFORCED])
        {        
              POids.add(a.GL_Code__c);
    
              // get the object from the Trigger Context
              GL_Code__c errorObj = Trigger.oldMap.get(a.GL_Code__c);
        
              If(errorObj != null)
              {
                   // add an error to the object which will prevent this object from being deleted
                    errorObj.addError('You cannot delete "'+errorObj.Name+'".Because,');
                    for(Purchase_Order__c po: [SELECT Id,Name,GL_Code__c,Job__c,Job__r.Name FROM Purchase_Order__c WHERE GL_Code__c =: errorObj.id WITH SECURITY_ENFORCED])
                    {
                           errorObj.addError('Purchase Order "'+po.Name+'"for Job "'+po.job__r.Name+'" is associated.');
                    }
             } 
             Else 
             {
                System.debug('Somehow, Trigger.oldMap does not contain a GLCode that is linked to PO, even though that GL Code ID is in the Trigger.oldMap keyset');
                System.debug('-- Trigger.oldMap: ' + Trigger.oldMap);
                System.debug('-- PO: ' + a);
             }
       }
       //Remove POIDs from delete list that has Job association
        GLC_PO_Ids.removeAll(POids);     
    }// End of checking for GLCode associated entry in PO's, Quote
    
    // This trigger event is executes after GLCode deletion.
    // It deletes associated entry from Vendor GLCode
    If(Trigger.isDelete && Trigger.isBefore)
    {
          List<Vendor_GL_Code__c> lstVGC = new List<Vendor_GL_Code__c>();    
          for (GL_Code__c GL : System.Trigger.Old) 
          {
               for(Vendor_GL_Code__c vgc : [select id,Name,GL_Code__c,GL_Code__r.Name from Vendor_GL_Code__c where GL_Code__c =: GL.id WITH SECURITY_ENFORCED])
               {
                   
                    lstVGC.add(vgc);
               }
          }
          if(Vendor_GL_Code__c.sObjectType.getDescribe().isDeletable()){
              delete lstVGC; } 
    }// End of checking for Vendor GL Code              
    
}// End of Trigger
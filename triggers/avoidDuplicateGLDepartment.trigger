// This trigger is used to avoid duplicate GL Department and GLDepartment should not be deleted if it is associated with any GLCode
trigger avoidDuplicateGLDepartment on GL_Department__c (before insert,before update,before delete,after delete,after insert,after update)
{
    // To check for Duplicate GLDepartment
    if((Trigger.isInsert && Trigger.isBefore) || (Trigger.isUpdate && Trigger.isBefore))
    {
          Map<String,GL_Department__c> GLDMap = new Map<String,GL_Department__c>();
          for (GL_Department__c GLD : System.Trigger.new) 
         {
        
            // Make sure we don't treat a Name that isn't changing during an update as a duplicate
    
            if ((GLD.Name != null) && (System.Trigger.isInsert || (GLD.Name != System.Trigger.oldMap.get(GLD.Id).Name))) 
            {
        
                // Make sure another new GL Department isn't also a duplicate  
    
                if (GLDMap.containsKey(GLD.Name)) 
                {
                    GLD.Name.addError('Another new GL Department has the '+'same Name.');
                } 
                else 
                {
                    GLDMap.put(GLD.Name,GLD);
                }
           }
        }
    
        // Using a single database query, find all the GL Departments in the database that have the same Name as any of the GL Department being inserted or updated.
    
        for(GL_Department__c NewGLD:Trigger.New)
        {
             for (GL_Department__c GLD : [SELECT Name FROM GL_Department__c WHERE Name IN :GLDMap.KeySet() WITH SECURITY_ENFORCED]) 
             {
                if(NewGLD.Name == GLD.Name)
                        NewGLD.Name.addError('A GL Department with Name '+GLD.Name+' already exists.');
             }
        }
    }// End for checking duplicate GLDepartments

    //  If Any GLDepartment is associated with GLCode then it should not be deleted */
    Set<Id> GLDIds = new Set<Id> (); 
    If(Trigger.isDelete && Trigger.isBefore)
    {
          List<Id> GLCids = new List<Id>();
          GLDIds = trigger.oldMap.keyset(); 
           
          //check GL Codes associated
          for(GL_Code__c a: [SELECT Id,Name,GL_Department__c FROM GL_Code__c WHERE GL_Department__c IN :GLDIds WITH SECURITY_ENFORCED])
           {        
                  GLCids.add(a.GL_Department__c);
        
                // get the object from the Trigger Context
                GL_Department__c errorObj = Trigger.oldMap.get(a.GL_Department__c);
        
                if(errorObj != null)
                {
                    // add an error to the object which will prevent this object from being deleted
                    errorObj.addError('You can not delete "'+errorObj.Name+'" deparment.because,');
            
                    for(GL_Code__c gc:[SELECT Id,Name,GL_Department__c FROM GL_Code__c WHERE GL_Department__c =: errorObj.id WITH SECURITY_ENFORCED])
                    {
                        errorObj.adderror('GL Code "'+gc.Name+'" is associated.');
                    }
                } 
                else 
               {
                    System.debug('Somehow, Trigger.oldMap does not contain a GLDepartment that is linked to an Account, even though that GLDepartments ID is in the Trigger.oldMap keyset');
                    System.debug('-- Trigger.oldMap: ' + Trigger.oldMap);
                    System.debug('-- GL Code: ' + a);
               }
           }

           //Remove GLDeptIDs from delete list that has Account association
           GLDIds.removeAll(GLCids);             
       }        
}
// End of trigger
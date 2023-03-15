trigger staffDuplicatePreventer on Staff__c
                               (before insert, before update,after Update) {
                               
   If(Trigger.IsBefore){
    
    Map<String, Staff__c> staffMap = new Map<String, Staff__c>();
    for (Staff__c objStaff : System.Trigger.new) {
        
        // Make sure we don't treat an username address that  
    
        // isn't changing during an update as a duplicate.  
    
        if ((objStaff.Username__c != null) &&
                (System.Trigger.isInsert ||
                (objStaff.Username__c != 
                    System.Trigger.oldMap.get(objStaff.Id).Username__c))) {
        
            // Make sure another new Staff isn't also a duplicate  
    
            if (staffMap.containsKey(objStaff.Username__c)) {
                objStaff.Username__c.addError('Another new Staff has the '
                                    + 'same Username.');
            } else {
                staffMap.put(objStaff.Username__c, objStaff);
            }
       }
    }
    
    // Using a single database query, find all the staffs in  
    
    // the database that have the same email address as any  
    
    // of the staffs being inserted or updated.  
    
    for (Staff__c st : [SELECT Username__c FROM Staff__c
                      WHERE Username__c IN :staffMap.KeySet() and IsDeleted__c = false WITH SECURITY_ENFORCED]) {
        Staff__c s = staffMap.get(st.Username__c);
        s.Username__c.addError('A staff with this username '
                               + 'already exists.');
    }
    
    
    
    }                

    
    String OldStaffname;
    String NewStaffname;
    
    If(Trigger.IsAfter && Trigger.IsUpdate){
    
       for(Staff__c  st : System.Trigger.new)
        {
           If ((st.Name!= null) && (st.Name!= System.Trigger.oldMap.get(st.Id).Name))
            {
             
             OldStaffname=System.Trigger.oldMap.get(st.Id).Name;
             NewStaffname=st.Name;
             
             system.debug('<!----  Compare New & Old name ----------!> '+OldStaffname+'------'+NewStaffname); 
            
             StaffNameUpdateforJobTeamTask.updateStaffname(OldStaffname, NewStaffname);
            }
        
        } 
        
        
    
    
    }
    
    
    
    
    
}
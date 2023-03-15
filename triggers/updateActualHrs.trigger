trigger updateActualHrs on Time_Sheet__c (after insert, after update, after delete) {
    
    set<id> idTs = new set<id>();
    set<id> idDevItm = new set<id>();
    
    list<Development_Item__c> lstDevItm = new list<Development_Item__c>();
    list<Development_Item__c> lstDevItmUpdt2 = new list<Development_Item__c>();
    list<Development_Item__c> lstDevItmUpdt = new list<Development_Item__c>();
    
    list<Time_Sheet__c> lstTs = new list<Time_Sheet__c>();
    list<Time_Sheet__c> lstTsOld = new list<Time_Sheet__c>();
    
    //Update on Creation of TS data starts    
    if(Trigger.IsInsert){
        for(Time_Sheet__c ts : trigger.new){
            lstTs.add(ts);
            idDevItm.add(ts.Dev_Item__c);
        }
        
        lstDevItm = [SELECT id,name,Actual_Hrs__c,Duration__c FROM Development_Item__c WHERE id IN: idDevItm WITH SECURITY_ENFORCED];
        
        for(Time_Sheet__c ts1 : lstTs){
            for(Development_Item__c DevItm1 : lstDevItm){
                if(ts1.Dev_Item__c == DevItm1.id ){
                    
                    if(DevItm1.Actual_Hrs__c == null ){
                        if(Schema.sObjectType.Development_Item__c.fields.Actual_Hrs__c.isUpdateable()){
                            DevItm1.Actual_Hrs__c = ts1.Hours__c;
                        }
                    }
                    else if(DevItm1.Actual_Hrs__c != null) {
                        if(Schema.sObjectType.Development_Item__c.fields.Actual_Hrs__c.isUpdateable()){
                            DevItm1.Actual_Hrs__c = DevItm1.Actual_Hrs__c + ts1.Hours__c;
                        }
                    }
                    
                    if(DevItm1.Duration__c == null){   
                        if(Schema.sObjectType.Development_Item__c.fields.Duration__c.isUpdateable()){
                            DevItm1.Duration__c = ts1.Duration__c;
                        }
                    }
                    else if(DevItm1.Duration__c != null){    
                        if(Schema.sObjectType.Development_Item__c.fields.Duration__c.isUpdateable()){
                            DevItm1.Duration__c = DevItm1.Duration__c + ts1.Duration__c;
                        }
                    }
                    
                    lstDevItmUpdt.add(DevItm1);
                }
            }
        }
        if(Schema.sObjectType.Development_Item__c.isUpdateable()){
            update lstDevItmUpdt;
        }
    }
    //Update on Creation of TS data ends.    
    
    //update on deletion of TS data starts.
    if(Trigger.IsDelete){
        for(Time_Sheet__c ts : trigger.old){
            lstTs.add(ts);
            idDevItm.add(ts.Dev_Item__c);
        }
        
        lstDevItm = [SELECT id,name,Actual_Hrs__c,Duration__c FROM Development_Item__c WHERE id IN: idDevItm WITH SECURITY_ENFORCED];
        
        for(Time_Sheet__c ts1 : lstTs){
            for(Development_Item__c DevItm1 : lstDevItm){
                if(ts1.Dev_Item__c == DevItm1.id){
                    if(Schema.sObjectType.Development_Item__c.fields.Actual_Hrs__c.isUpdateable()){
                        DevItm1.Actual_Hrs__c = DevItm1.Actual_Hrs__c - ts1.Hours__c;
                    }
                    if(Schema.sObjectType.Development_Item__c.fields.Duration__c.isUpdateable()){
                        DevItm1.Duration__c = DevItm1.Duration__c - ts1.Duration__c;
                    }
                    
                    lstDevItmUpdt.add(DevItm1);
                }
            }
        }
        if(Schema.sObjectType.Development_Item__c.isUpdateable()){
            update lstDevItmUpdt;
        }
    }
    
    //update on deletion of TS data ends.
    
    //update on editing of TS data starts.
    if(Trigger.IsUpdate){
        
        for(Time_Sheet__c ts : trigger.new){
            Time_Sheet__c oldTS = System.Trigger.oldMap.get(ts.id);
            
            if(ts.Hours__c != oldTS.Hours__c || ts.Duration__c != oldTS.Duration__c){
                lstTs.add(ts);
                lstTsOld.add(oldTS);
                idDevItm.add(ts.Dev_Item__c);
            }
            
        }
        
        lstDevItm = [SELECT id,name,Actual_Hrs__c,Duration__c FROM Development_Item__c WHERE id IN: idDevItm WITH SECURITY_ENFORCED];
        
        for(Time_Sheet__c ts1 : lstTs){
            for(Development_Item__c DevItm1 : lstDevItm){
                if(ts1.Dev_Item__c == DevItm1.id){
                    
                    if(DevItm1.Actual_Hrs__c == null ){
                        system.debug('Billable hours in TS ******************** '+ts1.Hours__c);
                        if(Schema.sObjectType.Development_Item__c.fields.Actual_Hrs__c.isUpdateable()){
                            DevItm1.Actual_Hrs__c = ts1.Hours__c;
                        }
                    }
                    else if(DevItm1.Actual_Hrs__c != null) {
                        if(Schema.sObjectType.Development_Item__c.fields.Actual_Hrs__c.isUpdateable()){
                            DevItm1.Actual_Hrs__c = DevItm1.Actual_Hrs__c + ts1.Hours__c;
                        }
                    }
                    
                    if(DevItm1.Duration__c == null){    
                        if(Schema.sObjectType.Development_Item__c.fields.Duration__c.isUpdateable()){
                            DevItm1.Duration__c = ts1.Duration__c;
                        }
                    }
                    else if(DevItm1.Duration__c != null){ 
                        if(Schema.sObjectType.Development_Item__c.fields.Duration__c.isUpdateable()){
                            DevItm1.Duration__c = DevItm1.Duration__c + ts1.Duration__c;
                        }
                    }
                    lstDevItmUpdt.add(DevItm1);
                }
            }
        }
        if(Schema.sObjectType.Development_Item__c.isUpdateable()){
            update lstDevItmUpdt;
        }
        
        for(Time_Sheet__c ts1 : lstTsOld){
            for(Development_Item__c DevItm1 : lstDevItmUpdt){
                if(ts1.Dev_Item__c == DevItm1.id){
                    
                    if(DevItm1.Actual_Hrs__c != null && ts1.Hours__c !=null) {
                        if(Schema.sObjectType.Development_Item__c.fields.Actual_Hrs__c.isUpdateable()){
                            DevItm1.Actual_Hrs__c = DevItm1.Actual_Hrs__c - ts1.Hours__c;
                        }
                    }
                    
                    if(DevItm1.Duration__c != null && ts1.Duration__c != null){ 
                        system.debug('dev value 999999999999999999999999999999 '+DevItm1.Duration__c);
                        system.debug('ts value 999999999999999999999999999999 '+ts1.Duration__c);
                        if(Schema.sObjectType.Development_Item__c.fields.Duration__c.isUpdateable()){
                            DevItm1.Duration__c = DevItm1.Duration__c - ts1.Duration__c;
                        }
                    }
                    lstDevItmUpdt2.add(DevItm1);
                }
            }
        }
        if(Schema.sObjectType.Development_Item__c.isUpdateable()){
            update lstDevItmUpdt2;
        }
    }
    //update on editing of TS data ends.
    
}
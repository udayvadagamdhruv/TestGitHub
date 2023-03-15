public with sharing class Job_Status_Notes_Mass_Update_Controller {
    
    public list<Job__c> jblist {set;get;}
    public set<Id> selcIds {set;get;}
    public string filterId {set;get;}
    public string keyPrefix;
    
    public Job_Status_Notes_Mass_Update_Controller(ApexPages.StandardSetController controller) {
        jblist=new list<Job__c>();
        selcIds =new set<Id>();
        if(!test.isRunningTest()){
            list<String> fields=new list<String>{'id','Name','Job_Auto_Number__c','Creative_Overview__c'};
                controller.AddFields(fields);
            system.debug('controller fields '+controller);
        }
        filterId=controller.getFilterId();
        system.debug('filterId is '+filterId);
        
        keyPrefix=Job__c.SObjectType.getDescribe().getKeyPrefix(); 
        system.debug('keyPrefix is '+keyPrefix);
        
        jblist=controller.getSelected();
        system.debug('jblist '+jblist);
        
        //apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+filterId));
        
        if(jblist.size()>0){
            for(Job__c jb:jblist)
            {
                selcIds.add(jb.id);
                system.debug('selcIds '+selcIds);
                
            }
        }
        
        else{
            Apexpages.Message msg=new Apexpages.Message(Apexpages.Severity.Error,'No records seleted to update the Status Notes.');
            Apexpages.addMessage(msg);
            system.debug('msg '+msg);
            
        }
        
        if(selcIds.size()>0){
            jblist=[select id,Name,Creative_Overview__c,Job_Auto_Number__c From Job__c where id IN:selcIds WITH SECURITY_ENFORCED Order by Job_Auto_Number__c DESC];
            controller.setSelected(jblist);
            system.debug('jblist '+jblist);
            
        }
        
    }
    
    
    public pagereference updateStatusNotes(){
        if(jblist.size()>0){
            try{if(Schema.sObjectType.Job__c.isUpdateable())
            {
                update jblist;
                system.debug('jblist 2 '+jblist);
                
            }
               }
            catch(System.DmlException e){apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+e.getMessage()));return null;
                                        }
        }
        pagereference p=new pagereference('/'+keyPrefix+'?fcf='+filterId);
        p.setredirect(true);
        return p;
    }
    
    
    public pagereference CancelStatusNotes(){
        pagereference p=new pagereference('/'+keyPrefix+'?fcf='+filterId);
        p.setredirect(true);
        return p;
    }
    
    
    
}
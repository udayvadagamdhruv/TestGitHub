trigger ContentDocTrigger on ContentDocument (After insert,before Delete,After UnDelete) {
   Set<Id> contentDocumentIdSet = new Set<Id>();
     Set<Id> remcontentDocumentIdSet =new Set<Id>();
    Set<Id> LinkedEntityIdIdSet =new Set<Id>();
     Map<String,Set<String>> LinkEntityDocIdMap=new Map<String,Set<String>>();
     Map<String,String> CondocContentVersionMap=new Map<String,String>();
    
    if(Trigger.isInsert){
        System.debug('======Content Doucmnet insert Fires==========='+Trigger.New);
    }
    if(Trigger.isUndelete){
        System.debug('======Content Doucmnet UnDelete Fires==========='+Trigger.new);
        for(ContentDocument cdoc:trigger.new){
            contentDocumentIdSet.add(cdoc.Id);
        }

        list<ContentDocumentLink> cdlList=[SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE ContentDocumentId IN:contentDocumentIdSet WITH SECURITY_ENFORCED];
        System.debug('===Content Document List==='+cdlList);
        for(ContentDocumentLink cdl:cdlList){
            LinkedEntityIdIdSet.add(cdl.LinkedEntityId);
        }
        
        //cdlList[0].LinkedEntityId
        list<ContentDocumentLink> remcdlList=[SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN:LinkedEntityIdIdSet and ContentDocumentId NOT IN:contentDocumentIdSet WITH SECURITY_ENFORCED];
        for(ContentDocumentLink remcdl:remcdlList){
            remcontentDocumentIdSet.add(remcdl.ContentDocumentId);
            if(!LinkEntityDocIdMap.containskey(remcdl.LinkedEntityId)){
                LinkEntityDocIdMap.put(remcdl.LinkedEntityId,new Set<String>{remcdl.ContentDocumentId});  
            }else{
                Set<String> DummySet=new Set<String>();
                DummySet=LinkEntityDocIdMap.get(remcdl.LinkedEntityId);
                DummySet.add(remcdl.ContentDocumentId);
                LinkEntityDocIdMap.put(remcdl.LinkedEntityId,DummySet);
            }
            
        }
        System.debug('======LinkEntityDocIdMap======'+LinkEntityDocIdMap);
        List<Material_Item__c> MIList = [SELECT Id, Name,Attachment_ID__c FROM Material_Item__c where Id IN:LinkedEntityIdIdSet WITH SECURITY_ENFORCED];   
        List<Billboard__c> BBList=[SELECT Id, Name,Attachment_ID__c FROM Billboard__c where Id IN:LinkedEntityIdIdSet WITH SECURITY_ENFORCED];
        List<ContentVersion> cvList = [SELECT Id,Title, ContentDocumentId FROM ContentVersion where ContentDocumentId IN:remcontentDocumentIdSet and isLatest=true and FileType!='SNOTE' WITH SECURITY_ENFORCED Order by CreatedDate DESC];
        System.debug('=======cvList====='+cvList);
        System.debug('=======MIList====='+MIList);
        System.debug('=======BBList====='+BBList);
         for(ContentVersion cv:cvList){
            if(!CondocContentVersionMap.containskey(cv.ContentDocumentId)){
                CondocContentVersionMap.put(cv.ContentDocumentId,cv.Id);
            }
        }
        
        if(MIList.size() > 0){
            for(Material_Item__c a : MIList){
                if(LinkEntityDocIdMap.get(a.Id)!=null){
                    for(String cdocId: LinkEntityDocIdMap.get(a.Id)){
                        if(CondocContentVersionMap.containsKey(cdocId)){
                            if(CondocContentVersionMap.get(cdocId)!=null){
                               if(Schema.sObjectType.Material_Item__c.fields.Attachment_ID__c.isUpdateable()){
                                   a.Attachment_ID__c = CondocContentVersionMap.get(cdocId);}
                                break;
                            }
                            
                        }
                    } 
                }
            }
        }
       if(Schema.sObjectType.Material_Item__c.isUpdateable()){
           update MIList;}
        System.debug('===MIList After Updation==='+MIList);
        
    }
    
    if(Trigger.isDelete){
        System.debug('======Content Document Delete delete==========='+trigger.Old);
        for(ContentDocument cdoc:trigger.Old){
            contentDocumentIdSet.add(cdoc.Id);
 			 system.debug('>>>>>>>>>>>>>>>>contentDocumentIdSet>>>>>>>>>>>>'+contentDocumentIdSet.size());
        }
        
        
        list<Approval_Job_Task__c> ApprvalTskList=[select id,name, File_ID__c from Approval_Job_Task__c where File_ID__c in :contentDocumentIdSet];
        system.debug('>>>>>>>>>>>>>>>>ApprvalTskList>>>>>>>>>>>>'+ApprvalTskList.size());
       // delete ApprvalTskList;
        
        
        
        
        list<ContentDocumentLink> cdlList=[SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE ContentDocumentId IN:contentDocumentIdSet WITH SECURITY_ENFORCED];
        System.debug('===Content Document List==='+cdlList);
        for(ContentDocumentLink cdl:cdlList){
            LinkedEntityIdIdSet.add(cdl.LinkedEntityId);
        }
        
        //cdlList[0].LinkedEntityId
        list<ContentDocumentLink> remcdlList=[SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN:LinkedEntityIdIdSet and ContentDocumentId NOT IN:contentDocumentIdSet WITH SECURITY_ENFORCED];
        for(ContentDocumentLink remcdl:remcdlList){
            remcontentDocumentIdSet.add(remcdl.ContentDocumentId);
            if(!LinkEntityDocIdMap.containskey(remcdl.LinkedEntityId)){
                LinkEntityDocIdMap.put(remcdl.LinkedEntityId,new Set<String>{remcdl.ContentDocumentId});  
            }else{
                Set<String> DummySet=new Set<String>();
                DummySet=LinkEntityDocIdMap.get(remcdl.LinkedEntityId);
                DummySet.add(remcdl.ContentDocumentId);
                LinkEntityDocIdMap.put(remcdl.LinkedEntityId,DummySet);
            }
            
        }
        System.debug('======LinkEntityDocIdMap======'+LinkEntityDocIdMap);
        List<Material_Item__c> MIList = [SELECT Id, Name,Attachment_ID__c FROM Material_Item__c where Id IN:LinkedEntityIdIdSet WITH SECURITY_ENFORCED];   
        List<Billboard__c> BBList=[SELECT Id, Name,Attachment_ID__c FROM Billboard__c where Id IN:LinkedEntityIdIdSet WITH SECURITY_ENFORCED];
        List<ContentVersion> cvList = [SELECT Id,Title, ContentDocumentId FROM ContentVersion where ContentDocumentId IN:remcontentDocumentIdSet and isLatest=true and FileType!='SNOTE' WITH SECURITY_ENFORCED Order by CreatedDate DESC];
        System.debug('=======cvList====='+cvList);
        System.debug('=======MIList====='+MIList);
        System.debug('=======BBList====='+BBList);
        for(ContentVersion cv:cvList){
            if(!CondocContentVersionMap.containskey(cv.ContentDocumentId)){
                CondocContentVersionMap.put(cv.ContentDocumentId,cv.Id);
            }
        }
        
        if(MIList.size() > 0){
            for(Material_Item__c a : MIList){
                if(LinkEntityDocIdMap.get(a.Id)!=null){
                    for(String cdocId: LinkEntityDocIdMap.get(a.Id)){
                        if(CondocContentVersionMap.containsKey(cdocId)){
                            if(CondocContentVersionMap.get(cdocId)!=null){
                                if(Schema.sObjectType.Material_Item__c.fields.Attachment_ID__c.isUpdateable()){
                                    a.Attachment_ID__c = CondocContentVersionMap.get(cdocId);}
                                break;
                            }
                            
                        }
                    } 
                }
            }
        }
         if(Schema.sObjectType.Material_Item__c.isUpdateable()){
             update MIList;}
        System.debug('===MIList After Updation==='+MIList);
    }


   
    
}
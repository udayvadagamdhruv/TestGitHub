trigger MI_Bill_File_Id_Update on ContentDocumentLink (After insert,After Delete,Before Delete) {
    System.debug('=======Firing After Insert Trigger fire Documnet Link===========');
    Set<Id> remcontentDocumentIdSet = new Set<Id>();
    Set<Id> LinkedEntityIdIdSet = new Set<Id>();
    Map<String,Set<String>> LinkEntityDocIdMap=new Map<String,Set<String>>();
    Map<String,String> CondocContentVersionMap=new Map<String,String>();
    
    if(Trigger.isInsert ){ 
        System.debug('======ContentDocumentLink After undelete fires Occurs==========='+trigger.new);
        for(ContentDocumentLink cdl:trigger.new){
            if(cdl.ContentDocumentId != null){
                LinkedEntityIdIdSet.add(cdl.LinkedEntityId);
            }
        }
        
         //cdlList[0].LinkedEntityId
        list<ContentDocumentLink> remcdlList=[SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN:LinkedEntityIdIdSet WITH SECURITY_ENFORCED];
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
        List<ContentVersion> cvList = [SELECT Id,Title, ContentDocumentId FROM ContentVersion where ContentDocumentId IN:remcontentDocumentIdSet and isLatest=true and FileType!='SNOTE' WITH SECURITY_ENFORCED  Order by CreatedDate DESC];
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
                        if(CondocContentVersionMap.containskey(cdocId)){
                            System.debug('=========CondocContentVersionMap.get(cdocId)======'+CondocContentVersionMap.get(cdocId));
                            //if(CondocContentVersionMap.get(cdocId)!=null){
                              if(schema.SobjectType.Material_Item__c.Fields.Attachment_ID__c.isUpdateable()){ 
                                  a.Attachment_ID__c = CondocContentVersionMap.get(cdocId);}
                                 break;
                            //}
                            
                        }
                    } 
                }
            }
        }
        if(Schema.sObjectType.Material_Item__c.isUpdateable()){ update MIList;}
        System.debug('===MIList After Updation==='+MIList);
    }
    
}
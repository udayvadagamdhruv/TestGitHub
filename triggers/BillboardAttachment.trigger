trigger BillboardAttachment on Attachment (after insert, after update, after delete,after Undelete) {
    string attachmentids1='';
    string attachmentids2='';
    
    string attachmentparent;
    Set<Id> aId = new Set<Id>();
    Set<Id> appId = new Set<Id>();
    if(Trigger.isInsert || Trigger.isUndelete){
        for(attachment atch : Trigger.New){
            attachmentparent=atch.parentid;
            aId.add(atch.parentid);
        }
        List<Billboard__c> app = [select id from Billboard__c WITH SECURITY_ENFORCED];
        for(Billboard__c appi : app)
        {
            appId.add(appi.id);
        }
        List<Attachment> att = [select id, name, parentid from Attachment where parentid in:aId AND parentid in:app WITH SECURITY_ENFORCED order by lastmodifieddate DESC limit 2] ;
        
        for(attachment a : att){
            //1st attachment
            if(att.size()>=1)
                if(a.id== att[0].id)
            {
                if(a.ParentId.getSobjectType() == Billboard__c.SobjectType && appId.contains(a.ParentId)){
                    
                    attachmentids1=a.id;
                    
                    //a.parent.MOF__attachment_ids__c=attachmentids;
                    
                }
            }  
            
            // 2nd attachment
            if(att.size()>=2)
                if(a.id== att[1].id)
            {
                if(a.ParentId.getSobjectType() == Billboard__c.SobjectType && appId.contains(a.ParentId)){
                    
                    attachmentids2=a.id;
                    
                    //a.parent.MOF__attachment_ids__c=attachmentids;
                    
                }
            }
            
            
        }
        list<Billboard__c> BillbordAppList=new list<Billboard__c>();
        for(Billboard__c appi :app)
        {
            if(attachmentparent==appi.id){
                if(Schema.sObjectType.Billboard__c.fields.Attachment_ID__c.isUpdateable()){ appi.Attachment_ID__c=attachmentids1;}
                if(Schema.sObjectType.Billboard__c.fields.Attachment_ID2__c.isUpdateable()){ appi.Attachment_ID2__c=attachmentids2;}
                BillbordAppList.add(appi);
                
            }
        }
        if(!BillbordAppList.isEmpty()){
            if(Schema.sObjectType.Billboard__c.isUpdateable()){
                update BillbordAppList;
            }
        }
        
        
        
    }
    
    //delete
    
    if(Trigger.isDelete ){
        for(attachment atch : Trigger.old){
            attachmentparent=atch.parentid;
            aId.add(atch.parentid);
        }
        List<Billboard__c> app = [select id from Billboard__c WITH SECURITY_ENFORCED];
        for(Billboard__c appi : app)
        {
            appId.add(appi.id);
        }
        List<Attachment> att = [select id, name, parentid from Attachment where parentid in:aId AND parentid in:app WITH SECURITY_ENFORCED order by createddate DESC limit 2] ;
        
        for(attachment a : att){
            //1st attachment
            if(att.size()>=1)
                if(a.id== att[0].id)
            {
                if(a.ParentId.getSobjectType() == Billboard__c.SobjectType && appId.contains(a.ParentId)){
                    
                    attachmentids1=a.id;
                    
                }
            }  
            
            // 2nd attachment
            if(att.size()>=2)
                if(a.id== att[1].id)
            {
                if(a.ParentId.getSobjectType() == Billboard__c.SobjectType && appId.contains(a.ParentId)){
                    
                    attachmentids2=a.id;
                    
                    
                }
            }
            
            
        }
        list<Billboard__c> BillbordAppList1=new list<Billboard__c>();
        for(Billboard__c appi :app)
        {
            if(attachmentparent==appi.id){
                if(Schema.sObjectType.Billboard__c.fields.Attachment_ID__c.isUpdateable()){appi.Attachment_ID__c=attachmentids1;}
                if(Schema.sObjectType.Billboard__c.fields.Attachment_ID2__c.isUpdateable()){appi.Attachment_ID2__c=attachmentids2;}
                BillbordAppList1.add(appi);
            }
        }
        if(!BillbordAppList1.isEmpty()){
            if(Schema.sObjectType.Billboard__c.isUpdateable()){
                update BillbordAppList1;
            }
        }
        
        
    }
}
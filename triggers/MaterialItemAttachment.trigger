trigger MaterialItemAttachment on Attachment (after insert, after update, after delete,after undelete) {
    string attachmentids1='';
    string attachmentparent;
    Set<Id> aId = new Set<Id>();
    Set<Id> appId = new Set<Id>();
    if(Trigger.isInsert || Trigger.isUndelete){
        for(attachment atch : Trigger.New){
            attachmentparent=atch.parentid;
            aId.add(atch.parentid);
        }
        List<Material_Item__c > app = [select id from Material_Item__c WITH SECURITY_ENFORCED];
        for(Material_Item__c appi : app)
        {
            appId.add(appi.id);
        }
        List<Attachment> att = [select id, name, parentid from Attachment where parentid in:aId AND parentid in:app WITH SECURITY_ENFORCED order by lastmodifieddate DESC limit 1] ;
        
        for(attachment a : att){
            //1st attachment
            if(att.size()>=1)
                if(a.id== att[0].id)
            {
                if(a.ParentId.getSobjectType() == Material_Item__c.SobjectType && appId.contains(a.ParentId)){
                    
                    attachmentids1=a.id;
                    
                    //a.parent.MOF__attachment_ids__c=attachmentids;
                    
                }
            }  
            
            
            
        }
        list<Material_Item__c> MaterialItemAppList=new list<Material_Item__c>();
        
        for(Material_Item__c  appi :app)
        {
            if(attachmentparent==appi.id){
                if(Schema.sObjectType.Material_Item__c.fields.Attachment_ID__c.isUpdateable()) {
                    appi.Attachment_ID__c=attachmentids1;}
                MaterialItemAppList.add(appi);
                
            }
        }
        if(!MaterialItemAppList.isEmpty()){
            if(Schema.sObjectType.Material_Item__c.isUpdateable()){
                update MaterialItemAppList;}
        }
        
        
    }
    
    //delete
    
    if(Trigger.isDelete ){
        for(attachment atch : Trigger.old){
            attachmentparent=atch.parentid;
            aId.add(atch.parentid);
        }
        List<Material_Item__c > app = [select id from Material_Item__c WITH SECURITY_ENFORCED];
        for(Material_Item__c  appi : app)
        {
            appId.add(appi.id);
        }
        List<Attachment> att = [select id, name, parentid from Attachment where parentid in:aId AND parentid in:app WITH SECURITY_ENFORCED order by createddate DESC limit 1] ;
        
        for(attachment a : att){
            //1st attachment
            if(att.size()>=1)
                if(a.id== att[0].id)
            {
                if(a.ParentId.getSobjectType() == Material_Item__c.SobjectType && appId.contains(a.ParentId)){
                    
                    attachmentids1=a.id;
                    
                    //a.parent.MOF__attachment_ids__c=attachmentids;
                    
                }
            }  
            
            
            
        }
        list<Material_Item__c> MaterialItemAppList1=new list<Material_Item__c>();
        
        for(Material_Item__c  appi :app)
        {
            if(attachmentparent==appi.id){
                if(Schema.sObjectType.Material_Item__c.fields.Attachment_ID__c.isUpdateable()) {
                    appi.Attachment_ID__c=attachmentids1;}
                MaterialItemAppList1.add(appi);
                
            }
        }
        if(!MaterialItemAppList1.isEmpty()){
            if(Schema.sObjectType.Material_Item__c.isUpdateable()){
                update MaterialItemAppList1;}
        }
        
        
    }
}
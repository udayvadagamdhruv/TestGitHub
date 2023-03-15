@isTest(seealldata=true)

Public class TestUnfollowRecordsPageCntr{
    
   /* static testmethod void TestUnfollowRecordsPageCntr(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u2 = new User(Alias = 'newUser', Email='test@abc.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='tes12t@abc.com');
        
        
        insert u2;
        
        Job__c  j=new Job__c(name='test',status__c='Completed');
        insert j;
        EntitySubscription ed=new EntitySubscription (parentid=j.id,SubscriberId=u2.id );
        insert ed;
        ContentDocument c=[select id,title from contentdocument limit 1];
        EntitySubscription ed1=new EntitySubscription (parentid=c.id,SubscriberId=u2.id );
        insert ed1;
        
        system.runas(u2){
            
          //  UnfollowRecordsExt.getJobRec('Completed');
            
            UnfollowRecordsPageCntr t=new UnfollowRecordsPageCntr();
            UnfollowRecordsPageCntr.EntityJobWrapper jwrap=new UnfollowRecordsPageCntr.EntityJobWrapper(j);
            UnfollowRecordsPageCntr.EntityFilebWrapper fwrap=new UnfollowRecordsPageCntr.EntityFilebWrapper(c);
            t.Unfollowrecords();
            t.FileUnfollowrecords();
            t.noofrecords = '1';
            
        }
        
    }
    */
    
    
}
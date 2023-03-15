@isTest(seealldata=true)
public class TestUnfollowRecordsExt {
	 public static void SetupData(){
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
    }
    
    @isTest(seealldata=true) static void TestCampaign_Teams_Controller1(){
        test.startTest();
         Job__c  j=new Job__c(name='test',status__c='Completed');
        insert j;
        Job__c testJob=[select id,name from Job__c where name='test'];
       // String selectedRec='[{"selection":true,"Job":{name='test',status__c='Completed'}}]';
        UnfollowRecordsExt.getJobRec('Completed');
        UnfollowRecordsExt.UnfollowSelectedJobs(new list<sobject>{testJob});
        UnfollowRecordsExt.getChatterFilesRec();
        UnfollowRecordsExt.UnfollowSelectedCF(new list<sobject>{testJob});
        test.stoptest();
        
    }
    
}
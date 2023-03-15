@istest
public class TestLookupSldsCompCtrl {

    @istest static void TestLookupSldsCompCtrl(){
     /* Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        System.debug('profileId====='+ profileId);
     	User usr = new User(LastName = 'LIVESTON',
                           FirstName='JASON',
                           Alias = 'jliv',
                           Email = 'jasonDavid.liveston@asdf.com',
                           Username = 'jasonDavid.liveston@asdf.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        insert usr;
        
         System.debug('User Record====='+usr);
        
       list<User> userlist=[select id,name,email from user where id=:usr.id];
         System.debug('List of User Record====='+userlist);
        
        list<String> flds=new list<String>();
         flds.add('Email');
         //flds.add('Name');
        
        LookupSldsCompCtrl ext=new LookupSldsCompCtrl();
        ext.SobjectName='User';
        ext.FieldsToShow=flds;
        ext.WhereCondi='Where Name NOT  IN (\'Automated Process\',\'jobsuite Site Guest User\')';
        ext.RecordsLimit='1000';
        ext.Dummystring='JASON LIVESTON';
        Apexpages.StandardSetController result=ext.setLookupComp ;
       // ext.getQueryRecordsList();
        list<String> flds1=new list<String>();
         flds1.add('Email');
         ext.FieldsToShow=flds1;
        ext.keyupQuery();
        ext.SelectdValue='testValue';
         ext.keyupQuery();
        ext.CompFirst();
        ext.CompNext();
        ext.CompLast();
        ext.CompPrevious();
        ext.MHidetable();
        ext.RecordsList=null;
        ext.Records=null;
        boolean bo =ext.CompHasPrevious;
        boolean bo1 =ext.CompHasNext;
      */
    }
}
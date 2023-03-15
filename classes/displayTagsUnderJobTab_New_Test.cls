//@IsTest
public class displayTagsUnderJobTab_New_Test{
    /*static testMethod void Test_RetrieveJobTags()
    {
        Job_Number_Setting__c customSetting1310 = new  Job_Number_Setting__c(Name='NO');

            insert customSetting1310;
            
        Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1310');
             
                insert testMedia;
             
        Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1310',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
        Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 1310');
                insert testSpec1;
                
        Spec_Item__c testSPI1=new Spec_Item__c(Name='Test SPI 1310',Description__c='Test Desc 1310',Specification_Template__c=testSpec1.id);
             insert testSPI1;     
             
         Specification_Template__c testSpec2=new Specification_Template__c(Name='Testing Spcification Template 1311');
                insert testSpec2;
                
        Spec_Item__c testSPI2=new Spec_Item__c(Name='Test SPI 1311',Description__c='Test Desc 1310',Specification_Template__c=testSpec2.id);
             insert testSPI2;            
        
        Tag_Template__c testTagTemp = new Tag_Template__c(Name='Test tag temp 5Apr13');
            insert testTagTemp;
            
        Tag_Template_Item__c testTagTempItem = new Tag_Template_Item__c(Name='Test temp Item 5Apr13',TagTemplate__c=testTagTemp.id,Air_Time__c='150', Show_Air_Date__c=date.today(), Promo_End_Date__c=date.today(), Promo_Due_Date__c=date.today(), Air_Date__c=date.today(),Lengths__c='200');
            insert testTagTempItem;
            
        Job__c testJob1=new Job__c(Name='Test Job 1310',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec1.Id);
         
                 insert testJob1;
                 
        System.assertEquals('Test Job 1310',testJob1.Name);        
                 
        Job_Spec__c testJobSpec=new Job_Spec__c(Name='Job Spec 1310',Job__c=testJob1.id);        
             
                 insert testJobSpec;
        
        Tag__c testJobTag = new Tag__c(Name='Test temp Item 5Apr13', Job__c=testJob1.id);
                 insert testJobTag;
                 
        ApexPages.currentPage().getParameters().put('id',testJob1.Id); 
       
       // Instantiate the standard controller with the Job
        ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
       
        // Instantiate the extention instance with the standard controller 
        
        displayTagsUnderJobTab_New ext1=new displayTagsUnderJobTab_New(con);
         ext1.queryStringcopy='tag';     
        // Invoke the primary method on the extension
        ext1.tagId = testJobTag.id;
        ApexPages.currentPage().getParameters().put('id',testJob1.Id);
        ApexPages.currentPage().getParameters().put('tagId',testJobTag.Id);
        ext1.DuplicateTag(); 
        
        ApexPages.Pagereference result=ext1.editJobTag();
       
        result=ext1.save();
        ext1.importTags();
        
        ext1.TagTempName=testTagTemp.Id;
        ext1.importTags();
        result=ext1.addNewJobTag();
        
        List<SelectOption> lst=ext1.getTagTemplates();
       
        result=ext1.cancelme();
       
        ext1.deleteJobTag();
        
        List<Job_Spec__c> lstJobTag=[Select id from Job_Spec__c where Job__r.Name=:'Test Job 1310'];
        delete lstJobTag;
        result=ext1.save();
        
        Job__c obj=[Select Id from Job__c where Name=:'Test Job 1310'];
        delete obj;
        
        Specification_Template__c specTemp1=[Select id from Specification_Template__c where Name=:'Testing Spcification Template 1310'];
        delete specTemp1;
        
        Specification_Template__c specTemp2=[Select id from Specification_Template__c where Name=:'Testing Spcification Template 1311'];
        delete specTemp2;
        
        ext1.importTags();
        
        //added by yogini on 18-Sep-13  
              
    }*/
}
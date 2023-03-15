@isTest
public class Test_RetrieveJobSpec{

  /*  public static testMethod void Test_RetrieveJobSpec()
    {
        Job_Number_Setting__c customSetting1310 = new  Job_Number_Setting__c(Name='NO');

            insert customSetting1310;
            
        Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1310');
             
                insert testMedia;
             
        Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1310',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
        Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 1310');
                insert testSpec1;
                
        Spec_Item__c testSPI1=new Spec_Item__c(Name='Test SPI 1310',Description__c='Test Desc 1310',Specification_Template__c=testSpec1.id,Sort_Order__c=1);
             insert testSPI1;     
             
         Specification_Template__c testSpec2=new Specification_Template__c(Name='Testing Spcification Template 1311');
                insert testSpec2;
                
        Spec_Item__c testSPI2=new Spec_Item__c(Name='Test SPI 1311',Description__c='Test Desc 1310',Specification_Template__c=testSpec2.id);
             insert testSPI2;            
                
        Job__c testJob1=new Job__c(Name='Test Job 1310',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec1.Id);
         
                 insert testJob1;
                 
        System.assertEquals('Test Job 1310',testJob1.Name);        
                 
        Job_Spec__c testJobSpec=new Job_Spec__c(Name='Job Spec 1310',Job__c=testJob1.id,Creative_Brief_Template__c='test',Sort_Order__c=1);        
             
                 insert testJobSpec;
                 
        ApexPages.currentPage().getParameters().put('id',testJob1.Id); 
       // ext1.jobspeid=''+testJobSpec.id;
        ApexPages.currentPage().getParameters().put('nickName',testJobSpec.Id);
       
       // Instantiate the standard controller with the Job
        ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
       
        // Instantiate the extention instance with the standard controller 
        
        RetrieveJobSpec ext1=new RetrieveJobSpec(con);
        
        ext1.NewSortOrder=1.1;
        ext1.Newspecname='test';
        ext1.Newdiscription='test';
        ext1.Newsectionstring='test';
        
        ext1.SortOrder=1.1;
        ext1.specname='test';
        ext1.discription='test';
        ext1.secionstring='test'; 
        ext1.ShowSpecorder=true;
        
        
        
        ext1.specId=testJobSpec.id;
       
        // Invoke the primary method on the extension
        
        ApexPages.Pagereference result=ext1.editJobSpec();
        ext1.jobspeid = testJobSpec.Id;
        ext1.newsavejobspecs();
        ext1.showEditFields();
        ext1.savejobspec();
        ext1.save();
        ext1.importSpecs();
        ext1.editAll();
        ext1.editsave();
        ext1.editCancel();
        
        ext1.SpecTempName=testSpec2.Id;
        ext1.importSpecs();
        ext1.addNewJobSpec();
        
        List<SelectOption> lst=ext1.getSpecificationTemplates();
        ext1.saveNotes();
        ext1.cancelme();
        ext1.deleteJobSpec();
        ext1.deljobspec();
        
        
        List<Job_Spec__c> lstJobSpec=[Select id from Job_Spec__c where Job__r.Name=:'Test Job 1310'];
        delete lstJobSpec;
        ext1.save();
        
        Job__c obj=[Select Id from Job__c where Name=:'Test Job 1310'];
        delete obj;
        
        Specification_Template__c specTemp1=[Select id from Specification_Template__c where Name=:'Testing Spcification Template 1310'];
        delete specTemp1;
        
        Specification_Template__c specTemp2=[Select id from Specification_Template__c where Name=:'Testing Spcification Template 1311'];
        delete specTemp2;
        
        ext1.importSpecs();
        ext1.shownewFileds();
      
        ext1.canceljobspec();
       
       
    }
    
    */
  
    
}
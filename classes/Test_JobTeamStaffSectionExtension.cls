//@isTest
public class Test_JobTeamStaffSectionExtension{
     // Start Test Coverage 
   /* static testMethod void Test_JobTeamStaffSectionExtension()
     {
           Job_Number_Setting__c customSetting997 = new  Job_Number_Setting__c(Name= 'yy');
           insert customSetting997;
     
           Media_Type__c testMedia=new Media_Type__c(Name='Test Media 358');
           insert testMedia;
             
           Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 358',Media_Types__c=testMedia.Id);
           insert testST;
      
           Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 359');
           insert testSpec;
      
           Job__c testJob1=new Job__c(Name='Test Job 360',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
           insert testJob1;
                  
           System.assertEquals('Test Job 360',testJob1.Name);    
           
           Job_Team__c testJT1=new Job_Team__c(Job__c=testJob1.Id,Role__c='Designer');
           insert testJT1;
               
           Job_Team__c testJT2=new Job_Team__c(Job__c=testJob1.Id,Role__c='Project Manager');
           insert testJT2;
               
           Job_Team__c testJT3=new Job_Team__c(Job__c=testJob1.Id,Role__c='Art Director');
           insert testJT3;
               
           ApexPages.currentPage().getParameters().put('Id', testJob1.Id);
         
           // Instantiate the standard controller with the Job
           ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
        
           // Instantiate the extention instance with the standardcontroller 
               JobTeamStaffSectionExtension ext=new JobTeamStaffSectionExtension(con);
        
              ApexPages.PageReference result1=ext.AddStaffs();
                    
    }// End of Test method JobTeam Test */
    
}// End of Test Coverage
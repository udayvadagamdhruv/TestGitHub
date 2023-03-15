//@istest
public class TestschedulesViewExtension {
 /*   @istest static void TestschedulesViewExtension(){
        
        Media_Type__c testMedia=new Media_Type__c(Name='Test Media 616');
          insert testMedia;
          
          Job_Number_Setting__c customSetting1004 = new  Job_Number_Setting__c(Name= 'NO');

            insert customSetting1004;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 616',Media_Types__c=testMedia.Id);
          insert testST;
         
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 616');
          insert testSpec;
                
          Job__c testJob1=new Job__c(Name='Test Job 616',Job_Auto_Number__c='J 616',Flag__c =True,Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , e.getDmlStatusCode(0));
               }
          System.assertEquals('Test Job 616',testJob1.Name); 
              
        
         GL_Department__c testGLD = new GL_Department__c(Name='GLD020');
           
               insert testGLD;
           
          GL_Code__c testGL=new GL_Code__c(Name='GL1040',GL_ID__c='GLC1040',GL_Department__c = testGLD.id);
           
                 insert testGL;
           
           Job_Task__c testJT=new Job_Task__c(Name='Test JT 1040',Days__c=2,GL_Code__c=testGL.id,Job__c=testJob1.id,Start_Date__c=System.Today());
           insert testJT;
        
        schedulesViewExtension ext=new schedulesViewExtension(new ApexPages.StandardController(testJT));
        ext.checkDelete();
        
    }*/
}
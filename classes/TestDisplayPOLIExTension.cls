@isTest
Public Class TestDisplayPOLIExTension{

/*
    // Start Test Method
     static testMethod void TestDisplayPOLIExTension()
     {
          
           Test.startTest();
           
           Job_Number_Setting__c customSetting001 = new  Job_Number_Setting__c(Name='NO');
                 insert customSetting001;
            
           Media_Type__c testMedia=new Media_Type__c(Name='TM9898');
                 insert testMedia;
          
          Schedule_Template__c testST=new Schedule_Template__c(Name='ST9898',Media_Types__c=testMedia.Id);
                 insert testST;
   
          Specification_Template__c testSpec=new Specification_Template__c(Name='SPT9898');
                 insert testSpec;
                
          Campaign__c testCampaign1=new Campaign__c(Name='C9898',Active__c=True,Status__c='In Progress',Budgeted_Cost__c=5000,Actual_Cost__c=6000);
                 insert testCampaign1;
         
          Client__c a=new Client__c(Name='Client9898');
                 insert a;
         
          Client_Contact__c c=new Client_Contact__c(First_Name__c='Contact 9898',Last_Name__c='LN001',Client__c=a.id,Email__c='testEmail001@sfdc.com',UserName__c='testEmail001@sfdc.com',Salesforce_User__c=True);
                 insert c;
                
          Job__c testJob1=new Job__c(Name='Job9898',Flag__c=True, Job_Auto_Number__c='J 9898',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id);
                 insert testJob1;          
          
          System.assertEquals('Job9898',testJob1.Name);       
          
          GL_Department__c testGLD = new GL_Department__c(Name='TestGLD998');
                 insert testGLD;
               
          GL_Code__c testGL=new GL_Code__c(Name='GL Code 9989',GL_ID__c='TestGL9989',GL_Department__c = testGLD.id,Unit_Type__c='Project');
                  insert testGL;
               
          Estimate_Line_Items__c testELI=new Estimate_Line_Items__c(Name='Est 9898',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c=testGL.id,Quantity__c=100,Amount__c=1200);
                  insert testELI; 
          Production_Estimate__c testPELI=new Production_Estimate__c(Name='ELI0 361',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c = testGL.id,Amount__c=100,Quantity__c=10,Approved__c = true );
          try
          {
            insert testPELI;
          }
       catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }        
          Purchase_Order__c testPO = new Purchase_Order__c(Name='PO 9898', Job__c=testJob1.id);
                 insert testPO;  
                 
           PO_Line_Item__c testPOLI1 = new PO_Line_Item__c(Purchase_Order__c = testPO.id, Estimate_Line_Item__c=testELI.id);       
                  insert testPOLI1; 

           // Instantiate the extention instance with the Custom Controller
           DisplayPOLIExTension ext=new DisplayPOLIExTension();
           
            // Invoke the primary method on the extension
            
           ext.strPOLI=testPOLI1.id;
             
           ext.add_ELI();
           ext.add_PELI();
               
           ext.deletePOLI();
           
          Test.stopTest();
 } */
   // End of test Method

}
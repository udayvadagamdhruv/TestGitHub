//@isTest
Public class TestDisplayShipmentLineitemsController{

/*static testMethod void TestDisplayShipmentLineitemsController (){

/*Job_Number_Setting__c customSetting1 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting1;
     
            Media_Type__c testMedia=new Media_Type__c(Name='TM02Mar');
               insert testMedia;
             
           Schedule_Template__c testST=new Schedule_Template__c(Name='TST02Mar',Media_Types__c=testMedia.Id);
               insert testST;
                 
           Specification_Template__c testSpec=new Specification_Template__c(Name='TST02Mar');
               insert testSpec;
           
           Job__c testJob1=new Job__c(Name='TJ02Mar',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
            try
             {
                   insert testJob1;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
           
           System.assertEquals('TJ02Mar',testJob1.Name);  
      
         Production_Estimate__c peli = new Production_Estimate__c(Name = 'Test PEli',Job__c = testJob1.Id,Quantity__c = 12);
         insert peli;
         
         Client__c testClient=new Client__c(Name='Test client');
         insert testClient; 
           
         /* Job Creation Ending *  
             Job_Number_Setting__c customSetting001 = new  Job_Number_Setting__c(Name='NO');

            insert customSetting001;
            
          Media_Type__c testMediat=new Media_Type__c(Name='TM001');
          insert testMediat;
          
          Schedule_Template__c testSTt=new Schedule_Template__c(Name='ST001',Media_Types__c=testMedia.Id);
          insert testSTt;
   
          Schedule_Task__c testSCT1=new Schedule_Task__c(Name='ST001',Schedule_Template__c=testST.Id);
          insert testSCT1;
                 
          Schedule_Task__c testSCT2=new Schedule_Task__c(Name='ST002',Schedule_Template__c=testST.Id);
          insert testSCT2;
                 
          ScheduleTaskRole__c testSTR1=new ScheduleTaskRole__c(Name='R001',Schedule_Task__c=testSCT1.Id);
          insert testSTR1;
                 
          ScheduleTaskRole__c testSTR2=new ScheduleTaskRole__c(Name='R002',Schedule_Task__c=testSCT2.Id);
          insert testSTR2;            
                 
          Specification_Template__c testSpect=new Specification_Template__c(Name='SPT001');
          insert testSpect;
                
          Spec_Item__c testSPI=new Spec_Item__c(Name='SI001',Specification_Template__c=testSpec.Id); 
          insert testSPI;
         
          Campaign__c testCampaign1=new Campaign__c(Name='C001',Active__c=True,Status__c='In Progress',Budgeted_Cost__c=5000,Actual_Cost__c=6000);
          insert testCampaign1;
         
          Client__c a=new Client__c(Name='Account001');
          insert a;
         
          Client_Contact__c c=new Client_Contact__c(First_Name__c='Contact 001',Last_Name__c='LN001',Client__c=a.id,Email__c='testEmail001@sfdc.com',UserName__c='testEmail001@sfdc.com',Salesforce_User__c=True);
          insert c;
                
          Job__c testJob1t=new Job__c(Name='Job002',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id,Schedule_Calc__c='Start Date');
          insert testJob1t;
          
          /* Ending Job Creation Ending*
          
          
         Shipment__c   testI=new Shipment__c (Client__c=testClient.Id, Job__c=testJob1t.Id);
         insert testI;
         Shipment_Line_Item__c sli=new Shipment_Line_Item__c(Shipment__c=testI.id,Production_Estimate__c=peli.id);
         insert sli;
    	 Shipment_Line_Item__c sli1=new Shipment_Line_Item__c(Shipment__c=testI.id,Production_Estimate__c=peli.id);
         insert sli1;
         
         ApexPages.currentPage().getParameters().put('id',testI.Id);

         DisplayShipmentLineitemsController ext1=new DisplayShipmentLineitemsController();
        // Invoke the primary method on the extension
           ApexPages.PageReference result1=ext1.createSLI();
           result1 = ext1.createSLI();
           ext1.strsli= sli.Id;
           result1 = ext1.save();
           result1 = ext1.cancelme();
    		ext1.deleteSLI();
    ProductionEstimate__c  activeSettings = New ProductionEstimate__c(Active__c = true);
    insert activeSettings;
    ext1.strsli= sli1.Id;
    ext1.deleteSLI();
          // result1 = ext1.deleteSLI();
         
  }*/
  }
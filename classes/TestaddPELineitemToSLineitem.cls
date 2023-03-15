//@isTest
Public class TestaddPELineitemToSLineitem{

/*static testMethod void TestaddPELineitemToSLineitem()
    {
         Job_Number_Setting__c customSetting955 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting955;
         Client__c testClient=new Client__c(Name='Test client');
         insert testClient; 
         Media_Type__c testMedia=new Media_Type__c(Name='Supplies');
          try
           {
               insert testMedia;
           }
          catch(System.DMLException e)
           {
               System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
           }
           
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 318',Media_Types__c=testMedia.Id);
          insert testST;
                 
          Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 318',Media_Types__c=testMedia.Id);
           try
            {
                insert testST1;
            }
           catch(System.DMLException e)
            {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }

           Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 318');
           insert testSpec;
                
           Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 318');
            try
             {
                 insert testSpec1;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
              
           Job__c testJob1=new Job__c(Name='Test Job 318',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Status__c='Active',JS_Client__c=testClient.id );
            try
             {
             insert testJob1;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
             } 
            System.assertEquals('Test Job 318',testJob1.Name);    
                
            Vendor__c testVendor=new Vendor__c(Name='Test Vendor 318');
            insert testVendor;
          
          
      /* Job Creation Ending       
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
          
          /* Ending Job Creation Ending 
           
            Shipment__c   testI=new Shipment__c (Client__c=testClient.Id, Job__c=testJob1t.Id);
             insert testI;
          
        Estimate_Line_Items__c testELIs = new Estimate_Line_Items__c(Name='test', Job__c=testJob1t.id);
        insert testELIs;
          
           GL_Department__c testGLD = new GL_Department__c(Name='TestGLD6');
            try
             {
                 insert testGLD;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
          
           GL_Code__c testGL=new GL_Code__c();
            testGL.Name='Test GL Code21';
            testGL.GL_Id__c='GL Code555';
            testGL.Unit_Cost__c=2500;
            testGL.Unit_Type__c='Days';
            testGL.GL_Department__c=testGLD.id;
            try
             {
             insert testGL;
             }
            catch(System.DMLException e)
             {
             System.assert(e.getMessage().contains('Record already exist with same GLCode'));
             }
        
           GL_Code__c testGL1=new GL_Code__c();
            testGL1.Name='Test GL Code22';
            testGL1.GL_Id__c='GL Code565';
            testGL1.Unit_Cost__c=1500;
            testGL1.Unit_Type__c='Project';
            testGL1.GL_Department__c=testGLD.id;
            try
             {
                 insert testGL1;
             }
            catch(System.DMLException e)
             {
                 System.assert(e.getMessage().contains('Record already exist with same GLCode'));
             }
         
           Production_Estimate__c testELI=new Production_Estimate__c(Shippment_status__c='Ready to be shipped',Name='Quote 20',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Vendor__c=testVendor.Id,PO_Created__c=false,Approved__c=True,GL_Code__c=testGL.id,Amount__c=2000,Quantity__c=120);
           insert testELI;
          
           Production_Estimate__c testELI1=new Production_Estimate__c(Shippment_status__c='Ready to be shipped',Name='Estimate 21',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Vendor__c=testVendor.Id,PO_Created__c=false,Approved__c=True,GL_Code__c=testGL1.Id,Amount__c=5000,Quantity__c=100);
           insert testELI1;
          
           Production_Estimate__c ELI=[Select id,Name,Total_cost__c,Vendor__c,Shippment_status__c,Job__c,Approved__c From Production_Estimate__c where Vendor__c =: testVendor.Id and Job__c =: testJob1.Id and Approved__c = true and PO_Created__c = false limit 1];
          
            ApexPages.currentPage().getParameters().put('id',testI.Id);
            addPELineitemToSLineitem ext=new addPELineitemToSLineitem();
            addPELineitemToSLineitem.ELIWrapper rw=new addPELineitemToSLineitem.ELIWrapper();
            rw.e=testELI1;
            rw.checked=True;
            // Invoke the primary method on the extension
            
        	ext.Save(); 
            ext.roleWraps.add(rw);
        	ProductionEstimate__c pe = new ProductionEstimate__c(Active__c = true);
        	insert pe;
            ext.save();
        addPELineitemToSLineitem ext11=new addPELineitemToSLineitem();
            ext.Back();             
    }
   // End of Test Coverage 
*/


}
//@isTest
Public class TestEditShipmentExtension{

/*static testMethod void TestEditShipmentExtension (){

    
         Job_Number_Setting__c customSetting001 = new  Job_Number_Setting__c(Name='NO');

            insert customSetting001;
            
          Media_Type__c testMedia=new Media_Type__c(Name='TM001');
          insert testMedia;
          
          Schedule_Template__c testST=new Schedule_Template__c(Name='ST001',Media_Types__c=testMedia.Id);
          insert testST;
   
          Schedule_Task__c testSCT1=new Schedule_Task__c(Name='ST001',Schedule_Template__c=testST.Id);
          insert testSCT1;
                 
          Schedule_Task__c testSCT2=new Schedule_Task__c(Name='ST002',Schedule_Template__c=testST.Id);
          insert testSCT2;
                 
          ScheduleTaskRole__c testSTR1=new ScheduleTaskRole__c(Name='R001',Schedule_Task__c=testSCT1.Id);
          insert testSTR1;
                 
          ScheduleTaskRole__c testSTR2=new ScheduleTaskRole__c(Name='R002',Schedule_Task__c=testSCT2.Id);
          insert testSTR2;            
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='SPT001');
          insert testSpec;
                
          Spec_Item__c testSPI=new Spec_Item__c(Name='SI001',Specification_Template__c=testSpec.Id); 
          insert testSPI;
         
          Campaign__c testCampaign1=new Campaign__c(Name='C001',Active__c=True,Status__c='In Progress',Budgeted_Cost__c=5000,Actual_Cost__c=6000);
          insert testCampaign1;
         
          Client__c a=new Client__c(Name='Account001');
          insert a;
         
          Client_Contact__c c=new Client_Contact__c(First_Name__c='Contact 001',Last_Name__c='LN001',Client__c=a.id,Email__c='testEmail001@sfdc.com',UserName__c='testEmail001@sfdc.com',Salesforce_User__c=True);
          insert c;
                
          Job__c testJob1=new Job__c(Name='Job002',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=a.id,JS_Client_Contact__c=c.id,Schedule_Calc__c='Start Date');
          insert testJob1;
           
         Shipment__c   testI=new Shipment__c (Job__c=testJob1.Id);
         insert testI;
         
         Shipment_Line_Item__c sli=new Shipment_Line_Item__c(Shipment__c=testI.id);
         insert sli;
         list<Shipment_Line_Item__c> listShipmentitems = new list<Shipment_Line_Item__c>();
         listShipmentitems = [SELECT id,name,Shipment__c,Item_Status__c FROM Shipment_Line_Item__c WHERE Shipment__c=:testI.id];
         
         Shipment__c   sp= [Select id,name from Shipment__c   where id =:testI.Id];
         
           
         ApexPages.StandardController con=new ApexPages.StandardController(sp);
     
           // Instantiate the extention instance with the standard controller
         EditShipmentExtension ext =new EditShipmentExtension(con);
        
           // Invoke the primary method on the extension 
           ApexPages.PageReference result1=ext.saveme();
           ApexPages.PageReference result2=ext.cancelme();
           List<SelectOption> clients=ext.getjobs();
           string result5=ext.getJobName();
         //  ext.SetJobName('Test Job');
        
        EditShipmentSwitchExt jb=new EditShipmentSwitchExt(con);
    
       ShipmentListViewSwitchExt jbb=new ShipmentListViewSwitchExt(con);
       ApexPages.PageReference p12=jbb.pagedir();
    
      DeleteShipmentExtension delext=new DeleteShipmentExtension(con);
      ApexPages.PageReference p121=delext.checkDelete();
       p121=delext.checkDelete();
          
       
}*/

}
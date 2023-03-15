@isTest
public class TestDuplicateSTExtensionNew {
 static testMethod void Test_DuplicateScheduletemplateExtensionNew()
    {
        
        // Insert required data to test DuplicateScheduletemplateExtensionNew class
        
        Media_Type__c testMedia=new Media_Type__c(Name='TM1232');
        insert testMedia;
        
        Schedule_Template__c testST=new Schedule_Template__c(Name='ST1232',Media_Types__c=testMedia.Id);
        insert testST;           
        
        Schedule_Task__c testSCT1=new Schedule_Task__c(Name='ST1232',Schedule_Template__c=testST.Id,Days__c=2);
        insert testSCT1;
        
        Schedule_Task__c testSCT2=new Schedule_Task__c(Name='ST1233',Schedule_Template__c=testST.Id,Days__c=1);
        insert testSCT2;
        
        ScheduleTaskRole__c testSTR1=new ScheduleTaskRole__c(Name='Role1',Schedule_Task__c=testSCT1.Id);
        insert testSTR1;
        
        ScheduleTaskRole__c testSTR2=new ScheduleTaskRole__c(Name='Role2',Schedule_Task__c=testSCT2.Id);
        insert testSTR2;
        
        ApexPages.CurrentPage().getParameters().put('id',testST.id);
        
        ApexPages.StandardController con=new ApexPages.StandardController(testST);
        
        // Instantiate the extention instance with the standardcontroller   
        DuplicateScheduletemplateExtensionNew ext=new DuplicateScheduletemplateExtensionNew(con);
        
        // Invoke methods on the extension
        
        ApexPages.Pagereference result1=ext.duplicateScheduleTemplate();
        result1=ext.AfterError(); 
        result1=ext.duplicateScheduleTemplate();
        
    }
}
//@istest
public class TesteditinvoiceSwitchExt {
    /*@istest static void TestEditswitch(){
        
        Media_Type__c testMedia=new Media_Type__c(Name='Test Media 321');
             insert testMedia;
             
         Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 321',Media_Types__c=testMedia.Id);
             insert testST;
      
         Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 321');
             insert testSpec;
       
         Job__c testJob1=new Job__c(Name='Test Job 321',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
          try
           {
               insert testJob1;
           }
          catch(System.DMLException e)
           {
               System.assert(e.getMessage().contains('Job with same name Exists'));
           }
        
        Invoice__c testI=new Invoice__c(Name='Test Invoice',Date_Received__c=System.Today(),Job__c=testJob1.id);
        insert testI;
        editinvoiceSwitchExt editcon=new editinvoiceSwitchExt(new Apexpages.standardController(testI));
            
    }*/

}
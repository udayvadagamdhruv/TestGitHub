// This class is used to Display Vendor Quote Line Item when Approved
public with sharing class DisplayVQLIwhenApprovedExtension 
{
    // Global variables
 /*   String theID;
    Id quoteId;
    public List<Quote_Spec_Item__c> vq{get;set;} 
    // End of Global variables
    
    // Start Constructor
    public DisplayVQLIwhenApprovedExtension(ApexPages.StandardController controller) 
    {
        theID = ApexPages.CurrentPage().getParameters().get('id');
        Vendor_Quote__c objVendorQ=[Select Id,Quote__c from Vendor_Quote__c where Id=: theId LIMIT 1];
        quoteId=objVendorQ.Quote__c;
        vq=[select id,Name,Description__c from Quote_Spec_Item__c where Quote__c =: quoteId Order By CreatedDate];
    }
    // End Constructor
 
    // Test Method
  static testMethod void DisplayVQLIwhenApproved()
    {
            Job_Number_Setting__c customSetting993 = new  Job_Number_Setting__c(Name= 'yy');
            insert customSetting993;
           
            Media_Type__c testMedia=new Media_Type__c(Name='Test Media 8797');
             
                insert testMedia;
             
            Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 8797',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
            Schedule_Task__c testSchedule1=new Schedule_Task__C(Name='Test Schedule Task 8797',Schedule_Template__c=testST.id,Days__c=3);
                insert testSchedule1;
                
         
                
            ScheduleTaskRole__c testSTR1=new ScheduleTaskRole__c(Name='Test Role 8797',Schedule_Task__c=testSchedule1.id);
                insert testSTR1;
                
             Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 8797');
                insert testSpec;
                
             Job__c testJob1=new Job__c(Name='Test Job 8797',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
         
                 insert testJob1;
                 
            Quote__c testQ=new Quote__c(Name='Test Q 8797',Job__c=testJob1.id);
                insert testQ;
       
           Vendor_Quote__c testvq = new Vendor_Quote__c(Quote__c=testQ.Id);
               insert testVQ;

           ApexPages.currentPage().getParameters().put('id',testVQ.id);
           ApexPages.StandardController con=new ApexPages.StandardController(testVQ);
           DisplayVQLIwhenApprovedExtension ext=new DisplayVQLIwhenApprovedExtension(con);
           System.assertEquals('Test Job 8797',testJob1.Name);
    } */
     // End of test Method 
}
// End of Class
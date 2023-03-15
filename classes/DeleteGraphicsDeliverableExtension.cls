// This class is used to Delete Graphics Deliverable associated with Job

// This class is used as extension class for DeleteGraphicsDeliverable

public with sharing class DeleteGraphicsDeliverableExtension 
{
  // Global variables
 /* 
   public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
     } 
      public Id JobId;
      private final Graphics_Deliverables__c objGD; 
      public Boolean isError{get;set;}
      public String OId{get;set;}
   // End Global variables
   
   // Start Constructor   
    public DeleteGraphicsDeliverableExtension(ApexPages.StandardController controller) 
    {
       isError = False;
       this.objGD=(Graphics_Deliverables__c)controller.getrecord();
       JobId = [Select Id, Job__c from Graphics_Deliverables__c where Id =:objGD.Id limit 1].Job__c;
       
       Schema.DescribeSObjectResult r = Job__c.sObjectType.getDescribe();
        oId = r.getKeyPrefix();
    }
    // End Constructor
    
    // Method called on to delete Session record
     public PageReference checkDelete()
     {
        try
        {
             if(Graphics_Deliverables__c.sObjectType.getDescribe().isDeletable()){
                 Database.delete(objGD); 
             }
        }
        catch(System.DMLException e)
        {
            isError = True;
            return null;
        }
        
          PageReference p;
        if(isLtng)
        {
             p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=GD');
        }
        else
        {
              p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=11');
        }
        
      //  PageReference p =   new Pagereference('/'+oId);
        p.setRedirect(true);
        return p;
     }
     // End Delete Method
     
      // Start Test method
    static testMethod void Test_DeleteGraphicsDeliverableExtension()
    {
        Job_Number_Setting__c customSetting351 = new  Job_Number_Setting__c(Name= 'yy');
                insert customSetting351;
            
        Media_Type__c testMedia1=new Media_Type__c(Name='Test Media 3521');
                insert testMedia1;
             
        Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 3521',Media_Types__c=testMedia1.Id);
                insert testST1;
                 
        Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 3521');
                insert testSpec1;
                
        Job__c testJob1=new Job__c(Name='Test Job 3521',Flag__c=True, Job_Auto_Number__c='Job 3521',Start_Date__c=System.Today(),Media_Types__c=testMedia1.Id,Schedule_Template__c=testST1.Id,Specification_Template__c=testSpec1.Id);
                insert testJob1;
                 
        System.assertEquals('Test Job 3521',testJob1.Name);        
         
        Graphics_Deliverables__c testGD1=new Graphics_Deliverables__c(Name='Test Graphics 3521',Job__c=testJob1.Id,Graphics_Description__c='Test Graphics Desc 3521',Graphics_Note__c='Test Graphics Note 3521',Graphics_Type__c='Test Graphics Type 3521');   
                insert testGD1;
        
        ApexPages.currentPage().getParameters().put('jobId',testJob1.id);
        
        // Instantiate the standard controller with Graphics Deliverable
        ApexPages.StandardController con= new ApexPages.StandardController(testGD1);
        
        // Instantiate the extension instance with the standard controller
        DeleteGraphicsDeliverableExtension ext= new DeleteGraphicsDeliverableExtension(con);
        
        // Invoke the primary methods on extension
        ApexPages.Pagereference result=ext.checkDelete();
        
        result=ext.checkDelete(); // To cover catch block inside checkDelete method
    }*/
    // End of Test method
}
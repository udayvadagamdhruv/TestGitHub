// This class is used as extension for VF page : CreateNewGraphicsDeliverable

public with sharing class CreateNewGraphicsDeliverables {

/*    // Global variables
    
       public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
     } 
    
    public Id jobId{get;set;}
    private final Graphics_Deliverables__c objGD;
    // End of Global variables
    
    // Start constructor
    public CreateNewGraphicsDeliverables(ApexPages.StandardController controller) 
    {
        this.objGD = (Graphics_Deliverables__c)controller.getRecord(); 
        jobId = ApexPages.CurrentPage().getParameters().get('jobId');
        objGD.Job__c = jobId;
    }
    // End of constructor
    
    // This method is called on to handle Save button
    public pagereference save()
    {
        try
        {
            insert objGD; 
        }
        catch(Exception e)
        {
            return NULL;    
        } 
        // After creating new record, navigate to Develirables Tab
        
         PageReference p;
        if(isLtng)
        {
             p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=GD');
        }
        else
        {
              p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=11');
        }
        
        
      //  Pagereference p = new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=11');
        p.setRedirect(true);
        return(p);
    }
    // End of method Save
    
    
    
     // This method is called on to handle Save&New button
    public pagereference savenew()
    {
        try
        {
            insert objGD; 
        }
        catch(Exception e)
        {
            return NULL;    
        } 
        // After creating new record, navigate to Develirables Tab
        
         PageReference p;
            if(isLtng)
            {
                 p = Page.CreateNewGraphicsDeliverableLightning;
            }
            else
            {
                  p = Page.createNewGraphicsDeliverable;
            }
            
           //  Pagereference p= Page.createNewGraphicsDeliverable;
             p.setRedirect(true);
             p.getParameters().put('jobId',jobId);
            return p;
    }
    // End of method Save
    
    
    
    
    
    
    
    // This method is called on to handle Cancel button
    public pagereference cancel()
    {
        // Navigate to Deliverables Tab
        
        
         PageReference p;
        if(isLtng)
        {
             p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=GD');
        }
        else
        {
              p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=11');
        }
        
        
    //    Pagereference p = new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=11');
        p.setRedirect(true);
        return p;
    }
    // End of method Cancel
    
  /*  // Start Test method
    static testMethod void Test_CreateNewGraphicsDeliverables()
    {
        Job_Number_Setting__c customSetting351 = new  Job_Number_Setting__c(Name= 'yy');
                insert customSetting351;
            
        Media_Type__c testMedia1 = new Media_Type__c(Name='Test Media 3519');
                insert testMedia1;
             
        Schedule_Template__c testST1 = new Schedule_Template__c(Name='Test Schedule Template 3519',Media_Types__c=testMedia1.Id);
                insert testST1;
                 
        Specification_Template__c testSpec1 = new Specification_Template__c(Name='Testing Spcification Template 3519');
                insert testSpec1;
                
        Job__c testJob1 = new Job__c(Name='Test Job 3519',Flag__c=True, Job_Auto_Number__c='Job 3519',Start_Date__c=System.Today(),Media_Types__c=testMedia1.Id,Schedule_Template__c=testST1.Id,Specification_Template__c=testSpec1.Id);
                insert testJob1;
                 
        System.assertEquals('Test Job 3519',testJob1.Name);        
         
        Graphics_Deliverables__c testGD1 = new Graphics_Deliverables__c(Name='Test Graphics 3519',Job__c=testJob1.Id);   

         // Pass the job id to VF page       
        ApexPages.currentPage().getParameters().put('jobId',testJob1.id);
        
        // Instantiate the standard controller with Graphics Deliverable
        ApexPages.StandardController con = new ApexPages.StandardController(testGD1);
        
        // Instantiate the extension instance with the standard controller
        CreateNewGraphicsDeliverables ext = new CreateNewGraphicsDeliverables(con);
        
        // Invoke the primary methods on extension
        ApexPages.Pagereference result = ext.save();
        
        result=ext.cancel();    
        
        delete testGD1; // To Cover Catch block
        
        result = ext.save();
    }
    // End of Test method*/

}// End of class
// This class is  used as extension for EditGraphicDeliverables

public with sharing class EditGraphicsDeliverables
{
    // Global variables
    
     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
     } 
    
    private final Graphics_Deliverables__c objGD;
    public String jobId{get;set;}
    // End of Global variables
    
    // Start constructor 
    public EditGraphicsDeliverables(ApexPages.StandardController con)
    {
        
         if (!Test.isRunningTest()) 
        con.addFields(new List<String>{'job__c','name','Dummy_Picklist_1__c','Dummy_Picklist_2__c','Dummy_Picklist_3__c','Dummy_Picklist_5__c','Dummy_Picklist_4__c','Deliverable_Date__c','Graphics_Type__c','Graphics_Description__c','Dummy_Date_1__c','Dummy_Date_2__c','Dummy_Date_3__c','Dummy_Date_4__c','Dummy_Date_5__c','Dummy_Text_1__c','Dummy_Text_2__c','Dummy_Text_3__c','Dummy_Text_4__c','Dummy_Text_5__c','Dummy_Text_6__c','Dummy_Text_7__c','Dummy_Text_8__c','Dummy_Text_9__c','Dummy_Text_10__c','Dummy_Text_11__c','Dummy_Text_12__c','Dummy_Text_13__c','Dummy_Text_14__c','Dummy_Text_15__c','Graphics_Description__c','CreatedDate','Graphics_Note__c'});
        
        this.objGD=(Graphics_Deliverables__c)con.getRecord();   
        Graphics_Deliverables__c gdid = [select id,job__c from Graphics_Deliverables__c where id =:objGD.id]; 
        //jobId=objGD.Job__c; 
       jobId=gdid.Job__c; 
       // jobId=ApexPages.CurrentPage().getParameters().get('id');
    }       
    // End of constructor

    // This method is called on to edit Graphics Deliverable record
    public pagereference saveGraphics()
    {
        try
        {
            update objGD;
        }
        catch(Exception e)
        {
           // ApexPages.Message msg1=new ApexPages.Message(ApexPages.Severity.Error,String.valueOf(e));
           // ApexPages.addMessage(msg1);
            return NULL;
        }
        // After update navigate to Graphics Tab
        
        
          PageReference p;
        if(isLtng)
        {
             p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=GD');
        }
        else
        {
              p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=11');
        }
        
        
     //  Pagereference p=new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=11');
        p.setRedirect(true);
        return p;   
    }
    // End of method saveGraphics

    // This method is called on to handle cancel button operation
    public Pagereference cancelGraphics()
    {
        // Navigate to Graphics Tab
    // Pagereference p=new Pagereference('/apex/JobListView?id='+jobId);
    
    
          PageReference p;
        if(isLtng)
        {
             p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=GD');
        }
        else
        {
              p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=11');
        }
    
    
      // Pagereference p=new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=11');
        p.setRedirect(true);
        return p;   
    }
    // End of method cancelGraphics
    
     // Start Test method
  /*  static testMethod void Test_CreateNewGraphicsDeliverables()
    {
        Job_Number_Setting__c customSetting351 = new  Job_Number_Setting__c(Name= 'yy');
                insert customSetting351;
            
        Media_Type__c testMedia1=new Media_Type__c(Name='Test Media 3519');
                insert testMedia1;
             
        Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 3519',Media_Types__c=testMedia1.Id);
                insert testST1;
                 
        Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 3519');
                insert testSpec1;
                
        Job__c testJob1=new Job__c(Name='Test Job 3520',Flag__c=True, Job_Auto_Number__c='Job 3520',Start_Date__c=System.Today(),Media_Types__c=testMedia1.Id,Schedule_Template__c=testST1.Id,Specification_Template__c=testSpec1.Id);
                insert testJob1;
                 
        System.assertEquals('Test Job 3520',testJob1.Name);        
         
       Graphics_Deliverables__c testGD1=new Graphics_Deliverables__c(Name='Test Graphics 3520',Job__c=testJob1.Id,Graphics_Description__c='Test Graphics Desc 3520',Graphics_Note__c='Test Graphics Note 3520',Graphics_Type__c='Test Graphics Type 3520');   
                insert testGD1;
        
        ApexPages.currentPage().getParameters().put('jobId',testJob1.id);
        
        // Instantiate the standard controller with Graphics Deliverable
        ApexPages.StandardController con= new ApexPages.StandardController(testGD1);
        
        // Instantiate the extension instance with the standard controller
        EditGraphicsDeliverables ext= new EditGraphicsDeliverables(con);
        
        // Invoke the primary methods on extension
        ApexPages.Pagereference result=ext.saveGraphics();
        
        result=ext.cancelGraphics();    
        
        delete testJob1;           // To cover catch block inside saveGraphics method and invoke saveGraphics method
    
        result=ext.saveGraphics();
    }*/
    // End of Test method
}// End of Class
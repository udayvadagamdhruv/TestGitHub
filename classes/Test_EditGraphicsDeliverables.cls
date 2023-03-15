@isTest
Public Class Test_EditGraphicsDeliverables{
  /*  static testMethod void Test_EditGraphicsDeliverables()
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
    }
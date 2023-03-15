@isTest
Public Class Test_displayGDUnderJobsTab{       
      /*  static testMethod void Test_displayGDUnderJobsTab()
        {
             Job_Number_Setting__c customSetting1777 = new  Job_Number_Setting__c(Name='NO');

                insert customSetting1777;
                
             Media_Type__c testMedia1=new Media_Type__c(Name='Test Media 1666');
             
                insert testMedia1;
             
             Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 1777',Media_Types__c=testMedia1.Id);
             
                 insert testST1;
     
             Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 1777');
                 
                 insert testSpec1;
    
             Job__c testJob1=new Job__c(Flag__c=True,Job_Auto_Number__c='J 1777',Name='Test Job 1777',Start_Date__c=System.Today(),Media_Types__c=testMedia1.Id,Schedule_Template__c=testST1.Id,Specification_Template__c=testSpec1.Id);
             
                   insert testJob1;
                   
             System.assertEquals('Test Job 1777',testJob1.Name);       
               
             Graphics_Deliverables__c testGD1=new Graphics_Deliverables__c(Name='Test Graphics 1777',Job__c=testJob1.Id,Graphics_Description__c='Test Graphics Desc 1777',Graphics_Note__c='Test Graphics Note 1777',Graphics_Type__c='Test Graphics Type 1777');   
                insert testGD1;
                
             Graphics_Deliverables__c testGD2=new Graphics_Deliverables__c(Name='Test Graphics 1888',Job__c=testJob1.Id,Graphics_Description__c='Test Graphics Desc 1777',Graphics_Note__c='Test Graphics Note 1777',Graphics_Type__c='Test Graphics Type 1777');   
                insert testGD2;   
            Graphics_Deliverables__c testGD22=new Graphics_Deliverables__c(Name='Test Graphics 1889',Job__c=testJob1.Id,Graphics_Description__c='Test Graphics Desc 1777',Graphics_Note__c='Test Graphics Note 1777',Graphics_Type__c='Test Graphics Type 1777');   
                insert testGD22;   
            Graphics_Deliverables__c testGD23=new Graphics_Deliverables__c(Name='Test Graphics 1890',Job__c=testJob1.Id,Graphics_Description__c='Test Graphics Desc 1777',Graphics_Note__c='Test Graphics Note 1777',Graphics_Type__c='Test Graphics Type 1777');   
                insert testGD23;   
               

            // Instantiate the extention instance with the Custom Controller
           displayGraphicsDeliverablesUnderJobsTab ext=new displayGraphicsDeliverablesUnderJobsTab();
           
           // Invoke primary method using extension instance
           ext.sortExpression='Deliverable_Date__c';
            ext.strOrganizationName='abc';
           ext.getSortDirection();
            ext.setSortDirection('ASC');
           ext.LoadGraphics();
            ext.dupGDId= testGD22.id;
            

            ext.duplicateGD();
           
           ApexPages.Pagereference result=ext.createNewGraphics();
           
           result=ext.cancelGraphics();   
           
           result=ext.saveGraphics();
           
           result=ext.editGraphics();
            
           
           ext.deleteGDId=testGD1.id;
           
           ext.deleteGraphics();
           
           delete testGD2;
           
           delete testJob1;
           
           result=ext.saveGraphics();
           

        }// End of Test Coverage*/
   }
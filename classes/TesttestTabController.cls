//@isTest
Public class TesttestTabController{
/*
 
    // Test Coverage 
         static testMethod void TesttestTabController()
        {
             Job_Number_Setting__c customSetting001 = new  Job_Number_Setting__c(Name= 'yy');
              
                 insert customSetting001; 
             
              Graphics_Setting__c customGraphics= new Graphics_Setting__c(Name = 'YES');
              
                  insert customGraphics;
                  
              Session_Setting__c customSession= new Session_Setting__c(Name = 'YES');
                  
                  insert customSession;
                  
               Tag_Setting__c customTag = new Tag_Setting__c(Name = 'YES');
                   
                   insert customTag;   
                   
               Music_Usage_Setting__c  customMusic = new Music_Usage_Setting__c(Name = 'YES');  
                   
                    insert customMUsic;   
                  
               Media_Type__c testMedia=new Media_Type__c(Name='Test Media 301');
             
                     insert testMedia;
             
              Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 301',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
              Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 302',Media_Types__c=testMedia.Id);
             
                  insert testST1;
                 
              Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 301');
                insert testSpec;
                
                Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 302');
                insert testSpec1;
           
            
               Job__c testJob1=new Job__c(Name='Test Job 301',Flag__c=True,Job_Auto_Number__c='Job12347',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                   System.assert(e.getMessage().contains('Job with same name Exists'));
               }
               
               System.assertEquals('Test Job 301',testJob1.Name);
          
              // Instantiate the extention instance with the standard controller : Details Tab
              
              ApexPages.StandardController con1=new ApexPages.StandardController(testJob1);
              ApexPages.currentPage().getParameters().put('intFocus', '1');
              testTabController ext1=new testTabController(con1);
             
              // Instantiate the extention instance with the standard controller : Schedules Tab
              
              ApexPages.StandardController con2=new ApexPages.StandardController(testJob1);
              ApexPages.currentPage().getParameters().put('intFocus', '2');
              testTabController ext2=new testTabController(con2);
             
              // Instantiate the extention instance with the standard controller : Creative Brief Tab
              
              ApexPages.StandardController con3=new ApexPages.StandardController(testJob1);
              ApexPages.currentPage().getParameters().put('intFocus', '3');
              testTabController ext3=new testTabController(con3);
              
              // Instantiate the extention instance with the standard controller : Quotes Tab
              
              ApexPages.StandardController con4=new ApexPages.StandardController(testJob1);
              ApexPages.currentPage().getParameters().put('intFocus', '4');
              testTabController ext4=new testTabController(con4);
             
              // Instantiate the extention instance with the standard controller : Estimates Tab 
              
              ApexPages.StandardController con5=new ApexPages.StandardController(testJob1);
              ApexPages.currentPage().getParameters().put('intFocus', '5');
              testTabController ext5=new testTabController(con5);
             
              // Instantiate the extention instance with the standard controller : Purchase Order Tab
              
              ApexPages.StandardController con6=new ApexPages.StandardController(testJob1);
              ApexPages.currentPage().getParameters().put('intFocus', '6');
              testTabController ext6=new testTabController(con6);
              
              // Instantiate the extention instance with the standard controller : Invoices Tab
              
              ApexPages.StandardController con7=new ApexPages.StandardController(testJob1);
              ApexPages.currentPage().getParameters().put('intFocus', '7');
              testTabController ext7=new testTabController(con7);
             
              // Instantiate the extention instance with the standard controller : Notes Tab
              
              ApexPages.StandardController con8=new ApexPages.StandardController(testJob1);
              ApexPages.currentPage().getParameters().put('intFocus', '8');
              testTabController ext8=new testTabController(con8);
             
              // Instantiate the extention instance with the standard controller : Tags Tab
              
              ApexPages.StandardController con9=new ApexPages.StandardController(testJob1);
              ApexPages.currentPage().getParameters().put('intFocus', '9');
              testTabController ext9=new testTabController(con9);
              
              // Instantiate the extention instance with the standard controller : Sessions Tab
              
              ApexPages.StandardController con10=new ApexPages.StandardController(testJob1);
              ApexPages.currentPage().getParameters().put('intFocus', '10');
              testTabController ext10=new testTabController(con10);
              
               // Instantiate the extention instance with the standard controller : Graphics Deliverables Tab
              
              ApexPages.StandardController con11=new ApexPages.StandardController(testJob1);
              ApexPages.currentPage().getParameters().put('intFocus', '11');
              testTabController ext11=new testTabController(con11);
              
               // Instantiate the extention instance with the standard controller : Music Usage Tab
              
              ApexPages.StandardController con12=new ApexPages.StandardController(testJob1);
              ApexPages.currentPage().getParameters().put('intFocus', '12');
              testTabController ext12=new testTabController(con12);
              
              // Instantiate the extention instance with the standard controller : Graphics Deliverables Tab
              
              ApexPages.StandardController con13=new ApexPages.StandardController(testJob1);
              ApexPages.currentPage().getParameters().put('intFocus', '13');
              testTabController ext13=new testTabController(con11);
              
               // Instantiate the extention instance with the standard controller : Music Usage Tab
              
              ApexPages.StandardController con14=new ApexPages.StandardController(testJob1);
              ApexPages.currentPage().getParameters().put('intFocus', '14');
              testTabController ext14=new testTabController(con12);
            
                          ApexPages.StandardController con15=new ApexPages.StandardController(testJob1);
              ApexPages.currentPage().getParameters().put('intFocus', '15');
              testTabController ext15=new testTabController(con15);
            
                          ApexPages.StandardController con16=new ApexPages.StandardController(testJob1);
              ApexPages.currentPage().getParameters().put('intFocus', '16');
              testTabController ext16=new testTabController(con16);
              
              
              
              
              
              
        }    
        // End of Test Coverage
        */
        





}
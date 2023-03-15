public with sharing class emailWorkorderTeam {

   /* public emailWorkorderTeam(ApexPages.StandardController controller) {
    
        jobid = ApexPages.currentpage().getParameters().get('id');
        isError=False;
    }

    public boolean isError{get;set;}  
    public string jobid{get;set;}
    public String addresses;
    Public Blob b;
    list<string> st1 = new list<string>(); 
    
    public emailWorkorderTeam()
    {
      jobid = ApexPages.currentpage().getParameters().get('id');
      isError=False;
    }
    public pagereference send()
    {
        isError=False;
        PageReference pdf = Page.WorkOrder;
        jobid = ApexPages.currentpage().getParameters().get('id');
        pdf.getParameters().put('id',jobid);
        pdf.setRedirect(true);
        job__C j =[select Name,Job_Auto_Number__c,  id from job__c where id =:jobid WITH SECURITY_ENFORCED];        
        list<Job_Team__c> lstTeam = [select id,Name,Staff__c,Email__c from Job_Team__c where job__c = : jobid WITH SECURITY_ENFORCED];
        system.debug('****'+ lstTeam.size());
        list<string> st = new list<string>();
        for(Job_Team__c jst:lstTeam)
        {
          st1.add(jst.Email__c );
        }
        
      /*  list<Staff__c> lststaff = [select name,Email__c from Staff__c where name in :st  ];
        
        
        for(Staff__c jst:lststaff)
        {
            st1.add(jst.Email__c);
        }
        system.debug('****'+ st1);*
            
        // Take the PDF content and Create the email attachment
       if (!Test.IsRunningTest())  b = pdf.getContent();
         Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('Workorder.pdf');
        efa.setBody(b);
        // email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
       
        // Loop through the whole list of contacts and their emails
      
        
        if(st1.size() > 0)
         {
          addresses = st1[0];
            for (Integer i = 1; i < st1.size(); i++) {
                if (st1!= null)
                { 
                    addresses += ':' + st1[i];
                    system.debug('**********'+addresses);
                  }
            }
                String[] toAddresses = addresses.split(':', 0);
                system.debug('&&&&&&&&&&&&&&&'+toAddresses);
                //string email = 'shashi.cherukupally@yahoo.com';
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setUseSignature(false);
                mail.setToAddresses(toAddresses);
                mail.setSubject('Work Order for Job Name:'+j.name+', Job # :'+j.Job_Auto_Number__c);
                mail.setHtmlBody('Attached is a Work Order for your review.');
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { efa }); 
                // Send the email
        
                try
                {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
                //PageReference p =  new Pagereference('/apex/JobListView?id='+jobid+'&intFocus=1&checksucess=true');
                //p.setRedirect(true);
                //return p;
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info,'Mail sent Sucessfully!'));
                 return null;
                }
                catch(Exception e)
                {
                //isError=true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Messege Sending Failed'));
                return null;
                }
          }
          else
          {
            //isError=true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'No Team members avaliable'));
                return null;
          }
          
      
        
        
         
    }
    
    //test method 
  /*  static testMethod void Test_emailWorkorderTeam()
    {
    
        job__c testjob = New job__c(Name='testJob');
        insert testjob;
       
        staff__c staff = new Staff__c(Name='teststaff',Email__c='test@gmail.com',Role__c = 'Test Role',UserName__c='test@test.com');
        insert staff;
        staff__c staff1 = new Staff__c(Name='teststaff1',Email__c='test1@gmail.com', Role__c = 'Test Role1',UserName__c='test@test1.com');
        insert staff1;
        
        Staff__c testStaff=new Staff__c(Name='teststaff1',First_Name__c='Test Staff',Last_Name__c='001',Email__c='TestStaff001@SFDC.com',Username__c='TestStaff001@SFDC.com',User_Type__c='Staff');
        insert testStaff;
            

        
        Job_Team__c team = new Job_Team__c(Staff__c='teststaff',Job__c =testjob.id,Role__c='Test Role');
        insert team;
        Job_Team__c team1 = new Job_Team__c(Staff__c='teststaff1',Job__c =testjob.id,Role__c='Test Role1');
        insert team1;
        
        System.assertEquals('Test Staff',testStaff.First_Name__c);
        
        
         PageReference pref = Page.emailworkorder;
        pref.getParameters().put('id',testjob.id);
        Test.setCurrentPage(pref);
        
              
        emailWorkorderTeam con = new emailWorkorderTeam();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        con.b=bodyBlob; 
            
            
            
                
     
        //Test.startTest();
     
         System.assertEquals('testJob',testjob.Name);
     
        // populate the field with values
        ApexPages.currentPage().getParameters().put('id',testjob.id);
        con.addresses = 'test@noemail.com : test2@noemail.com';
        //con.st1 = 'test@noemail.com';
        //con.b = b1;
        // submit the record
        pref = con.send();
     
        //Test.stopTest(); 
    
     
    } */

}
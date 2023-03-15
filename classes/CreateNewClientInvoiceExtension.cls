/* This class is used to create a new client invoice */
  
public with sharing class CreateNewClientInvoiceExtension {
  
   //Global Variables
  /*  public String ClientName{get;set;}
    private final Client_Invoice__c ci;
    public String jobid{get;set;}
    public String jobName{get;set;}
     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
     }  
            
            
     public boolean isMob{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
    }  
    
    
   // Start Constructor
    public CreateNewClientInvoiceExtension(ApexPages.StandardController controller) {
       
       this.ci=(Client_Invoice__c)controller.getRecord();
       jobid=ApexPages.CurrentPage().getParameters().get('jobid');
       Job__c objJob=[Select id,name,JS_Client__r.name from Job__c where id=:jobid];
       jobName=objJob.Name;
       ci.Job__c = jobid;
       ClientName=objJob.JS_Client__r.name;
       ci.Client_Name__c = objJob.JS_Client__c;
    }

            
   // Save Method
    public PageReference saveme(){
     string strciId;
     try
     {
      insert ci;
      strciId = ci.id;
      }
     catch(DMLException e){return null;}
     
      PageReference p;
        if(isLtng)
        {
             p = new PageReference('/apex/ClientInvoiceDetailpageLightning?id='+strciId);
        }
        else
        {
              p = new PageReference('/apex/ClientInvoiceDetailpage?id='+strciId);
        }
      
      p.setRedirect(true);
      return p; 
    }              
       

   // Cancel Method
    Public PageReference cancelme()
    {
       
        PageReference p;
        if(isLtng)
        {
             p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobid+'&tab=Jobbilling');
        }
        else
        {
              p = new Pagereference('/apex/JobListView?id='+jobid+'&intFocus=13');
        }
      
       p.setRedirect(true);
       return p; 
    
                    
    }*/
              
   
}
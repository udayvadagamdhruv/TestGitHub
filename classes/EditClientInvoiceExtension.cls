public with sharing class EditClientInvoiceExtension {

   // Global Variables
  /*  private final Client_Invoice__c objCI;
    Public string strid;
     
    public Client_Invoice__c objCI1{get;set;}
    public String  ClientName;
    public String jobName{get;set;}
    public String getClientName() { return ClientName; }
    public void setClientName(String s) {  this.Clientname = s; }
    
      public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
    
     // End of Global variables 

    // Standard Controller Constructor
    public EditClientInvoiceExtension (ApexPages.StandardController con) 
    {
       this.objCI=(Client_Invoice__c)con.getrecord();
       strid = objCI.id;
       
       
        objCI1 = [SELECT id, name,Client_Name__c,Job__c,Job__r.Name FROM Client_Invoice__c WHERE id =: objCI.id WITH SECURITY_ENFORCED];
        jobName=objCI1.Job__r.Name;
        String st1 = objCI1.Client_Name__c;
        
        system.debug('st1 -----> ' + st1);
        
       
        if(String.isNotBlank(st1))
        {
            Client__c c=[Select id,Name from Client__c where id=: st1 WITH SECURITY_ENFORCED];
            ClientName= c.id; 
        }
        
        
       
       
    }
    // End of Standard Controller Constructor 
    
    
    public List<selectOption> getClients() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Client__c c : [SELECT Id, name FROM Client__c WITH SECURITY_ENFORCED order by Name]) 
        {  
            optionList.add(new selectOption(c.Id, c.Name));  
        }
        return optionList;  
    }

   
   
    // Method called on to Update Vendor /
  Public PageReference saveme()
    {
        try
        {
            if(schema.SobjectType.Client_Invoice__c.Fields.Client_Name__c.isUpdateable()){
                objCI.Client_Name__c=ClientName;
            }
            if(Schema.sObjectType.Client_Invoice__c.isUpdateable()) {
                update objCI;
            }
            
        }
        catch(System.DMLException e)
        {
            return null;
        }
        
         PageReference p;
         
        if(isLtng)
        {
              p =  new Pagereference('/apex/ClientInvoiceDetailpageLightning?id='+strid);
         
        }
        else
        {
          p=new Pagereference('/apex/ClientInvoiceDetailpage?id='+strid+'&intTabFocus=13');
           
        }
         
         p.setRedirect(true);
        return p;
         
       
    }  
    // End of Method Update Vendor 
  
    // Method called on to handle Cancel button 
    Public PageReference cancelme()
    {
       PageReference p;
         
        if(isLtng)
        {
              p =  new Pagereference('/apex/ClientInvoiceDetailpageLightning?id='+strid);
         
        }
        else
        {
           p =  new Pagereference('/apex/ClientInvoiceDetailpage?id='+strid+'&intTabFocus=13');
           
        }
         
         p.setRedirect(true);
        return p;
         
    } */

}
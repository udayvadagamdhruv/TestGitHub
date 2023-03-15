public with sharing class DisplayShippmentsunderjobtabext {

   /* // Global variables
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
    
    
    public string strID{get;set;}
    public String ciid{get;set;}
  //  public String shipId{get;set;}
    public List<Shipment__c> ShipmentEnt{get;set;} 
    Public String theID;
    
    

   // Start constructor
    public DisplayShippmentsunderjobtabext()
    {
        theID = ApexPages.CurrentPage().getParameters().get('id');
        ShipmentEnt= [select id,name,Job__c,Shipment_Status__c,Shipping_Method__c,Shipment_Name__c,Tracking_Number__c from Shipment__c where Job__c =: theID Order BY Name];
    }
    


    public PageReference CreateShippment()
    {
         String jobid;
         String theId=ApexPages.CurrentPage().getParameters().get('id');
         
         Job__c job = [Select Id from Job__c where id =: theID];
         jobid=job.Id;
       
       if(isLtng)
       {
            PageReference p = Page.CreateNewShipmentUnderJobLightning;
             p.setredirect(true);
             p.getParameters().put('jobid',theID); 
             return p;
       }
       else
       {
             PageReference p = Page.CreateNewShipmentUnderJob;
             p.setredirect(true);
             p.getParameters().put('jobid',theID); 
             return p;
       }
    }
     
    
    public PageReference save()
    {
          try
          {
             update ShipmentEnt;
          }
          catch(System.DMLException e)
          {
              return null;
          }
      
          PageReference p =  new Pagereference('/apex/JobListView?id='+theid+'&intFocus=16');
          p.setRedirect(true);
          return p; 
          
      
    }
    
    public PageReference editShipment() 
    {
        String jobid;
         String theId=ApexPages.CurrentPage().getParameters().get('id');
         
         Job__c job = [Select Id from Job__c where id =: theID];
         jobid=job.Id;
         System.Debug('CIID=======================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+ciid);
         
         
         
           if(isLtng)
           {
                 Pagereference p=new Pagereference('/apex/EditshipmentUnderJobTabLightning?id='+ciid);
                 p.setredirect(true);
                 p.getParameters().put('jobid',theID); 
                 return p;
           }
           else
           {
                 Pagereference p=new Pagereference('/apex/EditshipmentUnderJobTab?id='+ciid);
                 p.setredirect(true);
                 p.getParameters().put('jobid',theID); 
                 return p;
           }
         
         
         
        
    }
    
    
    //Method to Delete Client Invoice   
    public PageReference del()
    {
         System.Debug('CIID======================='+ciid);
         Shipment__c delci = [Select id,Name from Shipment__c where id =: ciid];
         if(Shipment__c.sObjectType.getDescribe().isDeletable()){
             delete delci;}
       
           if(isLtng)
           {
               PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+theid+'&tab=Jobcost'+'&section=shipment');
               p.setRedirect(true);
               return p;
           }
           else
           {
                 PageReference p =  new Pagereference('/apex/JobListView?id='+theid+'&intFocus=16');
                 p.setRedirect(true);
                 return p;
           }
        
      
       
    }
    

    //Method For Cancel button    
     public PageReference cancelme()
     {
        PageReference p =  new Pagereference('/apex/JobListView?id='+theid+'&intFocus=16');
        p.setRedirect(true);
        return p;     
        
     }
*/
    
}
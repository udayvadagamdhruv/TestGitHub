public with sharing class DisplayClientInvoiceLIController {

    // Global variables 
    
  /*  public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
     }  
    
        Public String theID;
        public List<Client_Invoice_Line_Item__c> CILI{get;set;} 
        public String strCILI{get;set;}
        Public Boolean ShowProductionEstimate{get;set;}
       
       public map<string,list<Client_Invoice_Line_Item__c>> MapPE{get;set;}
        
    // Start Constructor 
     public DisplayClientInvoiceLIController () 
      {
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate =activeSettings.Active__c;
             
        theID = ApexPages.CurrentPage().getParameters().get('id');
        CILI=[select id,Name,Equipment_Type__c,PE_Template__c,Tax__c,Client_Invoice__c,Estimate_Line_Item__c,Production_Estimate__c,Billable_Amount__c,Quantity__c,GL_Code__c,GL_Code_No__c,Unit_Type__c from Client_Invoice_Line_Item__c where Client_Invoice__c =: theID ORDER BY Sort_Order__c];
     
           MapPE = new map<string,list<Client_Invoice_Line_Item__c>>();
         
         for(Client_Invoice_Line_Item__c JS:CILI)
         {
               if(MapPE.containsKey(js.PE_Template__c))
               {
                  List <Client_Invoice_Line_Item__c> CLIlist =  MapPE.get(js.PE_Template__c);
                  CLIlist.add(js);
                  MapPE.put(js.PE_Template__c,CLIlist);  
                }
                else
                {
                  MapPE.put(js.PE_Template__c, new List<Client_Invoice_Line_Item__c>{js}) ;
                }   
         
         }
     
      }
   
    // THis methos is called on to Add Estimate Line Item
        public PageReference add_ELI()
        {
        PageReference p;
        if(isLtng)
        {
            p =  Page.addELineItemToCILineItemLightning;
        }
        else{
            p =  Page.addELineItemToCILineItem;
        }
            p.setRedirect(true);
            p.getParameters().put('id',theID);
            return p;
        }
        
        
   // This methos is called on to Add Production Estimate Line Item
        public PageReference add_PELI()
        {
        PageReference p;
        if(isLtng)
        {
            p =  Page.addPELineItemToCILineItemLightning;
        }
        else{
            p =  Page.addPELineItemToCILineItem;
        }
            
            p.setRedirect(true);
            p.getParameters().put('id',theID);
            return p;
        }
        
  // This method is called on to handle delete Client Invoice Line Item
         public Pagereference deleteCILI()
         {
             Client_Invoice_Line_Item__c objCILI=[Select id,Client_Invoice__c,Estimate_Line_Item__c from Client_Invoice_Line_Item__c where id=:strCILI];
               Id CIid=objCILI.Client_Invoice__c;
               Id estId=objCILI.Estimate_Line_Item__c;
               if(Client_Invoice_Line_Item__c.sObjectType.getDescribe().isDeletable()){
                   Database.Delete(objCILI);
               }
          
                    
           
               // After deletion, navigate to CI Detail Page
               Pagereference p;
               if(isLtng)
               p=new Pagereference('/apex/ClientInvoiceDetailPageLightning?id='+theID+'&section=estimatelinetems');
               else
               p=new Pagereference('/apex/ClientInvoiceDetailPage?id='+theID);
               p.setRedirect(true);
               return p;
         }
         

  // This is save method
       public PageReference save(){
         
      try
      {
       update CILI;
      }
     catch(System.DMLException e){return null;}
      
              Pagereference p;
               if(isLtng)
               p=new Pagereference('/apex/ClientInvoiceDetailPageLightning?id='+theID+'&section=estimatelinetems');
               else
               p=new Pagereference('/apex/ClientInvoiceDetailPage?id='+theID);
               p.setRedirect(true);
               return p;
      
       
    }
    
    
  //Method For Cancel button    
     public PageReference cancelme()
       {
        PageReference p =  new Pagereference('/apex/ClientInvoiceDetailPage?id='+theID);
        p.setRedirect(true);
        return p;     
       }*/
    
    
}
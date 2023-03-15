public with sharing class addELineItemToCILineItem {

 //Global variables
    public String CIid{get;set;}
    public List<ELIWrapper> rolewraps{get;set;}
    Public Set<String> ELINameELI =new Set<String>();
    public List<Client_Invoice_Line_Item__c> lstCLI{get;set;}
    public List<Client_Invoice_Line_Item__c> lst{get;set;}
    public List<Estimate_Line_Items__c> ELIlst{get;set;}
    public ScheduleTaskRole__c stc;
    String strSTId,strid;
    Client_Invoice__c C = new Client_Invoice__c();
    Map<String,Client_Invoice_Line_Item__c> CLIMap = new Map<String,Client_Invoice_Line_Item__c>();
    public List<Client_Invoice_Line_Item__c> AddCLIList;
    
 // Start Constructor 
   public addELineItemToCILineItem()
   {
       CIid = ApexPages.currentPage().getParameters().get('id');
       roleWraps=new List<ELIWrapper>();
    
       C= [Select id,Name,Job__c from Client_Invoice__c where id =: CIid];
       
       lstCLI=[Select Id,name,Estimate_Line_Item__c,Estimate_Line_Item__r.name from Client_Invoice_Line_Item__c where Client_Invoice__c =:CIid order by CreatedDate];
       system.debug('============'+lstCLI.size());
       List<Estimate_Line_Items__c> ELI=[Select id,Name,Amount__c,Vendor__c,Job__c,Approved__c,Total_Amount__c,GL_Code__c, Quantity__c, Unit_Type__c From Estimate_Line_Items__c where  Job__c =: C.Job__c and Approved__c = true  Order By Name];
       
       if(!ELI.isEmpty()){
            Set<string> ELINameSet = new Set<String>();
            for(Client_Invoice_Line_Item__c ClientLI : lstCLI){
                ELINameSet.add(ClientLI.Estimate_Line_Item__r.name);
                CLIMap.put(ClientLI.Estimate_Line_Item__r.name,ClientLI);
            }
       
       
       for(Estimate_Line_Items__c e: ELI)
       {
         if(!ELINameSet.contains(e.name))
         roleWraps.add(new ELIWrapper(e));
         else{
             
            ELIWrapper rw=new ELIWrapper(e);rw.checked=True;roleWraps.add(rw);ELINameELI.add(e.name); }
               //rw.e=e;
            
       }
       
    }   
   }
   

 // Start Wrapper Class 
     public class ELIWrapper
     {
           public Estimate_Line_Items__c e{get;set;}
           public Boolean checked{get;set;}
           
         public ELIWrapper(Estimate_Line_Items__c e){
          this.e = e;
          checked=false;
        }
     }
     

 // Save Method
    public pagereference Save()
     {
      /* 
        lst=new List<Client_Invoice_Line_Item__c>();
        for(ELIWrapper rw:roleWraps)
         {
           
            if(rw.checked==true)
            {
                Client_Invoice_Line_Item__c stRole=new Client_Invoice_Line_Item__c();
                stRole.Estimate_Line_Item__c=rw.e.id;
                stRole.Billable_Amount__c=rw.e.Total_Amount__c;
                stRole.GL_Code__c=rw.e.GL_Code__c;
                stRole.Client_Invoice__c=ApexPages.currentPage().getParameters().get('id');
                lst.add(stRole);
            }
         }
         System.debug('Inserted value @@@ '+lst);
         insert lst;
   
        PageReference p =  new Pagereference('/apex/ClientInvoiceDetailPage?id='+CIid);
        p.setRedirect(true);
        return p; */
        
        if(!roleWraps.isEmpty()){
        AddCLIList = new List<Client_Invoice_Line_Item__c>();
        List<Client_Invoice_Line_Item__c> deleteCLIList = new List<Client_Invoice_Line_Item__c>();
        for(ELIWrapper apw:roleWraps){
        boolean existing = ELINameELI.contains(apw.e.name);
        if(apw.checked == True){ if(!existing) AddCLIList.add(new Client_Invoice_Line_Item__c(Client_Invoice__c=ApexPages.currentPage().getParameters().get('id'),GL_Code__c=apw.e.GL_Code__c,Quantity__c=apw.e.Quantity__c, Billable_Amount__c=apw.e.Total_Amount__c,Estimate_Line_Item__c=apw.e.id));   
                 }else if(existing){
        if(CLIMap.containsKey(apw.e.name)){Client_Invoice_Line_Item__c objJTR = CLIMap.get(apw.e.name); 
        deleteCLIList.add(objJTR);}
        }
        
       }
    if(!AddCLIList.isEmpty()){ if (!Client_Invoice_Line_Item__c.sObjectType.getDescribe().isCreateable()){ ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
          }else{ insert AddCLIList;} 
         }
        
          if(!deleteCLIList.isEmpty()){ if (!Client_Invoice_Line_Item__c.sObjectType.getDescribe().isDeletable()){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access'));
           }
      else{ delete deleteCLIList;} 
                  }
            }
    String theme = UserInfo.getUITheme();
     PageReference p;
   if(theme=='Theme4d')
     p =  new Pagereference('/apex/ClientInvoiceDetailpageLightning?id='+CIid+'&section=estimatelinetems');
      else
     p =  new Pagereference('/apex/ClientInvoiceDetailpageSwitchPage?id='+CIid);
      p.setRedirect(true);
      return p;
 }
 // End of Save Method
 
 // Method called on to handle Back Button
   public pagereference Back()
  {
   String theme = UserInfo.getUITheme();
   PageReference p;
   if(theme=='Theme4d')
     p =  new Pagereference('/apex/ClientInvoiceDetailpageLightning?id='+CIid+'&section=estimatelinetems');
      else
     p =  new Pagereference('/apex/ClientInvoiceDetailpageSwitchPage?id='+CIid);
      p.setRedirect(true);
      return p;
  }
  // End of Back


}
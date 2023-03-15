/* Displaying Client invoice under job tab */

public with sharing class DisplayClientInvoiceunderjobtabextension {

   // Global variables
  /*  public string strID{get;set;}
    public String ciid{get;set;}
    public List<Client_Invoice__c> ClientInvoice{get;set;} 
    public List<Client_Invoice__c> ClientInvoice2{get;set;} 
    Public String theID;
    
    public boolean ViewAll{get; set;}
    public boolean ShowLess{get; set;}
    
    
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
    
      public integer CIrowIndex {set;get;}
      public list<inlineWrapperCI> clientinvlst {set;get;}
      public string editCIField {set;get;}

   // Start constructor
    public DisplayClientInvoiceunderjobtabextension()
    {
        ViewAll=True;
        ShowLess=False;
       
        theID = ApexPages.CurrentPage().getParameters().get('id');
        ClientInvoice = [Select id,Invoice_Total_new__c,Name,Client_Name__c,Date_Due__c,Invoice_Date__c,Invoice_Status__c,Invoice_Total__c,Job__c,Notes__c,Term__c from Client_Invoice__c where Job__c =: theID Order BY  CreatedDate desc,Name LIMIT:5];
        ClientInvoice2 = [Select id,Invoice_Total_new__c,Name,Client_Name__c,Date_Due__c,Invoice_Date__c,Invoice_Status__c,Invoice_Total__c,Job__c,Notes__c,Term__c from Client_Invoice__c where Job__c =: theID Order BY CreatedDate desc,Name];
      
       clientinvlst=new list<inlineWrapperCI>();
       
     for(integer i=0;i<ClientInvoice.size();i++){
       inlineWrapperCI inCIobj=new inlineWrapperCI();
         inCIobj.CIrec=ClientInvoice[i];
         inCIobj.CIrowNo=i;         
         inCIobj.isEditCIInvDt=false;
         inCIobj.isEditCIDueDt=false;
         inCIobj.isEditCIStatus=false;
         clientinvlst.add(inCIobj);
       }
       
    }
    
    
     public PageReference inlineEditCI(){
    
     if(editCIField =='InvoiceDate'){
         clientinvlst[CIrowIndex].isEditCIInvDt=true;
       }
     if(editCIField =='DueDate'){
         clientinvlst[CIrowIndex].isEditCIDueDt=true;
       }
     if(editCIField=='Status'){
         clientinvlst[CIrowIndex].isEditCIStatus=true;
       }
    return null;
    }
    
    
    public PageReference inlineSaveCI(){
    
   try{
        if(editCIField=='InvoiceDate'){
           update clientinvlst[CIrowIndex].CIrec;
           clientinvlst[CIrowIndex].isEditCIInvDt=false;
           }
       if(editCIField=='DueDate'){
           update clientinvlst[CIrowIndex].CIrec;
           clientinvlst[CIrowIndex].isEditCIDueDt=false;
           }
       if(editCIField=='Status'){
           update clientinvlst[CIrowIndex].CIrec;
           clientinvlst[CIrowIndex].isEditCIStatus=false;
           }
     }
     catch(System.DMLException e){
        return null;
     }
       return null;
    }
    
    
    
     public class inlineWrapperCI{
     public Client_Invoice__c CIrec {get; set;}
     public integer CIrowNo          {get; set;}
     public boolean isEditCIInvDt    {get; set;}
     public boolean isEditCIDueDt    {get; set;}
     public boolean isEditCIStatus   {get; set;}
    
    }
     
  
    Public void ViewAllClientInvoice()
    {
        ViewAll=False;
        ShowLess=True;
        
        ClientInvoice = [Select id,Invoice_Total_new__c,Name,Client_Name__c,Date_Due__c,Invoice_Date__c,Invoice_Status__c,Invoice_Total__c,Job__c,Notes__c,Term__c from Client_Invoice__c where Job__c =: theID Order BY CreatedDate desc,Name];
        
       clientinvlst.clear();
       for(integer i=0;i<ClientInvoice.size();i++){
       inlineWrapperCI inCIobj=new inlineWrapperCI();
         inCIobj.CIrec=ClientInvoice[i];
         inCIobj.CIrowNo=i;         
         inCIobj.isEditCIInvDt=false;
         inCIobj.isEditCIDueDt=false;
         inCIobj.isEditCIStatus=false;
         clientinvlst.add(inCIobj);
       }
    }
    
    Public void ShowLessClientInvoice()
    {
        ViewAll=True;
        ShowLess=False;
        
        ClientInvoice = [Select id,Invoice_Total_new__c,Name,Client_Name__c,Date_Due__c,Invoice_Date__c,Invoice_Status__c,Invoice_Total__c,Job__c,Notes__c,Term__c from Client_Invoice__c where Job__c =: theID Order BY CreatedDate desc,Name LIMIT:5];
       clientinvlst.clear();
       for(integer i=0;i<ClientInvoice.size();i++){
       inlineWrapperCI inCIobj=new inlineWrapperCI();
         inCIobj.CIrec=ClientInvoice[i];
         inCIobj.CIrowNo=i;         
         inCIobj.isEditCIInvDt=false;
         inCIobj.isEditCIDueDt=false;
         inCIobj.isEditCIStatus=false;
         clientinvlst.add(inCIobj);
       }
   } 
     
     
     
     
        Sobject sumCash; 

   // This method is called on to calculate Total Amount of Client Invoice
   public double getSumCash()
   { 
        sumCash = [SELECT SUM(Invoice_Total_new__c) sum FROM Client_Invoice__c WHERE Job__c =: [Select id from Job__c where id =: theID]];   
        return double.valueOf(sumCash.get('sum')); 
    }  
   
    //Method to Create Client Invoice
     public PageReference CreateCI()
    {
         String jobid;
         String theId=ApexPages.CurrentPage().getParameters().get('id');
         
         Job__c job = [Select Id from Job__c where id =: theID];
         jobid=job.Id;
       
        if(isLtng)
        {
              PageReference p = Page.CreateNewClientInvoiceLightning;
              p.setredirect(true);
              p.getParameters().put('jobid',theID); 
              return p;
        }
        else
        {
                PageReference p = Page.CreateNewClientInvoice;
                p.setredirect(true);
                p.getParameters().put('jobid',theID); 
                return p;
        }
      
    }
     
    
    //Method for Inline Save Method    
    public PageReference save()
    {
     try
      {
       update ClientInvoice2;
      }
     catch(System.DMLException e){return null;}
     
           
      
      // After updating CI, navigate to Client Invoice Tab
       PageReference p;
        if(isLtng)
        {
             p =  new Pagereference('/apex/JobdetailpageLightening07?id='+theid+'&tab=Jobbilling');
        }
        else
        {
              p =  new Pagereference('/apex/JobListView?id='+theid+'&intFocus=13');
        }
      
      p.setRedirect(true);
      return p; 
      
      
      
      
    }
    
    
    //Method to Delete Client Invoice   
    public void del()
    {
       System.Debug('CIID======================='+ciid);
       Client_Invoice__c delci = [Select id,Name from Client_Invoice__c where id =: ciid];
        if(Client_Invoice__c.sObjectType.getDescribe().isDeletable()){
            delete delci; 
        }
        
         // After deleting ci, navigate to Client Invoice Tab
    /*     PageReference p;
        if(isLtng)
        {
             p =  new Pagereference('/apex/JobdetailpageLightening07?id='+theid+'&tab=Jobbilling');
        }
        else
        {
              p =  new Pagereference('/apex/JobListView?id='+theid+'&intFocus=13');
        }
      
      p.setRedirect(true);
      return p; 
    *
     
   if(ViewAll){
       ClientInvoice = [Select id,Invoice_Total_new__c,Name,Client_Name__c,Date_Due__c,Invoice_Date__c,Invoice_Status__c,Invoice_Total__c,Job__c,Notes__c,Term__c from Client_Invoice__c where Job__c =: theID Order BY  CreatedDate desc,Name LIMIT:5];
       ClientInvoice2 = [Select id,Invoice_Total_new__c,Name,Client_Name__c,Date_Due__c,Invoice_Date__c,Invoice_Status__c,Invoice_Total__c,Job__c,Notes__c,Term__c from Client_Invoice__c where Job__c =: theID Order BY CreatedDate desc,Name];
       
       clientinvlst.clear();
       for(integer i=0;i<ClientInvoice.size();i++){
       inlineWrapperCI inCIobj=new inlineWrapperCI();
         inCIobj.CIrec=ClientInvoice[i];
         inCIobj.CIrowNo=i;         
         inCIobj.isEditCIInvDt=false;
         inCIobj.isEditCIDueDt=false;
         inCIobj.isEditCIStatus=false;
         clientinvlst.add(inCIobj);
       }
      }
      
    else{
      ClientInvoice = [Select id,Invoice_Total_new__c,Name,Client_Name__c,Date_Due__c,Invoice_Date__c,Invoice_Status__c,Invoice_Total__c,Job__c,Notes__c,Term__c from Client_Invoice__c where Job__c =: theID Order BY  CreatedDate desc,Name];
      ClientInvoice2=ClientInvoice;
      clientinvlst.clear();
       for(integer i=0;i<ClientInvoice.size();i++){
       inlineWrapperCI inCIobj=new inlineWrapperCI();
         inCIobj.CIrec=ClientInvoice[i];
         inCIobj.CIrowNo=i;         
         inCIobj.isEditCIInvDt=false;
         inCIobj.isEditCIDueDt=false;
         inCIobj.isEditCIStatus=false;
         clientinvlst.add(inCIobj);
       }
      }
    }
    

    //Method For Cancel button    
     public PageReference cancelme()
     {
          PageReference p;
        if(isLtng)
        {
             p =  new Pagereference('/apex/JobdetailpageLightening07?id='+theid+'&tab=Jobbilling');
        }
        else
        {
              p =  new Pagereference('/apex/JobListView?id='+theid+'&intFocus=13');
        }
      
      p.setRedirect(true);
      return p;     
        
     }*/
      

}
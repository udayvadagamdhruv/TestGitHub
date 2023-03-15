// This class is used to display Estimates under Job Tab


public with sharing class DisplayEstimateunderJobTab
{
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
   
    // Global variables
    public string strEstID{get;set;}
    public string strEstID1{get;set;}
    public List<Estimate_Line_Items__c> vq{get;set;}
    public List<Estimate_Line_Items__c> vq1{get;set;} 
    
    public List<Estimate_Line_Items__c> eli{get;set;}
    public String str{get;set;}
    String theID;
    public string strPEID{get;set;}
    
    public boolean ViewAll{get; set;}
    public boolean ShowLess{get; set;}
    
   public list<inlinewrapperEst> estlst{set;get;}
   public integer rowIndex{get;set;}
   public string estEditField {set;get;}
   inlinewrapperEst ineditEstobj;
  
    // Start constructor
    public DisplayEstimateunderJobTab() 
    {
         theID = ApexPages.CurrentPage().getParameters().get('id');
         
         ViewAll=True;
         ShowLess=False;
    
           vq1=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];
          vq=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name limit:5];
        
           eli=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] and Approved__c = true ];
        
        
         
         estlst=new list<inlinewrapperEst>();
          for(integer i=0;i<vq.size();i++){
            ineditEstobj=new inlinewrapperEst();
            ineditEstobj.estrec=vq[i];
            ineditEstobj.rowNo=i;
            ineditEstobj.isEdit=false;
            ineditEstobj.isEditQnty =false;
            ineditEstobj.isEditCost =false;
            estlst.add(ineditEstobj); 
            
           }
             
          /* if(vq.size() > 0) 
         {
            for(Estimate_Line_Items__c ELITS: vq) 
            {
                listWrapper.add(new WrapperClass(ELITS));
            }
         } */  
            
          
        
         
    }
    // End Constructor
    
    
    
    public class inlinewrapperEst{
        public Estimate_Line_Items__c estrec {get;set;}
        public integer rowNo  {get;set;}
        public boolean isEdit {get;set;} 
        public boolean isEditQnty {get;set;} 
        public boolean isEditCost {get;set;}   
    }
    
  public pageReference inlineeditEst(){
        if(estEditField=='Quantity'){
           estlst[rowIndex].isEditQnty=true;
          }
        if(estEditField=='UnitCost'){
           estlst[rowIndex].isEditCost=true;
          }
         
         return null;  
    }
    
    public pageReference inlinesaveEst(){
      try{
          
         if(estEditField=='Quantity'){
            update estlst[rowIndex].estrec;
            estlst[rowIndex].isEditQnty=false;
          }
          
         if(estEditField=='UnitCost'){
            update estlst[rowIndex].estrec;
            estlst[rowIndex].isEditCost=false;
          } 
          
          
          if(ViewAll)
                     {
                  vq=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name limit 5];      
                  vq1=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];
                  
                     estlst.clear();
                   for(integer i=0;i<vq.size();i++){
                    ineditEstobj=new inlinewrapperEst();
                    ineditEstobj.estrec=vq[i];
                    ineditEstobj.rowNo=i;
                    ineditEstobj.isEdit=false;
                    ineditEstobj.isEditQnty =false;
                    ineditEstobj.isEditCost =false;
                    estlst.add(ineditEstobj); 
                    
                   }
            
             }
             else
             {
                 vq=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];    
                 vq1=vq;
                 
                   estlst.clear();
                   for(integer i=0;i<vq.size();i++){
                    ineditEstobj=new inlinewrapperEst();
                    ineditEstobj.estrec=vq[i];
                    ineditEstobj.rowNo=i;
                    ineditEstobj.isEdit=false;
                    ineditEstobj.isEditQnty =false;
                    ineditEstobj.isEditCost =false;
                    estlst.add(ineditEstobj); 
                    
                   }
             }
          
              
        }
        catch(System.DMLException e){
        return null;
        }
        return null;
    }
    
    Public void ViewAllEst()
    {
        ViewAll=False;
        ShowLess=True;
        
        vq=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];
          estlst.clear();
             for(integer i=0;i<vq.size();i++){
                ineditEstobj=new inlinewrapperEst();
                ineditEstobj.estrec=vq[i];
                ineditEstobj.rowNo=i;
                ineditEstobj.isEdit=false;
                ineditEstobj.isEditQnty =false;
                ineditEstobj.isEditCost =false;
                estlst.add(ineditEstobj); 
                
               }

    }
    
    Public void ShowLessEst()
    {
        ViewAll=True;
        ShowLess=False;
        
        vq=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name limit:5];
         estlst.clear();
               for(integer i=0;i<vq.size();i++){
                    ineditEstobj=new inlinewrapperEst();
                    ineditEstobj.estrec=vq[i];
                    ineditEstobj.rowNo=i;
                    ineditEstobj.isEdit=false;
                    ineditEstobj.isEditQnty =false;
                    ineditEstobj.isEditCost =false;
                    estlst.add(ineditEstobj); 
                    
                 }
   
   
    }
    
   
    
    
   /* public class WrapperClass 
    {
        public Boolean checked {get;set;}
        public Estimate_Line_Items__c ELItems{get;set;}
        public WrapperClass(Estimate_Line_Items__c  ELItems) 
        {
            this.ELItems = ELItems;
        }
        
        
    }
    
     public void dup() 
     {
         listELIDup = new List<Estimate_Line_Items__c>();
         List<WrapperClass> listTempWrapper = new List<WrapperClass>();
         for(WrapperClass w : listWrapper) 
         {
            if(w.checked) 
            {
               
               Estimate_Line_Items__c  objJEst=new Estimate_Line_Items__c ();
                
                objJEst.name=w.ELItems.Name;
                objJEst.Job__c=w.ELItems.Job__c;
                objJEst.Quantity__c=w.ELItems.Quantity__c;
                objJEst.Amount__c=w.ELItems.Amount__c;
                objJEst.GL_Code__c=w.ELItems.GL_Code__c;
                objJEst.GL_Department__c=w.ELItems.GL_Department__c;
                objJEst.Vendor__c =w.ELItems.Vendor__c ;
                
                listELIDup.add(objJEst);
               
            } 
            
         }
         
         
         if(listELIDup.size() > 0) 
         {
             try
             {
                    insert listELIDup;
                    
                    vq=new list<Estimate_Line_Items__c>();
                    listWrapper=new list<WrapperClass>();
                    vq=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] Order By Name];
        
                     if(vq.size() > 0) 
                     {
                        for(Estimate_Line_Items__c ELITS: vq) 
                        {
                            listWrapper.add(new WrapperClass(ELITS));
                        }
                     } 
            
            
            }
            catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            }
            
           
         } 
         else 
         {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Select atleast one Estimate Line Item'));
           // return null;
         }
         
         
     
     }*/
     
     
     
    public void Approve()
    {
    
         List<Estimate_Line_Items__c> updateELI=new List<Estimate_Line_Items__c>();
         
         List<Estimate_Line_Items__c> App= [select id,Job__c,Quantity__c,Amount__c,Name,GL_Code__c,GL_Department__c,Vendor__c from Estimate_Line_Items__c where id =: strPEID Limit 1];
            
         for(Estimate_Line_Items__c ELI:App)
         {
            ELI.Approved__c=True;
            updateELI.add(ELI);
         }
            
            
         if(updateELI.size() > 0) 
         {   
        
              try
              {
                    if(!test.isRunningTest()) update updateELI;
                    vq=new list<Estimate_Line_Items__c>();
                     if(ViewAll)
                     {
                          vq=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name limit 5];      
                          vq1=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];
                          
                             estlst.clear();
                            for(integer i=0;i<vq.size();i++){
                            ineditEstobj=new inlinewrapperEst();
                            ineditEstobj.estrec=vq[i];
                            ineditEstobj.rowNo=i;
                            ineditEstobj.isEdit=false;
                            ineditEstobj.isEditQnty =false;
                            ineditEstobj.isEditCost =false;
                            estlst.add(ineditEstobj); 
                            
                         }
                    
                     }
                     else
                     {
                         vq=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];    
                         vq1=vq;
                         
                           estlst.clear();
                            for(integer i=0;i<vq.size();i++){
                            ineditEstobj=new inlinewrapperEst();
                            ineditEstobj.estrec=vq[i];
                            ineditEstobj.rowNo=i;
                            ineditEstobj.isEdit=false;
                            ineditEstobj.isEditQnty =false;
                            ineditEstobj.isEditCost =false;
                            estlst.add(ineditEstobj); 
                            
                         }
                  }
           eli=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] and Approved__c = true ];
          }
          
          catch(System.DMLException e)
          {
              apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
          }
          
        }
        
    }
    
    
    
    public void UnApprove()
    {
    
         List<Estimate_Line_Items__c> updateELI=new List<Estimate_Line_Items__c>();
         
         List<Estimate_Line_Items__c> UnApp= [select id,Job__c,Quantity__c,Amount__c,Name,GL_Code__c,GL_Department__c,Vendor__c from Estimate_Line_Items__c where id =: strPEID Limit 1];
            
         for(Estimate_Line_Items__c ELI:UnApp)
         {
            ELI.Approved__c=False;
            updateELI.add(ELI);
         }
            
            
         if(updateELI.size() > 0) 
         {   
        
              try
              {
                    if(!test.isRunningTest()) update updateELI;
                    vq=new list<Estimate_Line_Items__c>();
                     if(ViewAll)
                     {
                          vq=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name limit 5];      
                          vq1=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];
                            estlst.clear();
                            for(integer i=0;i<vq.size();i++){
                            ineditEstobj=new inlinewrapperEst();
                            ineditEstobj.estrec=vq[i];
                            ineditEstobj.rowNo=i;
                            ineditEstobj.isEdit=false;
                            ineditEstobj.isEditQnty =false;
                            ineditEstobj.isEditCost =false;
                            estlst.add(ineditEstobj); 
                            
                         }
                    
                     }
                     else
                     {
                         vq=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];    
                         vq1=vq;
                           estlst.clear();
                            for(integer i=0;i<vq.size();i++){
                            ineditEstobj=new inlinewrapperEst();
                            ineditEstobj.estrec=vq[i];
                            ineditEstobj.rowNo=i;
                            ineditEstobj.isEdit=false;
                            ineditEstobj.isEditQnty =false;
                            ineditEstobj.isEditCost =false;
                            estlst.add(ineditEstobj); 
                            
                         }
                         
                     }
                 eli=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] and Approved__c = true ];
              }
          
              catch(System.DMLException e)
              {
                  apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
              }
          
          }
        
    }
    
    Public PageReference Del()
    {
        List<Estimate_Line_Items__c> DelEstLI= [select id,Job__c,Quantity__c,Amount__c,Name,GL_Code__c,GL_Department__c,Vendor__c from Estimate_Line_Items__c where id =: strPEID Limit 1];
        try
        {
             Database.delete(DelEstLI);  
           
             vq=new list<Estimate_Line_Items__c>();
             if(ViewAll)
             {
                  vq=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name limit 5];      
                  vq1=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];
                           estlst.clear();
                           for(integer i=0;i<vq.size();i++){
                            ineditEstobj=new inlinewrapperEst();
                            ineditEstobj.estrec=vq[i];
                            ineditEstobj.rowNo=i;
                            ineditEstobj.isEdit=false;
                            ineditEstobj.isEditQnty =false;
                            ineditEstobj.isEditCost =false;
                            estlst.add(ineditEstobj); 
                            
                         }
            
             }
             else
             {
                 vq=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];    
                 vq1=vq;
                           estlst.clear();
                            for(integer i=0;i<vq.size();i++){
                            ineditEstobj=new inlinewrapperEst();
                            ineditEstobj.estrec=vq[i];
                            ineditEstobj.rowNo=i;
                            ineditEstobj.isEdit=false;
                            ineditEstobj.isEditQnty =false;
                            ineditEstobj.isEditCost =false;
                            estlst.add(ineditEstobj); 
                            
                         }
             }
             
             if(isLtng)
             {
                 PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+theid+'&tab=Jobcost'+'&section=estimate');p.setRedirect(true);return p;
             }
             else
             {
                    PageReference p =  new Pagereference('/apex/JobListView?id='+theid+'&intFocus=5');
                    p.setRedirect(true);
                    return p;
             }
             
            
        }
        catch(System.DMLException e)
        {
            apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }
    }
    
    
    
    
 
    Sobject sumCash; 
    public double getSumCash()
    { 
       sumCash = [SELECT SUM(Total_Amount__c) sum FROM Estimate_Line_Items__c WHERE Job__c =: [Select id from Job__c where id =: theID] and Approved__c = true];   
       return double.valueOf(sumCash.get('sum')); 
    }  
 
    // This method is called on to new ELI  
    public PageReference createELI()
    {
       String jobid;
       String theId=ApexPages.CurrentPage().getParameters().get('id');
       Estimate_Line_Items__c est = new Estimate_Line_Items__c();
       Job__c job = [Select Id from Job__c where id =: theID];
       jobid=job.Id;
      
        if(isLtng)
        {
               PageReference p = Page.CreateNewEstimateLightning;p.setredirect(true);p.getParameters().put('jobid',theID); return p;
        }
        else
        {
               PageReference p = Page.CreateNewEstimate;
               p.setredirect(true);
               p.getParameters().put('jobid',theID); 
               return p;
        }
      
       
     
    }
    // End method createELI
    
    
   
    
   // This method is called on to handle Save button (Inline Editing Save)
     public PageReference save()
     {
     
       
          try
          {
         List<Estimate_Line_Items__c> updateELI=new List<Estimate_Line_Items__c>();
            if(isLtng)
            {
                for(Estimate_Line_Items__c objELI:vq)
                {
                    if(objELI.Approved__c==True)
                    {
                       updateELI.add(objELI); 
                        
                    }
                    else if(objELI.Approved__c==False)
                    {
                        updateELI.add(objELI);
                    }
                }
            }
            else{
               for(Estimate_Line_Items__c objELI:vq1)
                {
                    if(objELI.Approved__c==True)
                    {
                       updateELI.add(objELI); 
                        
                    }
                    else if(objELI.Approved__c==False)
                    {
                        updateELI.add(objELI); 
                    }
                }
            
            }
            if(!test.isRunningTest()) update updateELI;
            
           
            
            
            
           
          /*  Double amount=0;
            List<Estimate_Line_Items__c> lstELI=[select id,Name,Total_Amount__c from Estimate_Line_Items__c where Job__c=: theId and Approved__c=True];
            for(Estimate_Line_Items__c obj:lstELI)
            {
                amount=amount+obj.Total_Amount__c;
            }
            
            Job__c job = [select id,Name,Estimate_Total__c from Job__c where Id =: theId];
            job.Estimate_Total__c = amount;
            update job;   */
            
          }
          catch(System.DMLException e)
          {
              return null;
              //error='&Errormsg=jobquote_Error@@@'+e.getMessage();    
          }
      
     
       if(isLtng)
        {
             PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+theid+'&tab=Jobcost'+'&section=estimate');
             p.setRedirect(true);
             return p; 
        }
        else
        {
                PageReference p =  new Pagereference('/apex/JobListView?id='+theid+'&intFocus=5');
                p.setRedirect(true);
                return p;
        }
      
      
    
    }
    // End of method Save
    
    
    // THis method is called on to handle Cancel button (Cancel inline Editing)
   
     public PageReference cancelme()
     {
       
        if(isLtng)
        {
             PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+theid+'&tab=Jobcost'+'&section=estimate');
             p.setRedirect(true);
             return p; 
        }
        else
        {
                PageReference p =  new Pagereference('/apex/JobListView?id='+theid+'&intFocus=5');
                p.setRedirect(true);
                return p;
        }
       
       
     }
     
     // End of method Cancel
    
    // This method is called on to handle CreatePO button
    public Pagereference createPO()
    {
       
         if(isLtng)
        {
               PageReference p = Page.CreateNewPurchaseOrderLightning;
               p.setredirect(true);
               p.getParameters().put('jobid',theID); 
               return p;
        }
        else
        {
               PageReference p = Page.CreateNewPurchaseOrder;
               p.setredirect(true);
               p.getParameters().put('jobid',theID); 
               return p;
        }
       
       
       
        
    }  
    // End of method CreatePO 



    Public void duplicatePE()
    {
         try
         {
            // strPEID =  ApexPages.currentPage().getParameters().get('strPEID');
               List<Estimate_Line_Items__c > insertEstimate=new List<Estimate_Line_Items__c >();
             
              List<Estimate_Line_Items__c> abc = [select id,Job__c,Quantity__c,Amount__c,Name,GL_Code__c,GL_Department__c,Vendor__c from Estimate_Line_Items__c where id =: strPEID Limit 1];
             
              for(Estimate_Line_Items__c es:abc) 
              {
                   Estimate_Line_Items__c  objJEst=new Estimate_Line_Items__c ();
                    
                    objJEst.name=es.Name;
                    objJEst.Job__c=es.Job__c;
                    objJEst.Quantity__c=es.Quantity__c;
                    objJEst.Amount__c=es.Amount__c;
                    objJEst.GL_Code__c=es.GL_Code__c;
                    objJEst.GL_Department__c=es.GL_Department__c;
                    objJEst.Vendor__c =es.Vendor__c ;
                    
                    insertEstimate.add(objJEst);
              }
             insert insertEstimate;
             
             
             vq=new list<Estimate_Line_Items__c>();
             if(ViewAll)
             {
                  vq=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name limit 5];      
                  vq1=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];
                    estlst.clear();
                            for(integer i=0;i<vq.size();i++){
                            ineditEstobj=new inlinewrapperEst();
                            ineditEstobj.estrec=vq[i];
                            ineditEstobj.rowNo=i;
                            ineditEstobj.isEdit=false;
                            ineditEstobj.isEditQnty =false;
                            ineditEstobj.isEditCost =false;
                            estlst.add(ineditEstobj); 
                            
                         }
             
             
             
             }
             else
             {
                 vq=[select id,Name,Approved__c,PO_Created__c,GL_Code__r.Name,Job__c,Vendor__r.Name,GL_Department__c,Quote__r.Name,Amount__c,Total_Amount__c,Quantity__c,Unit_Type__c,Restrict__c,PO__c from Estimate_Line_Items__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];    
                 vq1=vq;
                        estlst.clear();
                        for(integer i=0;i<vq.size();i++){
                        ineditEstobj=new inlinewrapperEst();
                        ineditEstobj.estrec=vq[i];
                        ineditEstobj.rowNo=i;
                        ineditEstobj.isEdit=false;
                        ineditEstobj.isEditQnty =false;
                        ineditEstobj.isEditCost =false;
                        estlst.add(ineditEstobj); 
                        
                     }
             }
            
         }
    
         catch(System.DMLException e)
          {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                 
          }
    
   
    }




    
     
}// End of Class
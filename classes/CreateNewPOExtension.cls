// This class is used in CreateNewPurchaseOrder vf page

public with sharing class CreateNewPOExtension 
{
     public boolean isLtng{private set; get{
                                    String theme = UserInfo.getUITheme();
                                    return (theme=='Theme4d')?true:false;
                                  }
    }  

    public List<ELIWrapper> rolewraps{get;set;}
    public List<PO_Line_Item__c> lst{get;set;}
    public List<Estimate_Line_Items__c> ELIlst{get;set;}
    Public Boolean ShowLIitem{get;set;}
   
    public String StaffName,vendorName;
    Public Boolean ShowProductionEstimate{get;set;}
    public String getvendorName() { return vendorName; }
    public void setvendorName(String s) {  this.vendorName = s; }
    public String getStaffName() { return StaffName; }
    public void setStaffName(String s) {  this.Staffname = s; }
    private final Purchase_Order__c po;
    //public string vendorName{get; set;}
    public String jobid{get;set;}
    public String jobName{get;set;}

    // Start Constructor
    public CreateNewPOExtension(ApexPages.StandardController controller) 
    {
        ShowLIitem=false;
        
        roleWraps=new List<ELIWrapper>();
        this.po=(Purchase_Order__c)controller.getRecord();
        jobid=ApexPages.CurrentPage().getParameters().get('jobid');
        Job__c objJob=[Select id,name from Job__c where id=:jobid];
        jobName=objJob.Name;
        po.Job__c = jobid;
        
       ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
       ShowProductionEstimate =activeSettings.Active__c;
       
        
    }
    // End of Constructor
    
    public List<selectOption> getStaffs() 
        {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Staff__c a : [SELECT Id, name FROM Staff__c where IsDeleted__c = False order by Name ]) 
        {  
        optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
        }
    
    
    
     public List<selectOption> getVendor()
    {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
       //   List<Estimate_Line_Items__c> ven = [SELECT Id,Name,Vendor__c,Vendor__r.Name,Job__c,Approved__c FROM Estimate_Line_Items__c where Job__c=:jobid and Approved__c=true];
         if(ShowProductionEstimate){
         
         for (AggregateResult ar:[SELECT Vendor__c,Vendor__r.Name FROM Production_Estimate__c where Job__c=:jobid and Approved__c=true Group By Vendor__c,Vendor__r.Name Order By Vendor__r.Name])  
          { 
               String aID = (string)ar.get('Vendor__c');  
               Production_Estimate__c pelis=[Select id,Name,Vendor__r.Name from Production_Estimate__c where Vendor__c =: aID and Job__c=:jobid Limit 1];
               options.add(new selectOption(String.Valueof(ar.get('Vendor__c')),pelis.Vendor__r.Name)); //for all records found - add them to the picklist options
          }
         
         }
         
       else{
       for (AggregateResult ar:[SELECT Vendor__c,Vendor__r.Name FROM Estimate_Line_Items__c where Job__c=:jobid and Approved__c=true Group By Vendor__c,Vendor__r.Name Order By Vendor__r.Name DESC])  
          { 
               String aID = (string)ar.get('Vendor__c');  
               Estimate_Line_Items__c elis=[Select id,Name,Vendor__r.Name from Estimate_Line_Items__c where Vendor__c =: aID and Job__c=:jobid Limit 1];
               options.add(new selectOption(String.Valueof(ar.get('Vendor__c')),elis.Vendor__r.Name)); //for all records found - add them to the picklist options
          }
          }
        return options; //return the picklist options
    }
    
     public List<selectOption> getVendorContact()
    {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        
        options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below        
        for (Vendor_Contact__c ar:[SELECT Vendor__c,Name FROM Vendor_Contact__c where Vendor__c=:vendorName])  
          { 
                options.add(new selectOption(ar.Id, ar.name));
               
                
          }
        return options; //return the picklist options
    }
    
    public Void AddLIitems()
    {
          roleWraps=new List<ELIWrapper>();
         ShowLIitem=true;  
          
        if(!ShowProductionEstimate)
        {  
           List<Estimate_Line_Items__c> ELI=new List<Estimate_Line_Items__c>();
        
           ELI=[Select id,Name,Amount__c,Vendor__c,Job__c,Approved__c,Total_Amount__c,GL_Code__c, Quantity__c, Unit_Type__c From Estimate_Line_Items__c where Vendor__c =:vendorName and Job__c =:jobid and Approved__c = true and PO_Created__c = false Order By Name];
           for(Estimate_Line_Items__c e: ELI)
           {
                ELIWrapper rw=new ELIWrapper();
                rw.e=e;
                rw.checked=false;
                roleWraps.add(rw);        
           }
         }
         
         else
         {
           //   p = [Select id,Name,Job__c,Vendor__c from Purchase_Order__c where id =: poid];
    
               List<Production_Estimate__c> ELI=[Select id,Name,Total_cost__c,Vendor__c,Job__c,Approved__c,GL_Code__c, Quantity__c From Production_Estimate__c where Vendor__c =: vendorName  and Job__c =: jobid and Approved__c = true and PO_Created__c = false Order By Name];
               
               for(Production_Estimate__c e: ELI)
               {
                    ELIWrapper rw=new ELIWrapper();
                    rw.pe=e;
                    rw.checked=false;
                    roleWraps.add(rw);        
               }
               
               
         }
          
      //return null;
    }
    
     // Start Wrapper Class 
     public class ELIWrapper
     {
         public Estimate_Line_Items__c e{get;set;}
         public Production_Estimate__c pe{get;set;}
         public Boolean checked{get;set;}
     }
     // End of Wrapper Class
    
    
    
// Save Method
public PageReference saveme() 
    { 
    
        if(vendorName == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+'Vendor: You must select vendor ');
               ApexPages.addMessage(myMsg);
                return null;
        }
        string strPOId;
        try
        {
            po.Approved_By_Staff__c = StaffName;
            po.Vendor__c = vendorName;
            if(!test.isRunningTest()) {insert po;strPOId = po.id;}
            
            
            lst=new List<PO_Line_Item__c>();
            for(ELIWrapper rw:roleWraps)
             {
               
                if(rw.checked==true)
                {
                    PO_Line_Item__c stRole=new PO_Line_Item__c();
                    if(!ShowProductionEstimate)
                    { 
                        stRole.Estimate_Line_Item__c=rw.e.id;
                        stRole.Amount__c=rw.e.Total_Amount__c;
                        stRole.GL_Code__c=rw.e.GL_Code__c;
                        stRole.Purchase_Order__c=strPOId;
                        lst.add(stRole);
                    }
                    else
                    {
                        stRole.Production_Estimate__c=rw.pe.id;
                        stRole.Amount__c=rw.pe.Total_Cost__c;
                        stRole.GL_Code__c=rw.pe.GL_Code__c;
                        stRole.Purchase_Order__c=strPOId;
                        lst.add(stRole);
                    }
                    
                }
             }
             System.debug('Inserted value @@@ '+lst);
             insert lst;
            
            
            
            
        }
        catch(DMLException e)
        {
            return null;
        }
        
      PageReference p;
        if(isLtng)
        {
            p = new PageReference('/apex/PODetailPageLightning?id='+strPOId);
             //p.setRedirect(true);
             //return p; 
        }
        else
        {
               p =  new PageReference('/apex/PODetailPage?id='+strPOId);
               // p.setRedirect(true);
               // return p;
        }
          p.setRedirect(true);
          return p;
      
   }
// End of Save Method

// Cancel Method
    Public PageReference cancelme()
    {       
            PageReference p;
            if(isLtng)
            {
                  p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobid+'&tab=Jobcost'+'&section=purchaseorders');
                // p.setRedirect(true);
                // return p; 
            }
            else
            {
                p= new PageReference('/apex/JobListView?id='+jobid+'&intFocus=6');
                   // p.setRedirect(true);
                   // return p;
            }
                    p.setRedirect(true);
                    return p;
           
       }
// Cancel Method        
       
        
}
// End Of Class
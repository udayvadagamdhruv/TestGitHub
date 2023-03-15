public with sharing class newPurchaseorderExtension {
    public boolean isLtng{private set; get{
                                    String theme = UserInfo.getUITheme();
                                    return (theme=='Theme4d')?true:false;
                                  }
    }  

   
    public String StaffName,vendorName;
    Public Boolean ShowProductionEstimate{get;set;}
    public String getvendorName() { return vendorName; }
    public void setvendorName(String s) {  this.vendorName = s; }
    public String getStaffName() { return StaffName; }
    public void setStaffName(String s) {  this.Staffname = s; }
    private final Purchase_Order__c po;
    //public string vendorName{get; set;}
    public String jobid{get;set;}
   // public String jobName{get;set;}

    // Start Constructor
    public newPurchaseorderExtension(ApexPages.StandardController controller) 
    {
        this.po=(Purchase_Order__c)controller.getRecord();
        String vid=ApexPages.CurrentPage().getParameters().get('v');
        String vcid=ApexPages.CurrentPage().getParameters().get('vc');
        
        po.Vendor__c = vid;
        po.Vendor_Contact__c = vcid;
        jobid=vcid;
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
     public List<selectOption> getJobs() 
    {
        List<selectOption> optionList = new List<selectOption>();  
        optionList.add(new selectOption('', '- None -')); 
        for (Job__c a : [SELECT Id, name FROM Job__c order by Name Limit 1000]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
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
    
    
// Save Method
public PageReference saveme() 
    { 
        /*
        if(po.Job__c == ''){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+'Vendor: You must select vendor ');
               ApexPages.addMessage(myMsg);
                return null;
        }
        */
        string strPOId;
        try
        {
            po.Approved_By_Staff__c = StaffName;
            //po.Job__c= vendorName;
            insert po;
            strPOId = po.id;
        }
        catch(DMLException e)
        {
            return null;
        }
        
      PageReference p;
        if(isLtng)
           p=new PageReference('/apex/PODetailPageLightning?id='+strPOId);
        else
           p = new PageReference('/apex/PODetailPage?id='+strPOId); p.setRedirect(true); return p;
   }
// End of Save Method

// Cancel Method
    Public PageReference cancelme()
    {       
           PageReference p;
            if(isLtng)
                p =new Pagereference('/apex/VendorContactDetailPageLightning?id='+jobid+'&tab=Jobcost');
              else
                    p =  new PageReference('/apex/VendorContactDetailPage?id='+jobid+'&intFocus=6');
                    p.setRedirect(true);
                    return p;
       }
    // End of method Cancel
}
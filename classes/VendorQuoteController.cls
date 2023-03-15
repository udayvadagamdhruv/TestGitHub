// This class is used for Vendor Quote Object when Vendor Quote is Approved

public with sharing class VendorQuoteController 

{

    
     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
    
    
    
    // Global variables
    public Id QuoteId;
    String Jobid;
    private final Vendor_Quote__c o;
    String Quoteid1;
    Public Boolean ShowProductionEstimate{get;set;}
    public Estimate_Line_Items__c est;
    public List<Estimate_Line_Items__c> lstest=new List<Estimate_Line_Items__c>();
    public Production_Estimate__c pest;
    public List<Production_Estimate__c> lstpest=new List<Production_Estimate__c>();
    // End of Global variables
   
  
   // Constructor
    public VendorQuoteController(ApexPages.StandardController stdController) 
     {
          ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
          ShowProductionEstimate =activeSettings.Active__c;
          this.o = (Vendor_Quote__c)stdController.getRecord();
          // quoteid1=o.Quote__c;
          Vendor_Quote__c vq = [Select id,Name,Quote__r.job__c,Quote__c from Vendor_Quote__c where id =: o.Id];
          Jobid = vq.Quote__r.Job__c;
     }
   // End of Constructor 
    
   // Code we will invoke on page load.
    public PageReference autoRun() 
     {
      try
       {
           o.Restrict__c=true;
           update o;
       }
      catch(System.DMLException e)
       {
           return null;
       } 
      string strid = o.Id;
      string strEstimateId;
      string strPEstimateId;
     
      Vendor_Quote__c q1 = [select Name,Quote__r.id,Quote__r.Name,Quote__r.GL_Department__c,Restrict__c,Vendor__c,Quote__r.Job__c,Quote__r.Quantity__c,Quote__r.GL_Code__c,Amount__c from Vendor_Quote__c where Id =: strid];
      if(ShowProductionEstimate ){
      
      pest = new Production_Estimate__c();
      pest.Name = q1.Quote__r.Name;
      pest.GL_Department__c = q1.Quote__r.GL_Department__c;
      pest.GL_Code__c = q1.Quote__r.GL_Code__c;
      pest.Vendor__c = q1.Vendor__c;
      pest.Job__c = q1.Quote__r.Job__c;
      pest.Quote__c = q1.Quote__c;
      //pest.Restrict__c = q1.Restrict__c;
      pest.Amount__c = q1.Amount__c;
      pest.Quantity__c = q1.Quote__r.Quantity__c;
      strPEstimateId = pest.Id;
        
      try
      {
          insert pest;
      }
      catch(System.DMLException e)
      {
          return null;
      }
      
      
      }
      
      else{
      est = new Estimate_Line_Items__c();
      est.Name = q1.Quote__r.Name;
      est.GL_Department__c = q1.Quote__r.GL_Department__c;
      est.GL_Code__c = q1.Quote__r.GL_Code__c;
      est.Vendor__c = q1.Vendor__c;
      est.Job__c = q1.Quote__r.Job__c;
      est.Quote__c = q1.Quote__c;
      est.Restrict__c = q1.Restrict__c;
      est.Amount__c = q1.Amount__c;
      est.Quantity__c = q1.Quote__r.Quantity__c;
      strEstimateId = est.Id;
        
      try
      {
          insert est;
      }
      catch(System.DMLException e)
      {
          return null;
      }
      }
    QuoteId = [Select Id,name,Quote__r.Id from Vendor_Quote__c where Id =:o.Id].Quote__c;
    List<Quote_Spec_Item__c> qsi = new List<Quote_Spec_Item__c>();
    List <Estimate_Spec_Item__c> lstELI=new List<Estimate_Spec_Item__c>();
    List<Production_Estimate_Spec_Item__c> lstPELI= new List<Production_Estimate_Spec_Item__c>();
    
    qsi = [Select id,Name,Description__c,Quote__c from Quote_Spec_Item__c where Quote__c =: QuoteId];     
    If(ShowProductionEstimate ){
    
    for(Quote_Spec_Item__c q3:qsi)
    {
           Production_Estimate_Spec_Item__c pestLI = new Production_Estimate_Spec_Item__c();
           pestLI.Name = q3.Name;
           pestLI.Description__c = q3.Description__c;
           pestLI.Production_Estimate__c= pest.id; 
           lstPELI.add(pestLI);
    }
    insert lstPELI;
    
    // After performing operation navigate to Quote page
    
    if(isLtng){
    PageReference pageRef =  new Pagereference('/apex/JobdetailpageLightening07?id='+Jobid+'&tab=Jobcost'+'&section=estimate');
    pageRef.setRedirect(true);
    return pageRef;
    }
    
    else{
    
    PageReference pageRef =  new Pagereference('/apex/JobListView?id='+Jobid+'&intFocus=14');
    pageRef.setRedirect(true);
    return pageRef;
    
    }
    
   }
    
    else{
    for(Quote_Spec_Item__c q3:qsi)
    {
           Estimate_Spec_Item__c estLI = new Estimate_Spec_Item__c();
           estLI.Name = q3.Name;
           estLI.Description__c = q3.Description__c;
           estLI.Estimates__c = est.id; 
           lstELI.add(estLI);
    }
    insert lstELI;
    
    if(isLtng){
    // After performing operation navigate to Quote page
    PageReference pageRef =  new Pagereference('/apex/JobdetailpageLightening07?id='+Jobid+'&tab=Jobcost'+'&section=estimate');
    pageRef.setRedirect(true);
    return pageRef;
    }
    else{
    
      PageReference pageRef =  new Pagereference('/apex/JobListView?id='+Jobid+'&intFocus=5');
    pageRef.setRedirect(true);
    return pageRef;
    
    
    
    }
    
    }
    
    
   }
    
   /*  //  Test Code Coverage
   static testMethod void ApproveVendorQuotePositiveTest()
    {
         Job_Number_Setting__c customSetting1 = new  Job_Number_Setting__c(Name= 'yy');

            insert customSetting1;
            
        Media_Type__c testMedia=new Media_Type__c(Name='Test Media 328');
            insert testMedia;
             
        Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 328',Media_Types__c=testMedia.Id);
            insert testST;
        
        Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 328');
            insert testSpec;
      
        Job__c testJob1=new Job__c(Name='Test Job 328',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
         try
          {
              insert testJob1;
          }
         catch(System.DMLException e)
          {
              System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
          }
         System.assertEquals('Test Job 328',testJob1.Name);
               
         GL_Department__c testGLD = new GL_Department__c(Name='TestGLD12');
          try
           {
               insert testGLD;
           }
          catch(System.DMLException e)
          {
              System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
          }
   
       Quote__c testQ=new Quote__c(Name='Quote 328',Job__c=testjob1.Id,GL_Department__c=testGLD.id);
       try
        {
            insert testQ;
        }
       catch(System.DMLException e)
        {
        System.assertEquals('REQUIRED_FIELD_MISSING',e.getDmlStatusCode(0));
        }
       catch(Exception f)
        {
         System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',f.getDmlStatusCode(0));
        }
        
        Quote_Spec_Item__c qsinew = new Quote_Spec_Item__c(Name='testQSI',Description__c='Desc1',Quote__c=testQ.id);
        insert qsinew;
        
        Quote_Spec_Item__c qsinew1 = new Quote_Spec_Item__c(Name='testQSI1',Description__c='Desc1',Quote__c=testQ.id);
        insert qsinew1;
              
     Vendor__c testVendor=new Vendor__c(Name='Vendor 328');
     insert testVendor;
             
     Vendor_Quote__c testVQ=new Vendor_Quote__c(Quote__c=testQ.Id,Vendor__c=testVendor.Id,Date__c=System.Today(),Amount__c=500);
     insert testVQ;
              
     Vendor_Quote_Line_Item__c testVQLI=new Vendor_Quote_Line_Item__c(Name='test333',Description__c='Des333',Vendor_Quote__c=testVQ.Id); 
     insert testVQLI;
             
     ApexPages.StandardController con=new ApexPages.StandardController(testVQ);
     ApexPages.currentPage().getParameters().put('Id',testVQ.Id);
          
    // Instantiate the extention instance with the standard controller
     VendorQuoteController ext=new VendorQuoteController(con);
        
    // Invoke the primary method on the extension 
     ApexPages.PageReference result1=ext.autoRun();
     delete testVQ;
     result1=ext.autoRun();
    }    // End of Test Coverage Code*/
}
// End of Class
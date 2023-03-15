public with sharing class CreateProductionEstimateExtension {

  // Start Global variables
  
   /* public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
     }  
            
            
     public boolean isMob{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
    }  
    
  
  
    Public String MIName,GLDName,VName,GLCName;
    public String getMIName() { return MIName; }
    public void setMIName(String s) {  this.MIName = s; }
   
    
    public String getGLDName() { return GLDName; }
    public void setGLDName(String s) {  this.GLDName = s; }

    
    public String getGLCName() { return GLCName; }
    public void setGLCName(String s) {  this.GLCname = s; }
    
   
    public String getVName() { return VName; }
    public void setVName(String s) {  this.Vname = s; }

    
    
    public String selectedDepartment {get;set;}
    public  Quote__c user {get;set;}
    public String  UserSelectedControllingOption {get;set;}
    public String  UserSelectedDependentOption {get;set;}

    private final Production_Estimate__c pest;
    public  job__c abc;
    public String qid{get;set;}
    public String quoteid{get;set;}
    public String vqid{get;set;}
    public String orgId{get; set;}
    // End of Global variables
   
   // Start of Constructor
    public CreateProductionEstimateExtension(ApexPages.StandardController controller) 
     {
         
         
         this.pest=(Production_Estimate__c)controller.getRecord();
         qid=ApexPages.CurrentPage().getParameters().get('jobid');
         abc = [select id,name,Job_Auto_Number__c from Job__c where id =: qid];

         pest.Job__c=qid;
         
         
         orgId = UserInfo.getOrganizationId();
        system.debug('org id --------->'+orgId);
     }
   // End of Constructor 
   // This method is used to retrieve all MaterialItems into dropdown list
     public List<selectOption> getMaterialItems() 
     {    
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (Material_Item__c MI : [SELECT Id, name FROM Material_Item__c where recordtype.name =:pest.Calc_Unit__c order by Name limit 999]) 
          {  
               optionList.add(new selectOption(MI.Id, MI.Name));  
          }
          return optionList;  
     }   
     
     
     public List<selectOption> getMaterialItems2() 
     {    
          List<selectOption> optionList = new List<selectOption>();
         // optionList.add(new selectOption('', '- None -'));  
          for (Material_Item__c MI : [SELECT Id, name FROM Material_Item__c where recordtype.name =:pest.Calc_Unit__c order by Name limit 999 offset 999]) 
          {  
               optionList.add(new selectOption(MI.Id, MI.Name));  
          }
          return optionList;  
     }  
     // End of method MaterialItems
   
   
   
   
   
   
    
    // This method is used to retrieve all GLDepartments into dropdown list
    public List<selectOption> getGLDepartments() 
     {    
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (GL_Department__c gld : [SELECT Id, name FROM GL_Department__c order by Name limit 999]) 
          {  
               optionList.add(new selectOption(gld.Id, gld.Name));  
          }
          return optionList;  
     }   
     // End of method getGLDepartments
    
    // This method is used to retrieve all GLCodes into dropdown list
    public List<selectOption> getGLCodes() 
     {
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (GL_Code__c users : [SELECT Id,GL_Id__c,Name FROM GL_Code__c where GL_Department__c =: GLDName ORDER BY Name limit 999]) 
          {  
               optionList.add(new selectOption(users.Id, users.GL_Id__c +' '+users.Name));  
          }
          return optionList;  
     }
     // End of method getGLCodes  
  
     // This method is used to retrieve all Vendors into dropdown list
    public List<selectOption> getVendors()
     {
          List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
          options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
          List<Vendor_GL_Code__c> ven = [SELECT Id,Name,Vendor__c,Vendor__r.Name,GL_Code__c FROM Vendor_GL_Code__c where GL_Code__c =: GLCName limit 999];
          for(Vendor_GL_Code__c am : ven)
          {
               System.Debug('a = '+am);
          }
     
          for (Vendor_GL_Code__c ar : ven)  
          { 
               options.add(new selectOption(ar.Vendor__c,ar.Vendor__r.Name)); //for all records found - add them to the picklist options
          }
            return options; //return the picklist options
     }
     // End of method getVendors
  
  
    
   // Save method
    public PageReference saveme() 
    { 
     string strPEstimateId;
     
     
     
      try
       { 
        if(GLDName == null)
         { 
             String stringGLD = Schema.Production_Estimate__c.fields.GL_Department__c.getDescribe().getLabel();
             ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR,stringGLD+' : You must select a '+stringGLD+'.');
             ApexPages.addMessage(msg1);
             return null;
         }
        
        if(GLCName == null)
         {
             String stringGLC = Schema.Production_Estimate__c.fields.GL_Code__c.getDescribe().getLabel();
             ApexPages.Message msg2 = new ApexPages.Message(ApexPages.Severity.ERROR,stringGLC+' : You must select a '+stringGLC+'.');
             ApexPages.addMessage(msg2);
             return null;
         }
             
        if(VName == null)
         {
             String stringV = Schema.Production_Estimate__c.fields.Vendor__c.getDescribe().getLabel();
             ApexPages.Message msg3 = new ApexPages.Message(ApexPages.Severity.ERROR,stringV+' : You must select a '+stringV+'.');
             ApexPages.addMessage(msg3);
             return null;
         }
             
        else
         {          
             if (Schema.sObjectType.Production_Estimate__c.fields.GL_Department__c.isCreateable()) {
                 pest.GL_Department__c = GLDName;}
              if (Schema.sObjectType.Production_Estimate__c.fields.GL_Code__c.isCreateable()) {
                  pest.GL_Code__c = GLCName;}
             if (Schema.sObjectType.Production_Estimate__c.fields.Vendor__c.isCreateable()) {
                 pest.Vendor__c = Vname;}
             if (Schema.sObjectType.Production_Estimate__c.fields.Material_Item__c.isCreateable()) {
                 pest.Material_Item__c=MIName;}
             
             if(Pest.Qty_Up__c ==null  && Pest.of_Pages__c ==null) {
                  if (Schema.sObjectType.Production_Estimate__c.fields.Qty_Up__c.isCreateable()) {
                      Pest.Qty_Up__c=1;}
             }
            
             
            if(pest.Quantity__c==null)
             {
                  if (Schema.sObjectType.Production_Estimate__c.fields.Quantity__c.isCreateable()) {
                      Pest.Quantity__c=1;}
              }
             
            
             
             if(pest.Calc_Unit__c=='Sheet' && Pest.Sided__c=='Double' && Pest.Qty_Up__c !=null && pest.Divide_Sheets_By_Two__c==true){
                 if (Schema.sObjectType.Production_Estimate__c.fields.SheetQtyUpforUsed__c.isCreateable()) {
                     pest.SheetQtyUpforUsed__c=(pest.Quantity__c/pest.Qty_Up__c)/2;}
                 }
                 
                 else if (pest.Calc_Unit__c=='Sheet' && Pest.Sided__c=='Double' && Pest.Qty_Up__c !=null && pest.Divide_Sheets_By_Two__c==false){
                  if (Schema.sObjectType.Production_Estimate__c.fields.SheetQtyUpforUsed__c.isCreateable()) {
                      pest.SheetQtyUpforUsed__c=(pest.Quantity__c/pest.Qty_Up__c);}
                 }
                 
                 
               else  if(pest.Calc_Unit__c=='Sheet' && Pest.Sided__c=='Single' && Pest.Qty_Up__c !=null){
                  if (Schema.sObjectType.Production_Estimate__c.fields.SheetQtyUpforUsed__c.isCreateable()) {
                      pest.SheetQtyUpforUsed__c=(pest.Quantity__c/pest.Qty_Up__c);}
                 
                 }
             
               else if(pest.Calc_Unit__c=='Each' && Pest.Qty_Up__c !=null){
                  if (Schema.sObjectType.Production_Estimate__c.fields.EachQtyUpforUsed__c.isCreateable()) {
                      pest.EachQtyUpforUsed__c=(pest.Quantity__c/pest.Qty_Up__c);}
                 
               }
             if(Schema.sObjectType.Production_Estimate__c.isCreateable()){
                 insert pest;}
             strPEstimateId = pest.id;
             
             
             
         }
       }   
      catch(System.DMLException e)
       {
          ApexPages.addMessages(e);
          
           return null;
       }
        
        
       PageReference p;
        if(isLtng)
        {
             p = new Pagereference('/apex/JobdetailpageLightening07?id='+qid+'&tab=Jobcost'+'&section=PE');
        }
        else
        {
              p = new Pagereference('/apex/JobListView?id='+qid+'&intFocus=14');
        }
      
      p.setRedirect(true);
      return p;   
        
    /*    
      PageReference pageref =  new Pagereference('/apex/JobListView?id='+qid+'&intFocus=14');
      pageRef.setRedirect(true);
      return pageRef;
   } 
  // End of Save Method 
    
     
 
           
    // Method to deal with cancel button 
     public PageReference cancelme()
      {
         PageReference p;
        if(isLtng)
        {
             p = new Pagereference('/apex/JobdetailpageLightening07?id='+qid+'&tab=Jobcost'+'&section=PE');
        }
        else
        {
              p = new Pagereference('/apex/JobListView?id='+qid+'&intFocus=14');
        }
      
      p.setRedirect(true);
      return p;   
      }*/
      // End of method cancelme
}
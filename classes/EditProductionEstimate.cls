public with sharing class EditProductionEstimate {

  // Global variables
  
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
  
  
  
    Public String GLDName, EstId,GLCName,VName,MIName;
    
    Public Production_Estimate__c abc;
    
    public String getMIName() { return MIName; }
    public void setMIName(String s) {  this.MIName = s; }
    public String getGLDName() { return GLDName; }
    public void setGLDName(String s) {  this.GLDName = s; }
    public String getGLCName() { return GLCName; }
    public void setGLCName(String s) {  this.GLCname = s; }
    public String getVName() { return VName; }
    public void setVName(String s) {  this.Vname = s; }
    Public Boolean Showpages{get;set;}
    private final Production_Estimate__c pest;
    public String orgId{get; set;}
    // End of Global variables
   
    public static boolean firstRun = true;
    
    public static set<string> processedProdIds=new set<String>();
   
   

    public EditProductionEstimate(ApexPages.StandardController controller) {
     this.pest=(Production_Estimate__c)controller.getRecord();
         EstId=ApexPages.CurrentPage().getParameters().get('id');
     
          abc = [select id,Job__r.name,Job__r.Job_Auto_Number__c,Name,Calc_Unit__c,GL_Code__c,GL_Department__c,Vendor__c,Material_Item__c from Production_Estimate__c where id =: PEst.id WITH SECURITY_ENFORCED Limit 1];
         GLDName = abc.GL_Department__c;
         GLCName = abc.GL_Code__c;
         VName = abc.Vendor__c;  
         MIName=abc.Material_Item__c;
         
         if(abc.Calc_Unit__c=='Sheet'){
           Showpages=true;
         
         }
         orgId = UserInfo.getOrganizationId();
        system.debug('org id --------->'+orgId);
    }
    
    // This method is used to retrieve all  into dropdown list
    public List<selectOption> getMaterialItems() 
     {    
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (Material_Item__c MI : [SELECT Id, name FROM Material_Item__c where recordtype.name =:pest.Calc_Unit__c WITH SECURITY_ENFORCED order by Name limit 999]) 
          {  
               optionList.add(new selectOption(MI.Id, MI.Name));  
          }
          return optionList;  
     } 
     
        public List<selectOption> getMaterialItems2() 
     {    
          List<selectOption> optionList = new List<selectOption>();
         // optionList.add(new selectOption('', '- None -'));  
          for (Material_Item__c MI : [SELECT Id, name FROM Material_Item__c where recordtype.name =:pest.Calc_Unit__c WITH SECURITY_ENFORCED order by Name limit 999 offset 999]) 
          {  
               optionList.add(new selectOption(MI.Id, MI.Name));  
          }
          return optionList;  
     }  
     
       
     // End of method 
    
    
    // This method is called on to retrieve All GLDepartments into dropdown list
     public List<selectOption> getGLDepartments() 
     {    
         List<selectOption> optionList = new List<selectOption>();
         optionList.add(new selectOption('', '- None -'));  
         for (GL_Department__c gld : [SELECT Id, name FROM GL_Department__c WITH SECURITY_ENFORCED order by Name limit 999]) 
         {  
             optionList.add(new selectOption(gld.Id, gld.Name));  
         }
         return optionList;  
     }   
     // ENd of method getGLDepartments
    
     // This method is called on to retrieve All GLCodes into dropdown list
    public List<selectOption> getGLCodes() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (GL_Code__c glcode : [SELECT Id,GL_Code__c.Name,GL_Id__c FROM GL_Code__c where GL_Department__c =: GLDName WITH SECURITY_ENFORCED ORDER BY Name limit 999]) 
        {  
              optionList.add(new selectOption(glcode.Id,glcode.GL_Id__c +' '+glcode.Name));  
        }
        return optionList;  
     }
     // End of method getGLCodes  
  
      // This method is called on to retrieve All Vendor into dropdown list
     public List<selectOption> getVendors()
      {
          List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
          options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
         
          List<Vendor_GL_Code__c> ven = [SELECT Id,Name,Vendor__c,Vendor__r.Name,GL_Code__c FROM Vendor_GL_Code__c where GL_Code__c =: GLCName WITH SECURITY_ENFORCED limit 999];
       
          for (Vendor_GL_Code__c ar : ven)  
          { 
               options.add(new selectOption(ar.Vendor__c,ar.Vendor__r.Name)); //for all records found - add them to the picklist options
          }
        return options; //return the picklist options
    }
    // End of method getVendors
    
    
    // This method is called on to Save Estimate
    Public PageReference saveme()
    {  
     
    try
       {
         if(GLDName == null)
          {
                   String stringGLD = Schema.Estimate_Line_Items__c.fields.GL_Department__c.getDescribe().getLabel();
                   ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR,stringGLD+' : You must select a '+stringGLD+'.');
                   ApexPages.addMessage(msg1);    return null;
               }
               
             if(GLCName == null)
             {
                 String stringGLC = Schema.Estimate_Line_Items__c.fields.GL_Code__c.getDescribe().getLabel();
                 ApexPages.Message msg2 = new ApexPages.Message(ApexPages.Severity.ERROR,stringGLC+' : You must select a '+stringGLC+'.');
                 ApexPages.addMessage(msg2);   return null;
             }
             
             if(VName == null)
             {
                  String stringV = Schema.Estimate_Line_Items__c.fields.Vendor__c.getDescribe().getLabel();
                  ApexPages.Message msg3 = new ApexPages.Message(ApexPages.Severity.ERROR,stringV+' : You must select a '+stringV+'.');
                  ApexPages.addMessage(msg3);   return null;
             }
             else
             {          
                 GL_Code__c glc1 = [select id,Name from GL_Code__c where id =: GLCName WITH SECURITY_ENFORCED];
                 GL_Department__c gd1 = [SELECT Id, name FROM  GL_Department__c where id =: GLDName WITH SECURITY_ENFORCED];
                 Vendor__c v1 = [select id,name from Vendor__c where id =: VName WITH SECURITY_ENFORCED];
                 
                 
                 if(schema.SobjectType.Production_Estimate__c.Fields.GL_Department__c.isUpdateable()){ pest.GL_Department__c = gd1.id;}
                 if(schema.SobjectType.Production_Estimate__c.Fields.GL_Code__c.isUpdateable()){pest.GL_Code__c = glc1.id;}
                 if(schema.SobjectType.Production_Estimate__c.Fields.Vendor__c.isUpdateable()){pest.Vendor__c = v1.id;}
                 if(schema.SobjectType.Production_Estimate__c.Fields.Material_Item__c.isUpdateable()){pest.Material_Item__c= MIName;}
                 
                 if(Pest.Qty_Up__c ==null  && Pest.of_Pages__c ==null){ 
                  if (Schema.sObjectType.Production_Estimate__c.fields.Qty_Up__c.isUpdateable()) {   
                    Pest.Qty_Up__c=1;}
                 }
                 if(pest.Quantity__c==null)
                 {
                      if(schema.SobjectType.Production_Estimate__c.Fields.Quantity__c.isUpdateable()){ Pest.Quantity__c=1;}
                  }
                 
                
                 
                if(pest.Calc_Unit__c=='Sheet' && Pest.Sided__c=='Double' && Pest.Qty_Up__c !=null && pest.Divide_Sheets_By_Two__c==True){
                 if(schema.SobjectType.Production_Estimate__c.Fields.SheetQtyUpforUsed__c.isUpdateable()){ pest.SheetQtyUpforUsed__c=(pest.Quantity__c/pest.Qty_Up__c)/2;}
                 }
                 
                 else if (pest.Calc_Unit__c=='Sheet' && Pest.Sided__c=='Double' && Pest.Qty_Up__c !=null && pest.Divide_Sheets_By_Two__c==false){
                  if(schema.SobjectType.Production_Estimate__c.Fields.SheetQtyUpforUsed__c.isUpdateable()){pest.SheetQtyUpforUsed__c=(pest.Quantity__c/pest.Qty_Up__c);}
                 }
                 
                 
                 
                 else if(pest.Calc_Unit__c=='Sheet' && Pest.Sided__c=='Single' && Pest.Qty_Up__c !=null){
                 
                  if(schema.SobjectType.Production_Estimate__c.Fields.SheetQtyUpforUsed__c.isUpdateable()){pest.SheetQtyUpforUsed__c=(pest.Quantity__c/pest.Qty_Up__c);}
                 
                 }
                 
                 else if(pest.Calc_Unit__c=='Each' && Pest.Qty_Up__c !=null){
                 
                  if(schema.SobjectType.Production_Estimate__c.Fields.EachQtyUpforUsed__c.isUpdateable()){pest.EachQtyUpforUsed__c=(pest.Quantity__c/pest.Qty_Up__c);}
                 
                 } 
                 
                      if(Schema.sObjectType.Production_Estimate__c.isUpdateable()){update pest;  }
                 
                
                 
                       
            } 
        }    
       catch(system.DMLException e)
       {return null;
       }
      
      
      PageReference p;
        if(isLtng)
        {
             p = new Pagereference('/apex/ProductionEstimatedetailpageLightning?id='+EstId);
        }
        else
        {
              p = new Pagereference('/apex/ProductionEstimatedetailpage?id='+EstId);
        }
        
      
      
      
      
      
       // PageReference p =  new Pagereference('/apex/ProductionEstimatedetailpage?id='+EstId);
        p.setRedirect(true);
        return p;
    }
    // End of method Save
    
    // This method called on to handle Cancel button
      public PageReference cancelme()
      {
      
           PageReference p;
        if(isLtng)
        {
             p = new Pagereference('/apex/ProductionEstimatedetailpageLightning?id='+EstId);
        }
        else
        {
              p = new Pagereference('/apex/ProductionEstimatedetailpage?id='+EstId);
        }
        
      
      
         //   PageReference p =  new Pagereference('/apex/ProductionEstimatedetailpage?id='+EstId);
            p.setRedirect(true);
            return p;     
       }
    // End Cancel method
    
    
    
}
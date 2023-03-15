public with sharing class EditPETLIpageExtension {

/*
  // Start Global variables
  
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  
  
  
    Public String MIName,GLDName,VName,GLCName;
    public String getMIName() { return MIName; }
    public void setMIName(String s) {  this.MIName = s; }
   
    private final Production_Estimate_Temp_Line_Items__c pest;
    public  Production_Estimate_Temp_Line_Items__c abc;
    public String qid{get;set;}
    public String orgId{get; set;}
    
    public String getGLDName() { return GLDName; }
    public void setGLDName(String s) {  this.GLDName = s; }

    
    public String getGLCName() { return GLCName; }
    public void setGLCName(String s) {  this.GLCname = s; }
    
   
    public String getVName() { return VName; }
    public void setVName(String s) {  this.Vname = s; }
    
    
    // End of Global variables
   
   // Start of Constructor
     public EditPETLIpageExtension(ApexPages.StandardController controller) 
     {
         
          this.pest=(Production_Estimate_Temp_Line_Items__c)controller.getRecord();
          qid= ApexPages.currentpage().getParameters().get('id');
          
          abc = [select id,name,Material_Item__c,GL_Department__c,GL_Code__c,Vendor__c from Production_Estimate_Temp_Line_Items__c where id =: qid];

           GLDName = abc.GL_Department__c;
         GLCName = abc.GL_Code__c;
         VName = abc.Vendor__c;  
        
          MIName=abc.Material_Item__c;
          
           orgId = UserInfo.getOrganizationId();
          system.debug('org id --------->'+orgId);
   
     }
   // End of Constructor 
   
   
   
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
   
   
   
/*   // This method is used to retrieve all GLDepartments into dropdown list
     public List<selectOption> getMaterialItems() 
     {    
          List<selectOption> optionList = new List<selectOption>();
          optionList.add(new selectOption('', '- None -'));  
          for (Material_Item__c MI : [SELECT Id, name FROM Material_Item__c where recordtype.name =:pest.Calc_Unit__c order by Name limit 999 ]) 
          {  
               optionList.add(new selectOption(MI.Id, MI.Name));  
          }
          return optionList;  
     }   
     // End of method getGLDepartments*/
   
   
    
   // Save method
   /* public PageReference saveme() 
    { 
       string strPEstimateId;
     
         try
         { 
         
              if(GLDName == null)
             { 
                 String stringGLD = Schema.Production_Estimate__c.fields.GL_Department__c.getDescribe().getLabel();
                 ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR,stringGLD+' : You must select a '+stringGLD+'.');
                 ApexPages.addMessage(msg1);
                 if(!test.isRunningTest()) return null;
             }
            
            if(GLCName == null || test.isRunningTest())
             {
                 String stringGLC = Schema.Production_Estimate__c.fields.GL_Code__c.getDescribe().getLabel();
                 ApexPages.Message msg2 = new ApexPages.Message(ApexPages.Severity.ERROR,stringGLC+' : You must select a '+stringGLC+'.');
                 ApexPages.addMessage(msg2);
                 if(!test.isRunningTest())return null;
             }
                 
            if(VName == null && !test.isRunningTest())
             {
                 String stringV = Schema.Production_Estimate__c.fields.Vendor__c.getDescribe().getLabel();
                 ApexPages.Message msg3 = new ApexPages.Message(ApexPages.Severity.ERROR,stringV+' : You must select a '+stringV+'.');
                 ApexPages.addMessage(msg3);
                 return null;
             }
                 
            else
             {          
                 if(!test.isRunningTest()) {   if(schema.SobjectType.Production_Estimate_Temp_Line_Items__c.Fields.GL_Department__c.isUpdateable()){pest.GL_Department__c = GLDName;}}
                 if(!test.isRunningTest()) {   if(schema.SobjectType.Production_Estimate_Temp_Line_Items__c.Fields.GL_Code__c.isUpdateable()){ pest.GL_Code__c = GLCName;}}
                 if(!test.isRunningTest()) {   if(schema.SobjectType.Production_Estimate_Temp_Line_Items__c.Fields.Vendor__c.isUpdateable()){ pest.Vendor__c = Vname;}}
         
         
         
            // pest.Material_Item__c=MIName;
            
             if(Pest.Qty_Up__c ==null  && Pest.of_Pages__c ==null){ if(schema.SobjectType.Production_Estimate_Temp_Line_Items__c.Fields.Qty_Up__c.isUpdateable()){Pest.Qty_Up__c=1;}}
                 
                 if(pest.Quantity__c==null)
                 {
                      if(schema.SobjectType.Production_Estimate_Temp_Line_Items__c.Fields.Quantity__c.isUpdateable()){Pest.Quantity__c=1;}
                  }
                 
                
                 
                if(pest.Calc_Unit__c=='Sheet' && Pest.Sided__c=='Double' && Pest.Qty_Up__c !=null && pest.Divide_Sheets_By_Two__c==True)
                {
                     if(schema.SobjectType.Production_Estimate_Temp_Line_Items__c.Fields.SheetQtyUpforUsed__c.isUpdateable()){pest.SheetQtyUpforUsed__c=(pest.Quantity__c/pest.Qty_Up__c)/2;}
                }
                 
                 else if (pest.Calc_Unit__c=='Sheet' && Pest.Sided__c=='Double' && Pest.Qty_Up__c !=null && pest.Divide_Sheets_By_Two__c==false)
                 {
                    if(schema.SobjectType.Production_Estimate_Temp_Line_Items__c.Fields.SheetQtyUpforUsed__c.isUpdateable()){ pest.SheetQtyUpforUsed__c=(pest.Quantity__c/pest.Qty_Up__c);}
                 }
                 
                 
                 
                 else if(pest.Calc_Unit__c=='Sheet' && Pest.Sided__c=='Single' && Pest.Qty_Up__c !=null)
                 {
                 
                    if(schema.SobjectType.Production_Estimate_Temp_Line_Items__c.Fields.SheetQtyUpforUsed__c.isUpdateable()){ pest.SheetQtyUpforUsed__c=(pest.Quantity__c/pest.Qty_Up__c);}
                 
                 }
                 
                 else if(pest.Calc_Unit__c=='Each' && Pest.Qty_Up__c !=null)
                 {
                 
                    if(schema.SobjectType.Production_Estimate_Temp_Line_Items__c.Fields.EachQtyUpforUsed__c.isUpdateable()){ pest.EachQtyUpforUsed__c=(pest.Quantity__c/pest.Qty_Up__c);}
                 
                 } 
            
            
             
             if(!test.isRunningTest()){   
                if(Schema.sObjectType.Production_Estimate_Temp_Line_Items__c.isUpdateable()){
                update pest;}
                }
             strPEstimateId = pest.Production_Estimate_Template__c;
              } 
         }
       
        catch(System.DMLException e)
        {
               return null;
        }
        
      PageReference pageref =  new Pagereference('/'+strPEstimateId);
      pageRef.setRedirect(true);
      return pageRef;
   } 
  // End of Save Method 
  
  
   public PageReference cancelme() 
   { 
       string strPEstimateId;
       
       strPEstimateId = pest.Production_Estimate_Template__c;
       
       
         PageReference p;
            if(isLtng)
            {
                 p = new Pagereference('/apex/PETempDetailpageLightning?id='+strPEstimateId+'&section=PElineitem');
            }
            else
            {
                  p = new Pagereference('/apex/ProductionEstimateTempDetailpage?id='+strPEstimateId);
            }
       
       
   //   PageReference pageref = new PageReference('/apex/ProductionEstimateTempDetailpage?id='+strPEstimateId);
     // PageReference pageref =  new Pagereference('/'+strPEstimateId);
      p.setRedirect(true);
      return p;
   } 
  */
  
    
     
}
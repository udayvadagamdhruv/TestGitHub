public with sharing class Adminlighting {

    //pubic variables
    
    public string glcode             {set;get;}  // Gl code
    public string scheduletemp       {set;get;}  // Schedule Template
    public string crebrieftemp       {set;get;}  // Creative Brief template
    public string proseptemp         {set;get;}
    public string proesttemp         {set;get;}
    public string holidays           {set;get;}
    public string invoiceallotemp    {set;get;}
    public string staff              {set;get;}
    public string roles              {set;get;}
    public string meidatypes         {set;get;}
    public string gldepartment       {set;get;}
    public string tagtemp            {set;get;}
    public string PEtemp             {set;get;}
    public string Invtemp            {set;get;}
    public string CampTemp           {set;get;} 
    public string TagsTemp           {set;get;}
    
    
    
    Public String test               {set;get;}
    
    public Adminlighting ()
    {
                  glcode=GL_Code__c.SObjectType.getDescribe().getKeyPrefix();
                 
                  scheduletemp=Schedule_Template__c.SObjectType.getDescribe().getKeyPrefix();      
            
                  crebrieftemp=Specification_Template__c.SObjectType.getDescribe().getKeyPrefix();      
                   
                  proseptemp=Production_Spec_Template__c.SObjectType.getDescribe().getKeyPrefix();
                  
                  proesttemp =Production_Estimate_Template__c.SObjectType.getDescribe().getKeyPrefix();       
                     
                  holidays =Holiday__c.SObjectType.getDescribe().getKeyPrefix();          
                   
                  invoiceallotemp=Invoice_Allocation_Template__c.SObjectType.getDescribe().getKeyPrefix();    
                   
                  staff=Staff__c.SObjectType.getDescribe().getKeyPrefix();          
          
                  roles =UserRole.SObjectType.getDescribe().getKeyPrefix();             
                     
                  meidatypes= Media_Type__c.SObjectType.getDescribe().getKeyPrefix();        
                  
                  gldepartment=GL_Department__c.SObjectType.getDescribe().getKeyPrefix();
          
                  tagtemp=Tag_Template__c.SObjectType.getDescribe().getKeyPrefix();
                  
                  PEtemp=Production_Estimate_Template__c.SObjectType.getDescribe().getKeyPrefix();
                  
                  Invtemp=Invoice_Allocation_Template__c.SObjectType.getDescribe().getKeyPrefix();
                  
                  CampTemp=Campaign_Template__c.SobjectType.getDescribe().getKeyPrefix();
                              
                  TagsTemp=  Tag_Template__c.SobjectType.getDescribe().getKeyPrefix();
        }
      
      
      /*{ 
          a0E=GL_Code__c,
          a0r=Schedule_Template__c, 
          a0x=Specification_Template__c, 
          
          a0k=Production_Spec_Template__c,
          a1B=Production_Estimate_Template_c,
          a0I=Holiday__c, 
          
          a0N=Invoice_Allocation_Template__c, 
          a0y=Staff__c, 
          00E=UserRole,
          
          a0c=Media_Type__c,
          a0F=GL_Department__c,
          a11=Tag_Template__c,}
      */
      
      public Pagereference ShowItems(){
      
        // Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.info,''+test));
        // return null;
        
           System.debug('============================Test Variabble Values==========================================='+test);
       
         PageReference pageRef;
         if(test.equals(roles)){
             pageRef=new PageReference('/apex/RoleTabLightning');
             }
             
        else if(test.equals(staff)){
               pageRef= new PageReference('/apex/StaffTabLightning');
               }
          else{
             pageRef= new PageReference('/'+test +'/o');
            }
        pageRef.setRedirect(true); 
        return pageRef;
       
      
          
      }
      
  
  

}
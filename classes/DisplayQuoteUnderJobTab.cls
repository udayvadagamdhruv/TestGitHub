// This class is used to Display Quotes Under Job Tab
public with sharing class DisplayQuoteUnderJobTab 
{

   


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
    
    
    
  //  public boolean displayPopup {get; set;}
    // Global variables
    public List<Quote__c> q{get;set;}
    public List<Quote__c> q2{get;set;}
    public String theID {get;set;}
    public string strPEID{get;set;}
    Public Boolean ShowProductionEstimate{get;set;}
    
    public boolean ViewAll{get; set;}
    public boolean ShowLess{get; set;}
   // public boolean errorgot {set;get;}
   
   public boolean isreqdateEditable {set;get;}
   public boolean isduedateEditable {set;get;}
   
   public list<inlinewrapper> lst{set;get;}
   public integer rowIndex{get;set;}
   public string qtEditField {get;set;}
   inlinewrapper ineditqtobj;
    // End Global Variables 
    
    // Start constructor
    public DisplayQuoteUnderJobTab() 
    {
        ViewAll=True;
        ShowLess=False;
        isreqdateEditable =false;
        isduedateEditable =false;
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate =activeSettings.Active__c;
        
        theID = ApexPages.CurrentPage().getParameters().get('id');
        q=[select id,Name,Approved__c,GL_Department__c,GL_Department__r.Name,Unit_Type__c,GL_Code__r.Name,Job__c,Amount__c,Request_Date__c,Due_Date__c from Quote__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name LIMIT:5];
        q2=[select id,Name,Approved__c,GL_Department__c,GL_Department__r.Name,Unit_Type__c,GL_Code__r.Name,Job__c,Amount__c,Request_Date__c,Due_Date__c from Quote__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];
        
        lst=new list<inlinewrapper>();
        
        for(integer i=0;i<q.size();i++){
            ineditqtobj=new inlinewrapper();
            ineditqtobj.qtrec=q[i];
            ineditqtobj.rowNo=i;
            ineditqtobj.isEditReq=false;
            ineditqtobj.isEditDue=false;
            lst.add(ineditqtobj);
       }
     }
    
    
    public class inlinewrapper{
    
    public Quote__c qtrec {get;set;}
    public integer rowNo  {get;set;}
    public boolean isEditReq {get;set;}
    public boolean isEditDue {get;set;}   
    
    }
    
  
 
  public pagereference inlineQuoteEdit(){
    if(lst.size()>rowIndex){ 
     if(qtEditField=='QuoteRequestDate'){
         lst[rowIndex].isEditReq=true;
      }
     if(qtEditField=='QuoteDueDate'){
         lst[rowIndex].isEditDue=true;
      }
   }
   return null;
 }
 
 
  public pagereference inlineQuoteSave(){
  try{
      if(lst.size()>rowIndex){ 
         if(qtEditField=='QuoteRequestDate'){
            update lst[rowIndex].qtrec;  
             lst[rowIndex].isEditReq=false;
           }
         if(qtEditField=='QuoteDueDate'){
             update lst[rowIndex].qtrec;  
             lst[rowIndex].isEditDue=false;
            }
       }
     }
    catch(System.DMLException e)
      {
       return null;
      }
    return null;
 }
 

 
    
    
    
    // End Constructor
    
    // show All Quotes for View All Link
    Public void ViewAllQuote()
    {
        ViewAll=False;
        ShowLess=True;
        
        q=[select id,Name,Approved__c,GL_Department__c,GL_Department__r.Name,Unit_Type__c,GL_Code__r.Name,Job__c,Amount__c,Request_Date__c,Due_Date__c from Quote__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];
    
        lst.clear();
       for(integer i=0;i<q.size();i++){
            ineditqtobj=new inlinewrapper();
            ineditqtobj.qtrec=q[i];
            ineditqtobj.rowNo=i;
            ineditqtobj.isEditReq=false;
            ineditqtobj.isEditDue=false;
            lst.add(ineditqtobj);
             
        
        } 
    
    }
    
    Public void ShowLessQuote()
    {
        ViewAll=True;
        ShowLess=False;
        
        q=[select id,Name,Approved__c,GL_Department__c,GL_Department__r.Name,Unit_Type__c,GL_Code__r.Name,Job__c,Amount__c,Request_Date__c,Due_Date__c from Quote__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name LIMIT:5];
   
        lst.clear();
       for(integer i=0;i<q.size();i++){
            ineditqtobj=new inlinewrapper();
            ineditqtobj.qtrec=q[i];
            ineditqtobj.rowNo=i;
            ineditqtobj.isEditReq=false;
            ineditqtobj.isEditDue=false;
            lst.add(ineditqtobj);
             
        
        } 
    }
    
    
    
   
    
    
    public void Del()
    {
        List<Quote__c> DelQuLI= [select id,Name,Approved__c,GL_Department__c,GL_Department__r.Name,Unit_Type__c,GL_Code__r.Name,Job__c,Amount__c,Request_Date__c,Due_Date__c from Quote__c where id =: strPEID Limit 1];
        try
        {
            Database.delete(DelQuLI);
            
             q=new list<Quote__c>();
             q2=new list<Quote__c>();
             if(ViewAll)
             {
                  q=[select id,Name,Approved__c,GL_Department__c,GL_Department__r.Name,Unit_Type__c,GL_Code__r.Name,Job__c,Amount__c,Request_Date__c,Due_Date__c from Quote__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name LIMIT:5];
                  q2=[select id,Name,Approved__c,GL_Department__c,GL_Department__r.Name,Unit_Type__c,GL_Code__r.Name,Job__c,Amount__c,Request_Date__c,Due_Date__c from Quote__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];
           
                 lst.clear();
               for(integer i=0;i<q.size();i++){
                    ineditqtobj=new inlinewrapper();
                    ineditqtobj.qtrec=q[i];
                    ineditqtobj.rowNo=i;
                    ineditqtobj.isEditReq=false;
                    ineditqtobj.isEditDue=false;
                    lst.add(ineditqtobj);
                     
                
                } 
        
        
             }
             else
             {
                 q=[select id,Name,Approved__c,GL_Department__c,GL_Department__r.Name,Unit_Type__c,GL_Code__r.Name,Job__c,Amount__c,Request_Date__c,Due_Date__c from Quote__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];
                 q2=q;
                   lst.clear();
                   for(integer i=0;i<q.size();i++){
                        ineditqtobj=new inlinewrapper();
                        ineditqtobj.qtrec=q[i];
                        ineditqtobj.rowNo=i;
                        ineditqtobj.isEditReq=false;
                        ineditqtobj.isEditDue=false;
                        lst.add(ineditqtobj);
                         
                    
                    } 
             }
            
           //ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.info,''+q.size()));
           //ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.info,''+q2.size()));
        }
        catch(System.DMLException e)
        {
            apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
        
    }
    
    
 /*   public void UnApprove()
    {
    
         List<Quote__c> updateQuLI=new List<Quote__c>();
         
         List<Quote__c> UnQuLI= [select id,Name,Approved__c,GL_Department__c,GL_Department__r.Name,Unit_Type__c,GL_Code__r.Name,Job__c,Amount__c,Request_Date__c,Due_Date__c from Quote__c where id =: strPEID Limit 1];
            
         for(Quote__c QLI:UnQuLI)
         {
            QLI.Approved__c=False;
            updateQuLI.add(QLI);
         }
            
            
         if(updateQuLI.size() > 0) 
         {   
        
              try
              {
                     update updateQuLI;
                     q=new list<Quote__c>();
                     q2=new list<Quote__c>();
                     if(ViewAll)
                     {
                          q=[select id,Name,Approved__c,GL_Department__c,GL_Department__r.Name,Unit_Type__c,GL_Code__r.Name,Job__c,Amount__c,Request_Date__c,Due_Date__c from Quote__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name LIMIT:5];
                          q2=[select id,Name,Approved__c,GL_Department__c,GL_Department__r.Name,Unit_Type__c,GL_Code__r.Name,Job__c,Amount__c,Request_Date__c,Due_Date__c from Quote__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];
                            lst.clear();
                           for(integer i=0;i<q.size();i++){
                                ineditqtobj=new inlinewrapper();
                                ineditqtobj.qtrec=q[i];
                                ineditqtobj.rowNo=i;
                                ineditqtobj.isEditReq=false;
                                ineditqtobj.isEditDue=false;
                                lst.add(ineditqtobj);
                                 
                            
                            } 
                     }
                     else
                     {
                         q=[select id,Name,Approved__c,GL_Department__c,GL_Department__r.Name,Unit_Type__c,GL_Code__r.Name,Job__c,Amount__c,Request_Date__c,Due_Date__c from Quote__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];
                         q2=q;
                         lst.clear();
                           for(integer i=0;i<q.size();i++){
                                ineditqtobj=new inlinewrapper();
                                ineditqtobj.qtrec=q[i];
                                ineditqtobj.rowNo=i;
                                ineditqtobj.isEditReq=false;
                                ineditqtobj.isEditDue=false;
                                lst.add(ineditqtobj);
                                 
                            
                            } 
                     }
              }
          
              catch(System.DMLException e)
              {
                  apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
              }
              
              
              if(ShowProductionEstimate)
              {
                  List<Production_Estimate__c> pest = [select id,Name,Quote__c from Production_Estimate__c where Quote__c =: strPEID ];
                  delete pest;
              }
              else
              {
                  List<Estimate_Line_Items__c> est = [select id,Name,Quote__c from Estimate_Line_Items__c where Quote__c =: strPEID ];
                  delete est;
              }
              Vendor_Quote__c vq=[select id,Name,Quote__c,Restrict__c from Vendor_Quote__c where Quote__c =: strPEID and Restrict__c=true];
               vq.Restrict__c=false;
               update vq;
                      
                      }
        
    }
    
  */  
    
  /*   public void closePopup() {
        displayPopup = false;
    }

    public void showPopup() {
        displayPopup = true;
    }
    
*/
    
    
   // Method calles on to create Quote
   
    // This method is called on to handle Create Quote button
  
  
    public PageReference CreateQuote() 
    {
       String jobid;
       String theId=ApexPages.CurrentPage().getParameters().get('id');
       
       Job__c job = [Select Id from Job__c where id =: theID];
       jobid=job.Id;
       
       
        if(isLtng)
        {
              PageReference p = Page.CreateNewQuoteLightning;
              p.setredirect(true);
              p.getParameters().put('jobid',theID); 
              return p;
        }
        else
        {
                PageReference p = Page.CreateNewQuote;
                p.setredirect(true);
                p.getParameters().put('jobid',theID); 
                return p;
        }
       
     
      
    }
    // End createQuote method
    
 
   
    // Method called on to save Quote
    
   
  
  
   public PageReference save()
   {
   
     try
     {
     
           if(isLtng){
             update(q);
             q=[select id,Name,Approved__c,GL_Department__c,GL_Department__r.Name,Unit_Type__c,GL_Code__r.Name,Job__c,Amount__c,Request_Date__c,Due_Date__c from Quote__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name ];
           }
           else{
             update(q2);
             q2=[select id,Name,Approved__c,GL_Department__c,GL_Department__r.Name,Unit_Type__c,GL_Code__r.Name,Job__c,Amount__c,Request_Date__c,Due_Date__c from Quote__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name ];
           }
       
     }
     catch(System.DMLException e)
     {
    
      return null;
     
     }
     
  return null;
   
    }
    // End save method
    

  
  
  
  
    // Test Coverage Code
  /*static testMethod void DisplayQuote()
    {
          DisplayQuoteUnderJobTab ext=new DisplayQuoteUnderJobTab();
           
          Media_Type__c testMedia=new Media_Type__c(Name='Test Media 348');
             
                insert testMedia;
             
          Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 348',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 348');
                insert testSpec;
       
          Job__c testJob1=new Job__c(Name='Test Job 348',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
               }
               
          System.assertEquals('Test Job 348',testJob1.Name);
           
          GL_Department__c testGLD = new GL_Department__c(Name='TestGLD348');
            try
            {
                insert testGLD;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }

           GL_Code__c testGL=new GL_Code__c(Name='Test GL Code 348',GL_ID__c='Test GL348',GL_Department__c=testGLD.id);
               insert testGL;
               
            Quote__c testQ=new Quote__c(Name='Quote 348',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Approved__c=false,Quantity__c=5000.00,GL_Code__c=testGL.Id);
            insert testQ;
            
           ApexPages.currentPage().getParameters().put('Id',testJob1.Id);
           
           // Instantiate the extention instance with the Custom Controller
           
           DisplayQuoteUnderJobTab ext1=new DisplayQuoteUnderJobTab();
          
           // Invoke the primary method on the extension
           
           ApexPages.PageReference result1=ext1.CreateQuote();
          
           result1=ext1.save();
           
           delete testQ;
           result1=ext1.save();
           result1=ext1.cancelme();           
    }  // End of test Method   */
}
//End of Class
// This class is used to Display PO under Jobs Tab
public with sharing class DisplayPOunderjobtabextension
{
    
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
    
    
    // Global variables
    public string strID{get;set;}
    public String poid{get;set;}
    public List<Purchase_Order__c> purchaseorder{get;set;} 
    public List<Purchase_Order__c> purchaseorder1{get;set;} 
    String theID;
    
    
    public integer porowIndex {set;get;}
    public list<inlineWrapperPO> porderlst {set;get;}
    public string editPOField {set;get;}
    
    inlineWrapperPO inlinepoobj;
    public boolean ViewAll{get; set;}
    public boolean ShowLess{get; set;}
    // End of Global variables

    // Start constructor
    public DisplayPOunderjobtabextension()
    {
        ViewAll=True;
        ShowLess=False;
    
        theID = ApexPages.CurrentPage().getParameters().get('id');
        purchaseorder = [Select id,Name,Due_Date__c,Issue_Date__c,job__c,Status__c,Total_Amount__c,Vendor__c,Approved_By_Staff__c,Invoice_Created__c from Purchase_Order__c where Job__c =: theID Order By CreatedDate desc,Name limit:5];
        purchaseorder1 = [Select id,Name,Due_Date__c,Issue_Date__c,job__c,Status__c,Total_Amount__c,Vendor__c,Approved_By_Staff__c,Invoice_Created__c from Purchase_Order__c where Job__c =: theID Order By CreatedDate desc,Name];
        
       
        porderlst=new list<inlineWrapperPO>();
        
        for(integer i=0;i<purchaseorder.size();i++){
          inlinepoobj=new inlineWrapperPO();
          inlinepoobj.porec=purchaseorder[i];
          inlinepoobj.porowNo=i;         
          inlinepoobj.isEditPOIssDt=false;    
          inlinepoobj.isEditPODueDt=false;    
          inlinepoobj.isEditPOStatus=false;
          porderlst.add(inlinepoobj);
        
        }
    }
    // End of constructor
    
   
    
    public PageReference inlineEditPO(){
    
     if(editPOField=='IssueDate'){
         porderlst[porowIndex].isEditPOIssDt=true;
       }
     if(editPOField=='DueDate'){
         porderlst[porowIndex].isEditPODueDt=true;
       }
     if(editPOField=='Status'){
         porderlst[porowIndex].isEditPOStatus=true;
       }
    return null;
    }
    
    
   public PageReference inlineSavePO(){
    
   try{
        if(editPOField=='IssueDate'){
           update  porderlst[porowIndex].porec;
           porderlst[porowIndex].isEditPOIssDt=false;
           }
       if(editPOField=='DueDate'){
           update  porderlst[porowIndex].porec;
           porderlst[porowIndex].isEditPODueDt=false;
           }
       if(editPOField=='Status'){
           update  porderlst[porowIndex].porec;
           porderlst[porowIndex].isEditPOStatus=false;
           }
     }
     catch(System.DMLException e){
        return null;
     }
    return null;
    }
    
    
    
    public class inlineWrapperPO{
     public Purchase_Order__c  porec {get; set;}
     public integer porowNo          {get; set;}
     public boolean isEditPOIssDt    {get; set;}
     public boolean isEditPODueDt    {get; set;}
     public boolean isEditPOStatus   {get; set;}
    
    }
    
    
    Public void ViewAllPO()
    {
        ViewAll=False;
        ShowLess=True;
        
        purchaseorder = [Select id,Name,Due_Date__c,Issue_Date__c,job__c,Status__c,Total_Amount__c,Vendor__c,Approved_By_Staff__c,Invoice_Created__c from Purchase_Order__c where Job__c =: theID Order By CreatedDate desc,Name];
           porderlst.clear();
           for(integer i=0;i<purchaseorder.size();i++){
              inlinepoobj=new inlineWrapperPO();
              inlinepoobj.porec=purchaseorder[i];
              inlinepoobj.porowNo=i;         
              inlinepoobj.isEditPOIssDt=false;    
              inlinepoobj.isEditPODueDt=false;    
              inlinepoobj.isEditPOStatus=false;
              porderlst.add(inlinepoobj);
            
            } 
   
    }
    
    Public void ShowLessPO()
    {
        ViewAll=True;
        ShowLess=False;
        
        purchaseorder = [Select id,Name,Due_Date__c,Issue_Date__c,job__c,Status__c,Total_Amount__c,Vendor__c,Approved_By_Staff__c,Invoice_Created__c from Purchase_Order__c where Job__c =: theID Order By CreatedDate desc,Name limit:5];
           porderlst.clear();
           for(integer i=0;i<purchaseorder.size();i++){
              inlinepoobj=new inlineWrapperPO();
              inlinepoobj.porec=purchaseorder[i];
              inlinepoobj.porowNo=i;         
              inlinepoobj.isEditPOIssDt=false;    
              inlinepoobj.isEditPODueDt=false;    
              inlinepoobj.isEditPOStatus=false;
              porderlst.add(inlinepoobj);
            
            } 
    
    }
    
    
    
   

    Sobject sumCash; 

   // This method is called on to calculate Total Amount of Purchase Order
   public double getSumCash()
   { 
        sumCash = [SELECT SUM(Total_Amount__c) sum FROM Purchase_Order__c WHERE Job__c =: [Select id from Job__c where id =: theID]];   
        return double.valueOf(sumCash.get('sum')); 
    }  
    // End of method getSumCash
    
    //Method to create Invoice for PO Line Items
   public Pagereference CreateInvoice()
    {
    /*
         PageReference p =  new Pagereference('/apex/CreateInvoiceFromPO?id='+strID);
         p.setRedirect(true);
         return p; 
         */
         Pagereference p;
        if(isLtng)
        {
             p=Page.createInvoiceFromPOLightning;
             // p.setRedirect(true);
             // p.getParameters().put('POid',strID);
              //return p;
        }
        else
        {
             p=Page.createInvoiceFromPO;
             // p.setRedirect(true);
             // p.getParameters().put('POid',strID);
              //return p;
        } 
               p.setRedirect(true);
              p.getParameters().put('POid',strID);
              return p;
        
          
    }  
    //End of Create PO Method    

    //Method to Create PO
     public PageReference CreatePO()
    {
         String jobid;
         String theId=ApexPages.CurrentPage().getParameters().get('id');
         //Purchase_Order__c po = new Purchase_Order__c();
         Job__c job = [Select Id from Job__c where id =: theID];
         jobid=job.Id;
         
        PageReference p;         
        if(isLtng)
        {
             p= Page.CreateNewPurchaseOrderLightning;
             //p.setredirect(true);
             //p.getParameters().put('jobid',theID); 
            // return p;
        }
        else
        {
             p=Page.CreateNewPurchaseOrder;
             //p.setredirect(true);
             //p.getParameters().put('jobid',theID); 
             //return p;
        } 
             p.setredirect(true);
             p.getParameters().put('jobid',theID); 
             return p;
       
        
    }
    //End of Create PO Method    
    
    //Method for Inline Save Method    
    public PageReference save()
    {
     try
      {
      
          if(isLtng){
           update purchaseorder;
           }
           else{
           update purchaseorder1;
           }
      }
     catch(System.DMLException e)
      {
           return null;
      }
      // After updating PO, navigate to Purchase Order Tab
      
      
      PageReference p;
        if(isLtng)
        {
             p=new Pagereference('/apex/JobdetailpageLightening07?id='+theID+'&tab=Jobcost'+'&section=purchaseorders');
              //p.setRedirect(true);
             // return p;     
        }
        else
        {
            p =  new Pagereference('/apex/JobListView?id='+theid+'&intFocus=6');
              //p.setRedirect(true);
             // return p; 
        } 
              p.setRedirect(true);
              return p;
      
    }
    //End Of Save Method    
    
    //Method to Delete PO Line Items    
    public PageReference del()
    {
      
        List<Purchase_Order__c> delpo = [Select id,Name from Purchase_Order__c where id =: poid limit 1];
        try
        {
            Database.delete(delpo);   
            
             purchaseorder =new list<Purchase_Order__c >();
             if(ViewAll)
             {
                   purchaseorder = [Select id,Name,Due_Date__c,Issue_Date__c,job__c,Status__c,Total_Amount__c,Vendor__c,Approved_By_Staff__c,Invoice_Created__c from Purchase_Order__c where Job__c =: theID Order By CreatedDate desc,Name limit:5];
                   purchaseorder1 = [Select id,Name,Due_Date__c,Issue_Date__c,job__c,Status__c,Total_Amount__c,Vendor__c,Approved_By_Staff__c,Invoice_Created__c from Purchase_Order__c where Job__c =: theID Order By CreatedDate desc,Name];
             }
             else
             {
                 purchaseorder = [Select id,Name,Due_Date__c,Issue_Date__c,job__c,Status__c,Total_Amount__c,Vendor__c,Approved_By_Staff__c,Invoice_Created__c from Purchase_Order__c where Job__c =: theID Order By CreatedDate desc,Name];
                 purchaseorder1 = purchaseorder;
             }
             
             if(isLtng)
            {
                 PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+theid+'&tab=Jobcost'+'&section=purchaseorders');
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
        catch(System.DMLException e)
        {
            apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }
        
        
        
        
    }
    //End Of Delete Method

    //Method For Cancel button    
     public PageReference cancelme()
     {
          PageReference p;
         if(isLtng)
        {
               p=new Pagereference('/apex/JobdetailpageLightening07?id='+theID+'&tab=Jobcost'+'&section=purchaseorders');
              //p.setRedirect(true);
              //return p;     
        }
        else
        {
              p =new Pagereference('/apex/JobListView?id='+theid+'&intFocus=6');
              //p.setRedirect(true);
              //return p; 
        } 
          p.setRedirect(true);
          return p;  
     }
    //End Of Cancel Buttons method    
 
     // Test Method 
     static testMethod void DisplayPO()
    {
           DisplayPOunderjobtabextension ext=new DisplayPOunderjobtabextension();
           
           Media_Type__c testMedia=new Media_Type__c(Name='Test Media 361');
             
                insert testMedia;
             
           Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 361',Media_Types__c=testMedia.Id);
             
                 insert testST;
       
          Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 361');
          
                insert testSpec;
          
          Job__c testJob1=new Job__c(Name='Test Job 361',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
              try
               {
                   insert testJob1;
               }
              catch(System.DMLException e)
               {
                   System.assert(e.getMessage().contains('Job with same name Exists'));
               }
           System.assertEquals('Test Job 361',testJob1.Name);
           
           ApexPages.currentPage().getParameters().put('Id',testJob1.Id);
           
               // Instantiate the extention instance with the Custom Controller
          //DisplayPOunderjobtabextension ext1=new DisplayPOunderjobtabextension();
           
            // Invoke the primary method on the extension
            Purchase_Order__c po=new Purchase_Order__c(Job__c=testJob1.id,Name='Test PO 361');
            insert po;
            System.assertEquals('Test PO 361',po.name);
        
              DisplayPOunderjobtabextension ext1=new DisplayPOunderjobtabextension();
            
           ApexPages.PageReference result1=ext1.CreatePO();
           result1 = ext1.save();
           result1= ext1.createInvoice();
           result1 = ext1.cancelme();
           ext1.poid=po.id;
        //   result1=ext1.del();
           result1=ext1.save();
           ext1.porowIndex=0;
            ext1.editPOField='Status';
            ext1.inlineEditPO();
            ext1.inlineSavePO();
            ext1.editPOField='IssueDate';
            ext1.inlineEditPO();
            ext1.inlineSavePO();
            ext1.editPOField='DueDate';
            ext1.inlineEditPO();
            ext1.inlineSavePO();
             ext1.ViewAllPO();
             ext1.ShowLessPO();
           result1=ext1.del();
           Double result2=ext1.getSumCash();
             
           
     } // End of test Method 
}// End of Class
// This class is used in Display Invoice under Job Tab 
public with sharing class DisplayInvoiceunderjobtabExtension 
{
   public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
   
   // Global variables
     public List<Invoice__c> invoice{get;set;} 
     public List<Invoice__c> inv{get;set;}
     String theID;
     public String Delinvid{get;set;}
     
    public integer invrowIndex {set;get;}
    public list<inlineWrapperInv> invlst {set;get;}
    inlineWrapperInv inlineinvobj;
     
     public boolean ViewAll{get; set;}
     public boolean ShowLess{get; set;}
    // End of Global variables
   
   // Start constructor
    public DisplayInvoiceunderjobtabExtension()
     {
         ViewAll=True;
         ShowLess=False;
       
         theID = ApexPages.CurrentPage().getParameters().get('id');
         invoice = [Select id,Name,Vendor__c,Purchase_Order__r.Name,Vendor__r.Name,Job__c,Date_Received__c,Revised_Amount__c,Purchase_Order__c,Due_Date__c,Total_Amount__c,(select id, name from Invoice_Line_Items__r) from Invoice__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name LIMIT:5 ];
         inv = [Select id,Name,Vendor__c,Purchase_Order__r.Name,Vendor__r.Name,Job__c,Date_Received__c,Revised_Amount__c,Purchase_Order__c,Due_Date__c,Total_Amount__c,(select id, name from Invoice_Line_Items__r) from Invoice__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];
        
         invlst =new list<inlineWrapperInv>();
         
             for(integer i=0;i<invoice.size();i++){
               inlineinvobj=new inlineWrapperInv();
               inlineinvobj.invrec=invoice[i];
               inlineinvobj.invrowNo=i;
               inlineinvobj.isEditRecDate=false;
               invlst.add(inlineinvobj);
             }
       
       }
     // End of constructor
     
     
    public PageReference inlineEditInv(){
        invlst[invrowIndex].isEditRecDate=true;
        return null;
      }
      
      
    public PageReference inlinesaveInv(){
      try{
          update invlst[invrowIndex].invrec;
          invlst[invrowIndex].isEditRecDate=false;
         }
       catch(System.DMLException e){
         return null;
         }
         return null;
     }
     
     public class inlineWrapperInv{
     
     public Invoice__c  invrec {set;get;}
     public boolean isEditRecDate {set;get;}
     public integer invrowNo {set;get;}
   
     }
     
     
        Public void ViewAllInv()
        {
            ViewAll=False;
            ShowLess=True;
            
             invoice = [Select id,Name,Vendor__c,Purchase_Order__r.Name,Vendor__r.Name,Job__c,Date_Received__c,Revised_Amount__c,Purchase_Order__c,Due_Date__c,Total_Amount__c,(select id, name from Invoice_Line_Items__r) from Invoice__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];
             invlst.clear();
             for(integer i=0;i<invoice.size();i++){
               inlineinvobj=new inlineWrapperInv();
               inlineinvobj.invrec=invoice[i];
               inlineinvobj.invrowNo=i;
               inlineinvobj.isEditRecDate=false;
               invlst.add(inlineinvobj);
             }
        
        }
        
        Public void ShowLessInv()
        {
            ViewAll=True;
            ShowLess=False;
            
         invoice = [Select id,Name,Vendor__c,Purchase_Order__r.Name,Vendor__r.Name,Job__c,Date_Received__c,Revised_Amount__c,Purchase_Order__c,Due_Date__c,Total_Amount__c,(select id, name from Invoice_Line_Items__r) from Invoice__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name LIMIT:5 ];
             invlst.clear();
             for(integer i=0;i<invoice.size();i++){
               inlineinvobj=new inlineWrapperInv();
               inlineinvobj.invrec=invoice[i];
               inlineinvobj.invrowNo=i;
               inlineinvobj.isEditRecDate=false;
               invlst.add(inlineinvobj);
             }
       
       
        }
 
 
         
 
 
 
     Sobject sumCash3,sumCash4; 
     public double getSumCash3()
      { 
           sumCash3 = [SELECT SUM(Revised_Amount__c) sum3 FROM Invoice__c WHERE Job__c =: [Select id from Job__c where id =: theID]];   
           return double.valueOf(sumCash3.get('sum3')); 
      } 
      
       public double getSumCash4()
      { 
           sumCash4 = [SELECT SUM(Total_Amount__c) sum4 FROM Invoice__c WHERE Job__c =: [Select id from Job__c where id =: theID]];   
           return double.valueOf(sumCash4.get('sum4')); 
      }   
 
       // This method is called on to handle Create Invoice button
       public PageReference CreateInvoice()
       {
           String jobid;
           String theId=ApexPages.CurrentPage().getParameters().get('id');
      
           Job__c job = [Select Id from Job__c where id =: theID];
           jobid=job.Id;
           
       PageReference p;
        if(isLtng)
           p =Page.CreateNewInvoiceLightning;
           
         else
           p=Page.CreateNewInvoice;
         
           p.setredirect(true);
           p.getParameters().put('jobid',theID); 
           return p;
      }
      // End of method CreateInvoice
      
       //Method to Delete Invoice    
    public void del()
    {
        System.Debug('Deleteinvoiceid======================='+Delinvid);
        Invoice__c   delinv = [Select id,Name from Invoice__c  where id =: Delinvid];
        delete delinv; 
        
        
         if(ViewAll)
         {
              invoice = [Select id,Name,Vendor__c,Purchase_Order__r.Name,Vendor__r.Name,Job__c,Date_Received__c,Revised_Amount__c,Purchase_Order__c,Due_Date__c,Total_Amount__c,(select id, name from Invoice_Line_Items__r) from Invoice__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name LIMIT:5 ];
              inv = [Select id,Name,Vendor__c,Purchase_Order__r.Name,Vendor__r.Name,Job__c,Date_Received__c,Revised_Amount__c,Purchase_Order__c,Due_Date__c,Total_Amount__c,(select id, name from Invoice_Line_Items__r) from Invoice__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];
             
             invlst.clear();
             for(integer i=0;i<invoice.size();i++){
               inlineinvobj=new inlineWrapperInv();
               inlineinvobj.invrec=invoice[i];
               inlineinvobj.invrowNo=i;
               inlineinvobj.isEditRecDate=false;
               invlst.add(inlineinvobj);
             }
         
         }
         else
         {
             invoice = [Select id,Name,Vendor__c,Purchase_Order__r.Name,Vendor__r.Name,Job__c,Date_Received__c,Revised_Amount__c,Purchase_Order__c,Due_Date__c,Total_Amount__c,(select id, name from Invoice_Line_Items__r) from Invoice__c where Job__c =: [Select id from Job__c where id =: theID] Order By CreatedDate desc,Name];
             inv =invoice ;
             
             invlst.clear();
             for(integer i=0;i<invoice.size();i++){
               inlineinvobj=new inlineWrapperInv();
               inlineinvobj.invrec=invoice[i];
               inlineinvobj.invrowNo=i;
               inlineinvobj.isEditRecDate=false;
               invlst.add(inlineinvobj);
             }
         }
        
        
         // After deleting invoice, navigate to invoice Tab
       /* PageReference p =  new Pagereference('/apex/JobListView?id='+theid+'&intFocus=7');
        p.setRedirect(true);
        return p;*/
    }
    //End Of Delete Method
      

       // This method is called on to update Invoice record
        public PageReference save()
        {
             try
             {  
             
              if(isLtng){
                    update invoice;
                }
                else{
                    update inv;
                  }
             }
             catch(System.DMLException e){ return null; }
            // After updating Invoice navigate to Invoices Tab
            
            
            if(isLtng)
            {
                 PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+theid+'&tab=Jobcost'+'&section=vendorinvoices');
                 p.setRedirect(true);
                 return p; 
            }
            else
            {
                    PageReference p =  new Pagereference('/apex/JobListView?id='+theid+'&intFocus=7');
                    p.setRedirect(true);
                    return p; 
            }
            
            
            
        }
        // ENd of method Save
    
     // This method is called on to handle Cancel Button
     Public PageReference cancelme()
     {
            if(isLtng)
            {
                 PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+theid+'&tab=Jobcost'+'&section=vendorinvoices');
                 p.setRedirect(true);
                 return p; 
            }
            else
            {
                    PageReference p =  new Pagereference('/apex/JobListView?id='+theid+'&intFocus=7');
                    p.setRedirect(true);
                    return p; 
            }     
      }
      // End of method Cancel
    
  
}
//End of Apex class
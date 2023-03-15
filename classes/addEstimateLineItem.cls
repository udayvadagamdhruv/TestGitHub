// This apex class is used to add Estimate Line Item
public with sharing class addEstimateLineItem 
{

   public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            } 



    //Global variables
    public String poid{get;set;}
    public List<ELIWrapper> rolewraps{get;set;}
    //public PO_Line_Item__c stRole{get;set;}
    public List<PO_Line_Item__c> lst{get;set;}
    public List<Estimate_Line_Items__c> ELIlst{get;set;}
    public ScheduleTaskRole__c stc;
    String strSTId,strid;
    Purchase_Order__c p = new Purchase_Order__c();
    // End of Global variables

   // Start Constructor 
   public addEstimateLineItem()
   {
       poid = ApexPages.currentPage().getParameters().get('id');
       roleWraps=new List<ELIWrapper>();
    
       p = [Select id,Name,Job__c,Vendor__c from Purchase_Order__c where id =: poid];
    
       List<Estimate_Line_Items__c> ELI=[Select id,Name,Amount__c,Vendor__c,Job__c,Approved__c,Total_Amount__c,GL_Code__c, Quantity__c, Unit_Type__c From Estimate_Line_Items__c where Vendor__c =: p.Vendor__c and Job__c =: p.Job__c and Approved__c = true and PO_Created__c = false Order By Name];
       
       for(Estimate_Line_Items__c e: ELI)
       {
            ELIWrapper rw=new ELIWrapper();
            rw.e=e;
            rw.checked=false;
            roleWraps.add(rw);        
       }
   }
   // End Constructor 

    // Start Wrapper Class 
     public class ELIWrapper
     {
         public Estimate_Line_Items__c e{get;set;}
         public Boolean checked{get;set;}
     }
     // End of Wrapper Class

    // Save Method
    public pagereference Save()
     {
       try
       {
        lst=new List<PO_Line_Item__c>();
        for(ELIWrapper rw:roleWraps)
         {
           
            if(rw.checked==true)
            {
                PO_Line_Item__c stRole=new PO_Line_Item__c();
                stRole.Estimate_Line_Item__c=rw.e.id;
                stRole.Amount__c=rw.e.Total_Amount__c;
                stRole.GL_Code__c=rw.e.GL_Code__c;
                stRole.Purchase_Order__c=ApexPages.currentPage().getParameters().get('id');
                lst.add(stRole);
            }
         }
         System.debug('Inserted value @@@ '+lst);
         insert lst;
   
             if(isLtng){
                PageReference p =  new Pagereference('/apex/PODetailPageLightning?id='+poid);
                p.setRedirect(true);
                return p;
                }
                
             else{
             
                PageReference p =  new Pagereference('/apex/PODetailPage?id='+poid);
                p.setRedirect(true);
                return p;
             
             }   
        
     
    }
    catch(DMLException e)
    {
        return null;
    }    
 }
 // End of Save Method
 
     // Method called on to handle Back Button
   public pagereference Back()
  {
  
           if(isLtng){
              PageReference p =  new Pagereference('/apex/PODetailPageLightning?id='+poid);
              p.setRedirect(true);
              return p;
          }
          else{
          
           PageReference p =  new Pagereference('/apex/PODetailPage?id='+poid);
              p.setRedirect(true);
              return p;
          }
  }
  // End of Back
   
}
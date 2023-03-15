public with sharing class addProductionEstimateLineItem {

/*
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
    public List<Production_Estimate__c> PELIlst{get;set;}
    public ScheduleTaskRole__c stc;
    String strSTId,strid;
    Purchase_Order__c p = new Purchase_Order__c();
    // End of Global variables

   // Start Constructor 
   public addProductionEstimateLineItem ()
   {
       poid = ApexPages.currentPage().getParameters().get('id');
       roleWraps=new List<ELIWrapper>();
    
       p = [Select id,Name,Job__c,Vendor__c from Purchase_Order__c where id =: poid];
    
       List<Production_Estimate__c> ELI=[Select id,Name,Total_cost__c,Vendor__c,Job__c,Approved__c,GL_Code__c, Quantity__c From Production_Estimate__c where Vendor__c =: p.Vendor__c and Job__c =: p.Job__c and Approved__c = true and PO_Created__c = false Order By Name];
       
       for(Production_Estimate__c e: ELI)
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
         public Production_Estimate__c e{get;set;}
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
           
            if(rw.checked == true)
            {
                PO_Line_Item__c stRole=new PO_Line_Item__c();
                if(schema.SobjectType.PO_Line_Item__c.Fields.Production_Estimate__c.isCreateable()){ 
                    stRole.Production_Estimate__c=rw.e.id;
                }
                if(schema.SobjectType.PO_Line_Item__c.Fields.Amount__c.isCreateable()){ 
                    stRole.Amount__c=rw.e.Total_Cost__c;
                }
                if(schema.SobjectType.PO_Line_Item__c.Fields.GL_Code__c.isCreateable()){ 
                    stRole.GL_Code__c=rw.e.GL_Code__c;
                }
                if(schema.SobjectType.PO_Line_Item__c.Fields.Purchase_Order__c.isCreateable()){ 
                    stRole.Purchase_Order__c=ApexPages.currentPage().getParameters().get('id');
                }
                lst.add(stRole);
            }
         }
           System.debug('Inserted value @@@ '+lst);
           if(Schema.sObjectType.PO_Line_Item__c.isCreateable()){
               insert lst;
           }
   
   
   
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
*/



}
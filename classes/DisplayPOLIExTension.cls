// This method is used to display Purchase Order Line Items for selected PO
public with sharing class DisplayPOLIExTension 
{

    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
    



         // Global variables 
        Public String theID;
        public List<PO_Line_Item__c> POLI{get;set;} 
        public String strPOLI{get;set;}
        Public Boolean ShowProductionEstimate{get;set;}
        // End Global variables 
        
        // Start Constructor 
        public DisplayPOLIExTension() 
        {
             theID = ApexPages.CurrentPage().getParameters().get('id');
            
             ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
             ShowProductionEstimate =activeSettings.Active__c;
         
             if(ShowProductionEstimate){
              POLI=[select id,Name,Purchase_Order__c,Estimate_Line_Item__c,Estimate_Line_Item__r.name,Amount__c,Invoice_Created__c,GL_Code__c,Quantity_production__c,Unit_Type__c,Quantity__c,Production_Estimate__c from PO_Line_Item__c where Purchase_Order__c =: theID and Production_Estimate__c !=null  ORDER BY Name];
             }
             else{
              POLI=[select id,Name,Purchase_Order__c,Estimate_Line_Item__c,Estimate_Line_Item__r.name,Amount__c,Invoice_Created__c,GL_Code__c,Quantity_production__c,Unit_Type__c,Quantity__c,Production_Estimate__c from PO_Line_Item__c where Purchase_Order__c =: theID and Estimate_Line_Item__c!=null ORDER BY Name];
             }
          //  Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.info,''+ShowProductionEstimate));
        }
        // End Constructor

        // THis methos is called on to Add Estimate Line Item
        public PageReference add_ELI()
        {
        
          if(isLtng){
            PageReference p =  Page.addEstimateLineItemLightning;p.setRedirect(true);
            p.getParameters().put('id',theID);
            return p;
            }
            
           else{
           PageReference p =  Page.addEstimateLineItem;
            p.setRedirect(true);
            p.getParameters().put('id',theID);
            return p;
           
           }
        }
        // End method add_ELI 
        
        // THis methos is called on to Add Production Estimate Line Item
        public PageReference add_PELI()
        {
          if(isLtng){
            PageReference p =  Page.addProductionEstimateLineItemLightning;p.setRedirect(true);
            p.getParameters().put('id',theID);
            return p;
            }
            
            else{
            PageReference p =  Page.addProductionEstimateLineItem;
            p.setRedirect(true);
            p.getParameters().put('id',theID);
            return p;
            
            }
        }
        // End method add_PELI
        
        
        
        
        
         // This method is called on to handle delete Purchase Order Line Item
         public pagereference deletePOLI()
         {
             PO_Line_Item__c objPOLI=[Select id,Purchase_Order__c,Estimate_Line_Item__c,Production_Estimate__c from PO_LIne_Item__c where id=:strPOLI];
               Id POid=objPOLI.Purchase_Order__c;
               Id estId=objPOLI.Estimate_Line_Item__c;
               Id PestId=objPOLI.Production_Estimate__c;
               if(!test.isRunningTest()) Database.Delete(objPOLI);
          
           
               // After deletion, navigate to PO Detail Page
               
               if(isLtng)
               {
                    Pagereference p=new Pagereference('/apex/PODetailPageLightning?id='+POid);p.setRedirect(true);
                   return p;
               }
                    
               else
               {
                   Pagereference p=new Pagereference('/apex/PODetailPage?id='+POid);
                   p.setRedirect(true);
                   return p;
               }
               
               
               
               
         }
         // End of method deletePOLI

}
// End of Class
public with sharing class DisplayShipmentLineitemsController {

     /*  public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
       }  
       
       
        String theid;
        Public Shipment__c shipment{get;set;}
        public List<Shipment_Line_Item__c> SLI{get;set;} 
       // public List<Shipment_Line_Item__c> ESLI{get;set;} 
        public String strSLI {get;set;}
        public Material_Item__c objMaterial;
        Public Boolean Restrict{get;set;}
        public boolean ShowProductionEstimate{get;set;}
        // End Global variables 
        
        // Start Constructor 
        public DisplayShipmentLineitemsController () 
        {
             theid= ApexPages.CurrentPage().getParameters().get('id');
             shipment =[select id,name,Shipment_Status__c  from Shipment__c where id =:theid];
             
             ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
             ShowProductionEstimate =activeSettings.Active__c;
             
          
             
             SLI=[Select id,Qty_Shipped__c,name,Client_Name__c,Item_Status__c,Job__c,Job_Name__c,Estimate_Line_Item__c,Production_Estimate__c,Shipment__c,Shipment__r.Shipment_Status__c from Shipment_Line_Item__c where Shipment__c=:theid ];
              
              if(shipment.Shipment_Status__c =='Shipped')
              {
                   Restrict=true;
              }
              
        }
        // End Const

        
         
      // THis methos is called on to Create 
      public PageReference createSLI()
      {
          
                if(isLtng)
                {
                    PageReference p =  Page.addPELineitemToSLineitemLightning;
                    p.setRedirect(true);
                    p.getParameters().put('id',theid);
                    return p;
                }
                else
                {
                   PageReference p =  Page.addPELineitemToSLineitem;
                    p.setRedirect(true);
                    p.getParameters().put('id',theid);
                    return p;
                }
               
              
      }
      // End method 
        
        
      // This method is called on to handle delete 
      public pagereference deleteSLI()
      {
                ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
                ShowProductionEstimate =activeSettings.Active__c;
           if(ShowProductionEstimate==True)
           {               
               Shipment_Line_Item__c  objSLI=[Select id,Shipment__c,Production_Estimate__c from Shipment_Line_Item__c  where id=:strSLI];
               Id SID=objSLI.Shipment__c;
               Id PEID=objSLI.Production_Estimate__c;
               
               
               if(Shipment_Line_Item__c.sObjectType.getDescribe().isDeletable()){
                   Database.Delete(objSLI);}
               if(!test.isRunningTest()) {
                   Production_Estimate__c peupdate=[select id,name,Shippment_status__c from Production_Estimate__c where id=:PEID];
                   if(schema.SobjectType.Production_Estimate__c.Fields.Shippment_status__c.isUpdateable()){
                       peupdate.Shippment_status__c='Ready to be shipped';
                   }
                   if(Schema.sObjectType.Production_Estimate__c.isUpdateable()) {
                       update peupdate;
                   }
               }
               
                Pagereference p;
               
                if(isLtng)
                {
                     p = new Pagereference('/apex/ShipmentDetailPageLightning?id='+SID);
                }
                else
                {
                      p = new Pagereference('/apex/ShipmentDetailPage?id='+SID);
                }
               
               p.setRedirect(true);
               return p;
          }  
          else
          {
               Shipment_Line_Item__c  objESLI=[Select id,Shipment__c,Estimate_Line_Item__c from Shipment_Line_Item__c  where id=:strSLI];
               Id SID=objESLI.Shipment__c;
               Id EID=objESLI.Estimate_Line_Item__c;
               
               
              if(Shipment_Line_Item__c.sObjectType.getDescribe().isDeletable()){
                  Database.Delete(objESLI);
              }
              
              if(!test.isRunningTest()) {
                  Estimate_Line_Items__c estupdate=[select id,name,Shippment_status__c from Estimate_Line_Items__c where id=:EID];
                  if(schema.SobjectType.Estimate_Line_Items__c.Fields.Shippment_status__c.isUpdateable()){
                      estupdate.Shippment_status__c='Ready to be shipped';
                  }
                  if(Schema.sObjectType.Estimate_Line_Items__c.isUpdateable()) { 
                      update estupdate;
                  }
              }
                Pagereference p;
               
                if(isLtng)
                {
                     p = new Pagereference('/apex/ShipmentDetailPageLightning?id='+SID);
                }
                else
                {
                      p = new Pagereference('/apex/ShipmentDetailPage?id='+SID);
                }
               
               p.setRedirect(true);
               return p;
          
          }   
               
          
           
               // After deletion, navigate to Material Line Detail Page
             
      }
      // End of method delete        
         
       public PageReference save()
       {
            try
            {
                update SLI;
            }
            catch(System.DMLException e){return null;}
             Pagereference p; 
            
             if(isLtng)
                {
                     p = new Pagereference('/apex/ShipmentDetailPageLightning?id='+theid);
                }
                else
                {
                      p = new Pagereference('/apex/ShipmentDetailPage?id='+theid);
                }
               
               p.setRedirect(true);
               return p;
            
            
       }
    //End Of Save Method  
    
    //Method For Cancel button    
     public PageReference cancelme()
     {
     Pagereference p;
                if(isLtng)
                {
                     p = new Pagereference('/apex/ShipmentDetailPageLightning?id='+theid);
                }
                else
                {
                      p = new Pagereference('/apex/ShipmentDetailPage?id='+theid);
                }
               
               p.setRedirect(true);
               return p;   
     }
    //End Of Cancel Buttons method  
         
*/         
       

}
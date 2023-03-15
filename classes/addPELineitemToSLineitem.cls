public with sharing class addPELineitemToSLineitem {

//Global variables

 /*   public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
    }  

    public String Sid{get;set;}
    Public string Clientname,JobName;
    public List<ELIWrapper> rolewraps{get;set;}
    public List<EstLTWrapper> EstLTwrapper{get;set;}
    public List<Shipment_Line_Item__c> lstSLI{get;set;}
    public List<Shipment_Line_Item__c> lst{get;set;}
    public List<Shipment_Line_Item__c> Elst{get;set;}
    public List<Production_Estimate__c> ELIlst{get;set;}
    public List<Estimate_Line_Items__c> EstLTlst{get;set;}
    public boolean ShowProductionEstimate{get;set;}
   
    Shipment__c S = new Shipment__c();
   
    
    // End of Global variables

   // Start Constructor 
   public addPELineitemToSLineitem ()
   {
       EstLTWrapper eswraptest = new EstLTWrapper();
       Sid = ApexPages.currentPage().getParameters().get('id');
       roleWraps=new List<ELIWrapper>();
       EstLTwrapper=new List<EstLTWrapper>();
         
       ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
       ShowProductionEstimate =activeSettings.Active__c;
       
       system.debug('>>>>>>>>>>>>>>>>>>>>>>>>ShowProductionEstimate>>>>>>>>>'+ShowProductionEstimate);
       
       S= [Select id,Name,Client__c,Client__r.name,job__r.name from Shipment__c where id =:Sid];
       Clientname=s.Client__r.name;
       JobName=s.job__r.name;
     
       lstSLI=[Select Id,name,Production_Estimate__c,Production_Estimate__r.name from Shipment_Line_Item__c where Shipment__c =:Sid order by CreatedDate];
       system.debug('============'+lstSLI.size());
       
         if(ShowProductionEstimate==true)
         {
               List<Production_Estimate__c> ELI=[Select id,Name,Amount__c,Vendor__c,Job__c,Approved__c,Shippment_status__c,Total_Cost__c,GL_Code__c, Quantity__c,Job__r.name,Job__r.Status__c,Job__r.Job_Auto_Number__c,Job__r.Media_Types__c,Job__r.JS_Client__c,Job__r.JS_Client__r.name From Production_Estimate__c  where job__r.name=:JobName and Job__r.Status__c='Active' and  Shippment_status__c='Ready to be shipped'  /* where  Shippment_status__c='Ready to be shipped' and Job__r.Status__c='Active' and Job__r.Media_Types__r.name='Supplies' and Job__r.JS_Client__r.name=:Clientname Order By Name];
               
               for(Production_Estimate__c e: ELI)
               {
                    ELIWrapper rw=new ELIWrapper();
                    rw.e=e;
                    rw.checked=false;
                    roleWraps.add(rw);        
               }
         }
         
         else
         {
               List<Estimate_Line_Items__c> EstLI=[Select id,Name,Vendor__c,Job__c,Approved__c,Shippment_status__c,Total_Amount__c,GL_Code__c, Quantity__c,Job__r.name,Job__r.Status__c,Job__r.Job_Auto_Number__c,Job__r.Media_Types__c,Job__r.JS_Client__c,Job__r.JS_Client__r.name From Estimate_Line_Items__c where job__r.name=:JobName and Job__r.Status__c='Active' and  Shippment_status__c='Ready to be shipped'  /* where  Shippment_status__c='Ready to be shipped' and Job__r.Status__c='Active' and Job__r.Media_Types__r.name='Supplies' and Job__r.JS_Client__r.name=:Clientname Order By Name];

               for(Estimate_Line_Items__c es: EstLI)
               {
                   EstLTWrapper eswrap = new EstLTWrapper();
                    eswrap.est=es;
                    eswrap.checked=false;
                    EstLTWrapper.add(eswrap);   
                    
                    system.debug('>>>>>>>>>>>>>>>>>>>>>>>>EstLTWrapper>>>>>>>>>'+EstLTWrapper);
               }
         }
       
   }
   // End Constructor 

    // Start Wrapper Class for Production_Estimate__c 
     public class ELIWrapper
     {
           public Production_Estimate__c e{get;set;}
           public Boolean checked{get;set;}
     }
     // End of Wrapper Class

    // Start Wrapper Class for Estimate_Line_Items__c 
     public class EstLTWrapper
     {
           public Estimate_Line_Items__c est{get;set;}
           public Boolean checked{get;set;}
     }
     // End of Wrapper Class


    // Save Method
    public pagereference Save()
    {
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        ShowProductionEstimate =activeSettings.Active__c;
        
        Set<Id> PestIDS=new Set<id>();
        Set<Id> EstIDS=new Set<id>();
        List<Production_Estimate__c> UPestIDS=new List<Production_Estimate__c>();
        List<Estimate_Line_Items__c > UEstIDS=new List<Estimate_Line_Items__c >();
        try
        {
            if(ShowProductionEstimate==true)
            {
                 lst=new List<Shipment_Line_Item__c>();
                 for(ELIWrapper rw:roleWraps)
                 {
                     PestIDS.add(rw.e.id);
                     if(rw.checked == true)
                     {
                        Shipment_Line_Item__c stRole=new Shipment_Line_Item__c();
                        if(schema.SobjectType.Shipment_Line_Item__c.Fields.Production_Estimate__c.isCreateable()){ 
                            stRole.Production_Estimate__c=rw.e.id;
                        }
                        if(schema.SobjectType.Shipment_Line_Item__c.Fields.Qty_Shipped__c.isCreateable()){ 
                            stRole.Qty_Shipped__c=rw.e.Quantity__c;
                        }
                        if(schema.SobjectType.Shipment_Line_Item__c.Fields.Item_Status__c.isCreateable()){ 
                            stRole.Item_Status__c='Pending';
                        }
                        if(schema.SobjectType.Shipment_Line_Item__c.Fields.Shipment__c.isCreateable()){ 
                            stRole.Shipment__c=ApexPages.currentPage().getParameters().get('id');
                        }
                            lst.add(stRole);
                     }
                  }
                 System.debug('Inserted value @@@ '+lst);
                  if(Schema.sObjectType.Shipment_Line_Item__c.isCreateable()){
                 insert lst;
                 }
             
                 ELIlst=[Select id,name,Shippment_status__c from Production_Estimate__c where id in :PestIDS];
                 for(Production_Estimate__c  pei :ELIlst)
                 {
                    if (Schema.sObjectType.Production_Estimate__c.fields.Shippment_status__c.isUpdateable()) {   
                        pei.Shippment_status__c ='Shipped';
                         UPestIDS.add(pei);
                     }
                 }
                if(Schema.sObjectType.Production_Estimate__c.isUpdateable())
                {
                    Update UPestIDS;
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
             
                 Elst=new List<Shipment_Line_Item__c>();
                 for(EstLTWrapper Erw:EstLTWrapper)
                 {
                    
                     if(Erw.checked == true)
                     {
                     
                          EstIDS.add(Erw.est.id);
                            Shipment_Line_Item__c stRoleE=new Shipment_Line_Item__c(Item_Status__c='Pending',Estimate_Line_Item__c=Erw.est.id,Qty_Shipped__c=Erw.est.Quantity__c,Shipment__c=ApexPages.currentPage().getParameters().get('id'));
                            
                            Elst.add(stRoleE);
                     }
                  }
                 System.debug('Inserted value @@@ '+lst);
                 insert Elst;
             
                 EstLTlst=[Select id,name,Shippment_status__c from Estimate_Line_Items__c where id in :EstIDS];
                 for(Estimate_Line_Items__c ei :EstLTlst)
                 {
                     if (Schema.sObjectType.Estimate_Line_Items__c.fields.Shippment_status__c.isUpdateable()) { 
                         ei.Shippment_status__c ='Shipped';
                         UEstIDS.add(ei);
                     }
                 }
                if(Schema.sObjectType.Estimate_Line_Items__c.isUpdateable())
                 {
                     Update UEstIDS;
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
  // End of Back

*/
}
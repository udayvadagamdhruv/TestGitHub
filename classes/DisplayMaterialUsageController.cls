public with sharing class DisplayMaterialUsageController {

/*
         public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  

        String theid;
        public List<Material_Usage_line_item__c > MU{get;set;} 
        transient  public List<Material_Usage_line_item__c > MUD{get;set;} 
        public String strMU {get;set;}
        public Material_Item__c objMaterial;
         Public String FirstMUID;
        // End Global variables 
        
        // Start Constructor 
        public DisplayMaterialUsageController () 
        {
             theid= ApexPages.CurrentPage().getParameters().get('id');
             
             objMaterial=[Select id,name ,Qty_On_Hand__c from Material_Item__c  where id=:theid];
             
             MU =[Select id,name,Qty_On_Hand__c,Date__c,Credit__c,Debit__c,Description__c,Type__c  from Material_Usage_line_item__c  where Material_Item__c=:theid Order by Createddate DESC, Qty_On_Hand__c limit 800 ];
             MUD =[Select id,name,Qty_On_Hand__c,Date__c,Credit__c,Debit__c,Description__c,Type__c  from Material_Usage_line_item__c  where Material_Item__c=:theid Order by Createddate limit 10000 ];
             
             
            
        }
        // End Const

        
         
        // THis methos is called on to Create Material Usage
       public PageReference createMU()
        {
            PageReference p;   
             if(isLtng)
             {
                p= Page.CreateMaterialUsageLightning;
             }
            
             else
             {
               p= Page.CreateMaterialUsage;
             }   
            
            //PageReference p =  Page.CreateMaterialUsage;
            p.setRedirect(true);
            p.getParameters().put('materialid',theid);
            return p;
        }
        // End method 
        
        
         // This method is called on to handle delete Material Usage
         public pagereference deleteMU()
         {
              MUD =[Select id,name,Qty_On_Hand__c,Date__c,Credit__c,Debit__c,Description__c,Type__c  from Material_Usage_line_item__c  where Material_Item__c=:theid Order by Createddate limit 10000];
         
             Material_Usage_line_item__c  objMU=[Select id,Material_Item__c from Material_Usage_line_item__c  where id=:strMU];
               Id MID=objMU.Material_Item__c;
               
             if(MUD.size()> 1){
                 if(schema.SobjectType.Material_Item__c.Fields.Qty_On_Hand__c.isUpdateable()){ 
                     objMaterial.Qty_On_Hand__c=MUD[MUD.size()-2 ].Qty_On_Hand__c;
                 }
                 if(Schema.sObjectType.Material_Item__c.isUpdateable()) { 
                     update objMaterial;
                 }
             }
             else{
                 if(schema.SobjectType.Material_Item__c.Fields.Qty_On_Hand__c.isUpdateable()){ 
                     objMaterial.Qty_On_Hand__c=null;
                 }
                 if(Schema.sObjectType.Material_Item__c.isUpdateable()) { 
                     update objMaterial;
                 }
             }
             if(Material_Usage_line_item__c.sObjectType.getDescribe().isDeletable()){
                 Database.Delete(objMU);
             }
           
               // After deletion, navigate to Material Line Detail Page
              
               PageReference p;   
                 if(isLtng)
                 {
                    p= new Pagereference('/apex/MaterialLineDetailPageLightning?id='+MID+'&section=MU');
                 }
                
                else
                 {
                   p= new Pagereference('/apex/MaterialLineDetailPage?id='+MID);
                 }   
              
              
             //  Pagereference p=new Pagereference('/apex/MaterialLineDetailPage?id='+MID);
               p.setRedirect(true);
               return p;
               
         }
         // End of method delete Material Usage       
         */
         
}
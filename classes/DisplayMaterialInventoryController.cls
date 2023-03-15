public with sharing class DisplayMaterialInventoryController {

       /*  public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
        
        
        String theid;
        public List<Material_Inventory_Item__c> MI{get;set;} 
        public String strMI {get;set;}
        public Material_Item__c objMaterial;
        public Boolean ShowqtyRolls{get;set;}
        public Boolean ShowqtyCases{get;set;}
        
        // End Global variables 
        
        // Start Constructor 
        public DisplayMaterialInventoryController () 
        {
             theid= ApexPages.CurrentPage().getParameters().get('id');
             
             objMaterial=[Select id,name ,Calc_Unit__c,Qty_On_Hand__c from Material_Item__c  where id=:theid];
             
             MI =[Select id,name, Qty_On_Hand__c,Inventory_Date__c,Material_Item__c,Mfg_Item_Number__c,Qty_On_Shelf__c  from Material_Inventory_Item__c where Material_Item__c=:theid Order by LastModifiedDate DESC limit 1000 ];
             
             if(objMaterial.Calc_Unit__c =='Size'){
             
             ShowqtyRolls=true;
             
             
             } 
             
             if(objMaterial.Calc_Unit__c =='Sheet'){
             
             ShowqtyCases=true;
             
             
             } 
        
        
        }
        // End Const

        
         
        // THis methos is called on to Create Material Usage
       public PageReference createMI()
        {
             PageReference p;   
             if(isLtng)
             {
                p= Page.CreateMaterialInventoryLightning;
             }
            
             else
             {
               p= Page.CreateMaterialInventory;
             }   
            
           // PageReference p =  Page.CreateMaterialInventory;
            p.setRedirect(true);
            p.getParameters().put('materialid',theid);
            return p;
        }
        // End method 
        
        
         // This method is called on to handle delete Material Usage
         public pagereference deleteMI()
         {
             Material_Inventory_Item__c objMI=[Select id,Material_Item__c from Material_Inventory_Item__c where id=:strMI];
               Id MID=objMI.Material_Item__c;
               
               
                if(Material_Inventory_Item__c.sObjectType.getDescribe().isDeletable()){
                    Database.Delete(objMI);}
           
               // After deletion, navigate to Material Line Detail Page
               
                PageReference p;   
                 if(isLtng)
                 {
                    p= new Pagereference('/apex/MaterialLineDetailPageLightning?id='+MID+'&section=MI');
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
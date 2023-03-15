public with sharing class CreateMaterialInventoryExtension {

   /*  public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
    private final Material_Inventory_Item__c mu;
    public String Materialid{get;set;}
    public String MaterialName{get;set;}
    public Material_Item__c objMaterial{get;set;}
    
    public CreateMaterialInventoryExtension(ApexPages.StandardController controller) {
    
    this.mu=(Material_Inventory_Item__c )controller.getRecord();
     
    Materialid=ApexPages.CurrentPage().getParameters().get('materialid');
    objMaterial=[Select id,name ,Qty_On_Hand__c from Material_Item__c  where id=:Materialid];
     MaterialName=objMaterial.Name;

    }
    
    // Save Method
            public PageReference saveme() 
                { 
                   
                    string strciId;        
                    try
                    {
                        if(schema.SobjectType.Material_Inventory_Item__c.Fields.Material_Item__c .isCreateable()){ 
                            mu.Material_Item__c =Materialid;
                        }
                        if(Schema.sObjectType.Material_Inventory_Item__c.isCreateable()){
                            insert mu;
                        }
                    }
                    catch(DMLException e)
                    {
                        return null;
                    }
                    
               
                 PageReference p;   
                 if(isLtng)
                 {
                    p= new Pagereference('/apex/MaterialLineDetailPageLightning?id='+Materialid+'&section=MI');
                 }
                
                else
                 {
                   p= new Pagereference('/apex/MaterialLineDetailPage?id='+Materialid);
                 }   
            
               
               
               //  PageReference pageRef = new PageReference('/apex/MaterialLineDetailPage?id='+Materialid);
                  p.setRedirect(true);
                  return p;
                  
                  
               }
            // End of Save Method

        // Cancel Method
        Public PageReference cancelme()
        {   
        
             PageReference p;   
             if(isLtng)
             {
                p= new Pagereference('/apex/MaterialLineDetailPageLightning?id='+Materialid+'&section=MI');
             }
            
            else
             {
               p= new Pagereference('/apex/MaterialLineDetailPage?id='+Materialid);
             }   
        
            
          //  PageReference p =  new Pagereference('/apex/MaterialLineDetailPage?id='+Materialid);
            p.setRedirect(true);
            return p;   
            
       }
        // Cancel Method 
    
    
    */
    

}
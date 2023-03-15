public with sharing class CreateMaterialUsageExtension {

   /* public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
    
    private final Material_Usage_line_item__c mu;
    public Material_Usage_line_item__c muc{get;set;}
    public String Materialid{get;set;}
    public String MaterialName{get;set;}
    public Material_Item__c objMaterial{get;set;}

    // Start Constructor
    public CreateMaterialUsageExtension (ApexPages.StandardController controller) {
        
        this.mu=(Material_Usage_line_item__c )controller.getRecord();
        
        Materialid=ApexPages.CurrentPage().getParameters().get('materialid');
        
        
        objMaterial=[Select id,name ,Qty_On_Hand__c,Calc_Unit__c,Case_Pack__c,Roll_LF__c,(select id,name from Material_Usage_line_items__r ) from Material_Item__c  where id=:Materialid];
        
        if(objMaterial.Material_Usage_line_items__r.size()>0){
            muc =[Select id,name,Qty_On_Hand__c,Date__c,Credit__c,Debit__c,Description__c,Type__c  from Material_Usage_line_item__c  where Material_Item__c=:objMaterial.id Order by Createddate DESC, Qty_On_Hand__c limit 1];
        }
        
        
        MaterialName=objMaterial.Name;
        mu.Material_Item__c = Materialid;
        
    }
    
    
    // Save Method
    public PageReference saveme() 
    { 
        
        integer qtyonhand;
        if(objMaterial.Material_Usage_line_items__r.size()> 0){
            qtyonhand=integer.valueof(muc.Qty_On_Hand__c);
            
        }
        
        else{ 
        qtyonhand=0;
        }
        
        
        string strciId;        
        try
        {  
            
            if(objMaterial.Calc_Unit__c=='Size'){
                
                if(schema.SobjectType.Material_Usage_line_item__c.Fields.Material_Item__c.isCreateable()){
                    mu.Material_Item__c =Materialid;
                }
                
                if(schema.SobjectType.Material_Usage_line_item__c.Fields.Qty_On_Hand__c.isCreateable()){ 
                    mu.Qty_On_Hand__c= (qtyonhand +(mu.Credit__c != null ? mu.Credit__c * objMaterial.Roll_LF__c : 0))- (mu.Debit__c != null ? mu.Debit__c * objMaterial.Roll_LF__c : 0);
                }
                
                if(schema.SobjectType.Material_Item__c.Fields.Qty_On_Hand__c.isUpdateable()){
                    objMaterial.Qty_On_Hand__c=(qtyonhand +(mu.Credit__c != null ? mu.Credit__c * objMaterial.Roll_LF__c: 0))- (mu.Debit__c != null ? mu.Debit__c * objMaterial.Roll_LF__c: 0);
                }
                if(schema.SobjectType.Material_Usage_line_item__c.Fields.Credit__c.isCreateable()){ 
                    mu.Credit__c=(mu.Credit__c != null ? mu.Credit__c * objMaterial.Roll_LF__c : 0);
                }
                if(schema.SobjectType.Material_Usage_line_item__c.Fields.Debit__c.isCreateable()){ 
                    mu.Debit__c=(mu.Debit__c != null ? mu.Debit__c * objMaterial.Roll_LF__c: 0);
                }
                if(Schema.sObjectType.Material_Usage_line_item__c.isCreateable()){
                    insert mu;
                }
                
                if(Schema.sObjectType.Material_Item__c.isUpdateable()) {
                    update objMaterial;
                }
                
            }
            
            else if(objMaterial.Calc_Unit__c =='Sheet')
                
            {
               if(schema.SobjectType.Material_Usage_line_item__c.Fields.Material_Item__c.isCreateable()){
                    mu.Material_Item__c =Materialid;
                }
                if(schema.SobjectType.Material_Usage_line_item__c.Fields.Qty_On_Hand__c.isCreateable()){
                    mu.Qty_On_Hand__c= (qtyonhand +(mu.Credit__c != null ? mu.Credit__c * objMaterial.Case_Pack__c: 0))- (mu.Debit__c != null ? mu.Debit__c * objMaterial.Case_Pack__c: 0);
                }
                if(schema.SobjectType.Material_Item__c.Fields.Qty_On_Hand__c.isUpdateable()){
                    objMaterial.Qty_On_Hand__c=(qtyonhand +(mu.Credit__c != null ? mu.Credit__c * objMaterial.Case_Pack__c: 0))- (mu.Debit__c != null ? mu.Debit__c * objMaterial.Case_Pack__c: 0);
                }
                
                if(schema.SobjectType.Material_Usage_line_item__c.Fields.Credit__c.isCreateable()){
                    mu.Credit__c=(mu.Credit__c != null ? mu.Credit__c * objMaterial.Case_Pack__c : 0);
                }
                if(schema.SobjectType.Material_Usage_line_item__c.Fields.Debit__c.isCreateable()){
                    mu.Debit__c=(mu.Debit__c != null ? mu.Debit__c * objMaterial.Case_Pack__c: 0);
                }
                if(Schema.sObjectType.Material_Usage_line_item__c.isCreateable()){
                    insert mu;
                }
                if(Schema.sObjectType.Material_Item__c.isUpdateable()) {
                    update objMaterial;
                }
                
            }
            
            else{
                if(schema.SobjectType.Material_Usage_line_item__c.Fields.Material_Item__c.isCreateable()){
                    mu.Material_Item__c =Materialid;
                }
                if(schema.SobjectType.Material_Usage_line_item__c.Fields.Qty_On_Hand__c.isCreateable()){
                    mu.Qty_On_Hand__c= (qtyonhand +(mu.Credit__c != null ? mu.Credit__c : 0))- (mu.Debit__c != null ? mu.Debit__c : 0);
                }
                if(Schema.sObjectType.Material_Usage_line_item__c.isCreateable()){
                    insert mu;
                }
                
                if(schema.SobjectType.Material_Item__c.Fields.Qty_On_Hand__c.isUpdateable()){
                    objMaterial.Qty_On_Hand__c=(qtyonhand +(mu.Credit__c != null ? mu.Credit__c : 0))- (mu.Debit__c != null ? mu.Debit__c : 0);
                }
                if(Schema.sObjectType.Material_Item__c.isUpdateable()) {
                    update objMaterial;
                }
                
            } 
            
        }
        catch(DMLException e){ return null;}
        
        
        PageReference p;   
        if(isLtng)
        {
            p= new Pagereference('/apex/MaterialLineDetailPageLightning?id='+Materialid+'&section=MU');
        }
        
        else
        {
            p= new Pagereference('/apex/MaterialLineDetailPage?id='+Materialid);
        }   
        
        
        
        //   PageReference pageRef = new PageReference('/apex/MaterialLineDetailPage?id='+Materialid);
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
            p= new Pagereference('/apex/MaterialLineDetailPageLightning?id='+Materialid+'&section=MU');
        }
        
        else
        {
            p= new Pagereference('/apex/MaterialLineDetailPage?id='+Materialid);
        }   
        
        
        // PageReference p =  new Pagereference('/apex/MaterialLineDetailPage?id='+Materialid);
        p.setRedirect(true);
        return p;   
        
    }*/
    // Cancel Method        
     
}
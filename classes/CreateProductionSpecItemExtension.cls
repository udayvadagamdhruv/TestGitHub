// This class is used to create new Production Spec Item
public with sharing class CreateProductionSpecItemExtension 
{
  public boolean isLtng {private set;get{
  
   return (Userinfo.getUITheme()=='Theme4d')?true:false;
  }}
 
    // Global variables 
    private final Production_Spec_Item__c spec;
    // End of Global variables
    public string pstemplateid {set;get;}
    public string classicPSTid {set;get;}
    public Production_Spec_Template__c pspetemplate {set;get;}
    public string prospeTempcname {set;get;}
    // Standard Controller Constructor 
    public CreateProductionSpecItemExtension(ApexPages.StandardController controller) 
    {
     
       
       this.spec=(Production_Spec_Item__c)controller.getrecord();
       classicPSTid=spec.Production_Spec_Template__c;
    //  Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.info,''+classicPSTid));
      
       if(isLtng){
            pstemplateid=Apexpages.currentpage().getParameters().get('pstempid');
            pspetemplate=[select id,name from Production_Spec_Template__c where id=:pstemplateid];
            prospeTempcname=pspetemplate.name;
       }
       
    }
    // End Controller Constructor 
    
    // This method is called on to save Production Spec Item
    Public PageReference saveme()
    {
        try
        {
            String strid;
             if(isLtng)
                {
                spec.Production_Spec_Template__c=pspetemplate.id;
                }
            insert spec;
            strid = spec.Production_Spec_Template__c;        
            
            PageReference p;
            if(isLtng)
            {
               p = new Pagereference('/apex/ProductionSpecTemplateDetailLightning?id='+strid);
            }
            else
            {
             p =  new Pagereference('/apex/ProductionSpecTemplateDetail?id='+strid);
            }
            p.setRedirect(true);
            return p;
        }
        catch(System.DMLException e)
        {
            
            return null;
        }
    }
    
    public pageReference cancel()
    {
    
   PageReference p;
     if(isLtng)
            {
            p= new Pagereference('/apex/ProductionSpecTemplateDetailLightning?id='+pstemplateid);
            }
            else
            {
             p=new Pagereference('/apex/ProductionSpecTemplateDetail?id='+classicPSTid);
            }
            p.setRedirect(true);
            return p;
    
    
    }
    
    
    
    //  End of method Save
   
   
    
}
// End of Class
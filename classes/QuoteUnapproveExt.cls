public with sharing class QuoteUnapproveExt {

  public boolean isLtng{set;get{
   return (Userinfo.getUITheme()=='Theme4d')?true:false;
  }}
    
    public Quote__c QuoteItems{set;get;}
    public String QuoteId;
 
 
    public QuoteUnapproveExt(ApexPages.StandardController controller) 
    {
        if(!test.isrunningtest()) controller.addFields(new list<string>{'Job__c'});
        QuoteId=controller.getrecord().id;
        
    }
    
    
    
    Public PageReference Unapprove()
    {
               
         PageReference p =  new Pagereference('/apex/unapprovequote?id='+QuoteId);
         p.setRedirect(true);
         return p; 
            
     } 
    Public PageReference PageRefer2()
    {
         PageReference p;
        if(isLtng){       
         p =  new Pagereference('/'+QuoteId);
         }
         else{
          p =  new Pagereference('/apex/Quotedetailpage?id='+QuoteId);
         }
         p.setRedirect(true);
         return p;   
     } 


}
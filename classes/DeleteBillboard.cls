public with sharing class DeleteBillboard {

    // Globl Variables
  /*  private final Billboard__c BB;
    public Boolean isError{get;set;}
      public string Billboardprefix {set;get;}
    // End Of Global Variables 
     public boolean displayPopup {get; set;}     

    // Standard Controller Constructor 
    public DeleteBillboard(ApexPages.StandardController controller) 
    {	displayPopup=true;
        isError = False;
        this.BB=(Billboard__c)controller.getrecord();
         Billboardprefix = Billboard__c.SobjectType.getDescribe().getKeyPrefix();

    }

    // Method called on to delete Billboard
    public PageReference checkDelete()
    {
        displayPopup=false;
      try
       {
           isError = True;
           if(Billboard__c.sObjectType.getDescribe().isDeletable()){
               Database.delete(BB);
           }
       }
       catch(System.DMLException e)
       {
           return null;
       }
      
      // After deletion navigate 
      PageReference p =  new Pagereference('/'+Billboardprefix+'/o');
      p.setRedirect(true);
      return p; 
    }
     public PageReference closePopup() {        
        displayPopup = false;   
        PageReference p=new PageReference('/'+Billboardprefix+'/o');
        p.setRedirect(true);
      return p;
    }  */
    // End of delete method
}
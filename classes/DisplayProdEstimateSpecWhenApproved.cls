public with sharing class DisplayProdEstimateSpecWhenApproved {

    // Global variables
  /*  Public String theID;
    public List<Production_Estimate_Spec_Item__c> vq{get;set;}
    public Production_Estimate__c pesRec {set;get;}
    // End of Global variables
    
   
    //pop for New 
     public Id      pespecid {set;get;}
     public string  PEName   {set;get;}
     
     public string  Newspecname    {set;get;}
     public string  Newdiscription {set;get;}
     public boolean isNewPopup     {set;get;}
     
     //pop for Edit
     public string  specname    {set;get;}
     public string  discription {set;get;}
     public boolean isEditPopup {set;get;}
     
    
        
    
    // Start Constructor
    public DisplayProdEstimateSpecWhenApproved(ApexPages.StandardController controller) 
    {
    
       isEditPopup=false;
       isNewPopup=false;
        theID = ApexPages.CurrentPage().getParameters().get('id');
        pesRec=[select id,Name,Approved__c from Production_Estimate__c Where id=:theID];
        PEName=pesRec.Name;
        vq=[select id,Name,Description__c ,Production_Estimate__r.Approved__c from Production_Estimate_Spec_Item__c where Production_Estimate__c=: theID Order By CreatedDate];
        
    }
    // End of Constructor


   public void shownewFileds()
     {
          isNewPopup=true;
          Newspecname='';
          Newdiscription='';
     }
    
    
   //newly Added for Job Spec Pop Up  
    public void showEditFields(){
         /*jobspeid = ApexPages.currentPage().getParameters().get('nickName123');
         secionstring = ApexPages.currentPage().getParameters().get('nickName1123');*
         
         isEditPopup=true;
         Production_Estimate_Spec_Item__c  pespec = new Production_Estimate_Spec_Item__c ();
         pespec =[select id,name,Description__c From Production_Estimate_Spec_Item__c where id=:pespecid];
         specname=pespec.name;
         discription=pespec.Description__c;
         
     } 
     
     
     
     public void savejobspec(){

        try{
          Production_Estimate_Spec_Item__c  pespecUpd = new Production_Estimate_Spec_Item__c ();
          pespecUpd=[select id,name,Description__c From Production_Estimate_Spec_Item__c where id=:pespecid];
          //pespecUpd.Production_Estimate__c=theID;
          //pespecUpd.id=pespecUpd.id;
            if(schema.SobjectType.Production_Estimate_Spec_Item__c.Fields.name.isUpdateable()){
                pespecUpd.name=specname;
            }
            if(schema.SobjectType.Production_Estimate_Spec_Item__c.Fields.Description__c.isUpdateable()){
                pespecUpd.Description__c =discription;
            }
            if(Schema.sObjectType.Production_Estimate_Spec_Item__c.isUpdateable()) {
                update pespecUpd;
            }
         isEditPopup=false;

           //vq.Clear();
          vq=[select id,Name,Description__c ,Production_Estimate__r.Approved__c from Production_Estimate_Spec_Item__c where Production_Estimate__c=: theID Order By CreatedDate];
                 
       }
      catch(DMLException e){
        Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.Error,''+e.getMessage()));
        //return null;
      }
      
     }
    
    
    public void newsavejobspecs(){
    
     theID = ApexPages.CurrentPage().getParameters().get('id');
      Production_Estimate_Spec_Item__c  prospecitem=new Production_Estimate_Spec_Item__c(Production_Estimate__c=theID ,Name=Newspecname,Description__c=Newdiscription);
      //Job__c=jobId,Name=objJobSpec.Name,Description__c=objJobSpec.Description__c
     try{
        insert prospecitem;
         vq=[select id,Name,Description__c ,Production_Estimate__r.Approved__c from Production_Estimate_Spec_Item__c where Production_Estimate__c=: theID Order By CreatedDate];
        isNewPopup=false;
        
       /* PageReference p= new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=CreativeBrief');
        p.setRedirect(true);
        return p;
        *
       }
     catch(DMLException e){
        Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.Error,''+e.getMessage()));
        //return null;
      }
     
    } 
    
    public void canceljobspec(){
       isEditPopup=false;
       isNewPopup=false;
      }
    
     
     
     
     
     public void deljobspec(){
    
      list<Production_Estimate_Spec_Item__c > deletePEspecs=[select id,name,Description__c From Production_Estimate_Spec_Item__c where id=:pespecid limit 1];
      
      try{
         if(deletePEspecs.size()>0){
           if(Production_Estimate_Spec_Item__c.sObjectType.getDescribe().isDeletable()){
               Database.delete(deletePEspecs);}
           //vq.Clear();
           vq=[select id,Name,Description__c ,Production_Estimate__r.Approved__c from Production_Estimate_Spec_Item__c where Production_Estimate__c=: theID Order By CreatedDate];
          }
        }
        Catch(System.DMLException e){
         ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR,''+e.getMessage());
         ApexPages.addMessage(msg1);
        }
      }*/
    
     
  

}
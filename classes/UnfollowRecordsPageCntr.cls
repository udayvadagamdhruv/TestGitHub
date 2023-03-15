public with sharing class UnfollowRecordsPageCntr {

  /* Public String Userid{get;set;}
   Public List<EntitySubscription> ListofTntySubs{get;set;} 
   Public List<EntitySubscription> ListofTntySubs1{get;set;} 
   Public List<EntityFilebWrapper> EnFWrap{get;set;} 
   Public List<EntityJobWrapper> EnJWrap{get;set;} 
   Public string noofrecords{get;set;}
  
   Public Map<ID,EntitySubscription > MapJobParentIdSubscription=new  Map<ID,EntitySubscription >();
   Public Map<ID,EntitySubscription > MapFileParentIdSubscription= new Map<ID,EntitySubscription >();
  
   
  
  Public UnfollowRecordsPageCntr (){
  
      EnFWrap=new List<EntityFilebWrapper>();
       EnJWrap=new List<EntityJobWrapper>();
  
      Userid=Userinfo.getuserid();
      
      
     ListofTntySubs=[SELECT Id,ParentId, Parent.Name FROM EntitySubscription WHERE SubscriberId =:Userid AND ParentId IN  (Select Id FROM Job__c WHERE status__c='Completed')  limit 1000 ];
    
     ListofTntySubs1=[SELECT Id,ParentId, Parent.Name FROM EntitySubscription WHERE SubscriberId =:Userid AND ParentId IN  (Select Id FROM ContentDocument)  limit 1000 ];
     
     for(EntitySubscription e:ListofTntySubs){
     
     MapJobParentIdSubscription.put(e.ParentId,e);
     
     
       
     }
     
     for(EntitySubscription e:ListofTntySubs1){
     
      MapFileParentIdSubscription.put(e.ParentId,e);
     
       
      }
      
      
      for(Job__c  j:[Select id,name,Job_Auto_Number__c from Job__c where id In :MapJobParentIdSubscription.keyset()]){
      
      
      EnJWrap.add(new EntityJobWrapper(j));
      
      }
      
      
      for(ContentDocument  c:[Select id,createddate,Title from ContentDocument where id In :MapFileParentIdSubscription.keyset()]){
      
      
      EnFWrap.add(new EntityFilebWrapper(c));
      }
     
      
      
      
      
      
      
      
      
     
   }
   
   Public Pagereference Unfollowrecords(){
   
           
            List<EntitySubscription> Deletelist=new List<EntitySubscription>();
             for(EntityJobWrapper ens:EnJWrap){
          
              if(ens.Checked ==True && MapJobParentIdSubscription.containskey(ens.j.id)){
              
              EntitySubscription es=new EntitySubscription();
              es= MapJobParentIdSubscription.get(ens.j.id);
              
              Deletelist.add(es);
              
              }
          }
          
          if(Deletelist.size() > 0 || test.isRunningTest()) {
                    if(EntitySubscription.sObjectType.getDescribe().isDeletable()){
                     delete Deletelist;}
                    Pagereference p=new Pagereference('/apex/UnfollowRecordsPageSwitch');
                       p.setRedirect(true);
                       return p;
          
                    
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Select atleast one job record to delete.'));
                    return null;
                }
         
  
  }
   
       Public Pagereference FileUnfollowrecords(){
   
           
            List<EntitySubscription> Deletelist=new List<EntitySubscription>();
             for(EntityFilebWrapper ens:EnFWrap){
          
              if(ens.Checked ==True && MapFileParentIdSubscription.containskey(ens.c.id)){
              
              EntitySubscription es1=new EntitySubscription();
              es1= MapFileParentIdSubscription.get(ens.c.id);
              
              Deletelist.add(es1);
              
              }
          }
          
          if(Deletelist.size() > 0 || test.isRunningTest()) {
                   if(EntitySubscription.sObjectType.getDescribe().isDeletable()){
                     delete Deletelist;}
                    Pagereference p=new Pagereference('/apex/UnfollowRecordsPageSwitch');
                       p.setRedirect(true);
                       return p;
          
                    
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Select atleast one file  to delete.'));
                    return null;
                }
         
  
  }
   
   
      
   
   
          Public  Class EntityJobWrapper{
          
           Public Job__c j{get;set;}
           
           Public Boolean Checked{get;set;}
           
           Public EntityJobWrapper(Job__c j){
           this.j=j;
           this.Checked=False;
           
           }
           
          
          
          }  
          
          Public  Class EntityFilebWrapper{
          
           Public ContentDocument c{get;set;}
           
           Public Boolean Checked{get;set;}
           
           Public EntityFilebWrapper(ContentDocument c){
           this.c=c;
           this.Checked=False;
           
           }
           
          
          
          }  
  
      */

}
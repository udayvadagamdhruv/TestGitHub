public with sharing class StaffNameUpdateforJobTeamTask{
      
      public static void updateStaffname(string OldStaffname,string NewStaffname){
      
          list<Job_Team__c> JobTeamlist=new list<Job_Team__c>();
          list<Job_Task_Role__c> JobTaskRolelist=new list<Job_Task_Role__c>();
     
          system.debug('<!----  OldStaffName ----------!> '+OldStaffname);
          system.debug('<!----  NewStaffName -----------!> '+NewStaffname);
        
          if((OldStaffname!= null || OldStaffname!= '') ){   
                
          List<Job_Team__c> Jteam = [SELECT id,Staff__c FROM Job_Team__c WHERE Staff__c =:OldStaffname WITH SECURITY_ENFORCED];
              
           system.debug('<!----  Teamlist ----------!> '+Jteam);  
             
           List<Job_Task_Role__c> Jtaskrole = [SELECT id,User__c FROM Job_Task_Role__c WHERE User__c=:OldStaffname WITH SECURITY_ENFORCED];
              
           system.debug('<!----  Jtaskrolelist ----------!> '+Jtaskrole );    
            
              for(Job_Team__c jt:Jteam){
                  if(schema.SobjectType.Job_Team__c.Fields.Staff__c.isUpdateable()){ 
                      jt.Staff__c=NewStaffname;
                  }
                      JobTeamlist.add(jt);
                  
              }
            
           for(Job_Task_Role__c Jtrole:Jtaskrole){
               if(schema.SobjectType.Job_Task_Role__c.Fields.User__c.isUpdateable()){ 
                   Jtrole.User__c =NewStaffname;}
               JobTaskRolelist.add(Jtrole);
           }
              try{
                  
                  if(!JobTeamlist.IsEmpty()) 
                  { 
                      if(Schema.sObjectType.Job_Team__c.isUpdateable()){
                          Update JobTeamlist;
                      }
                  }
                  if(!JobTaskRolelist.IsEmpty()){
                      if(Schema.sObjectType.Job_Task_Role__c.isUpdateable()){
                          Update JobTaskRolelist;}
                  }
                 
                 
              }
              catch(exception e){}
          }
          
          
          
          
          
          
      }
}
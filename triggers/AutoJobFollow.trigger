trigger AutoJobFollow on Job_Team__c (after insert, after delete) {
    
    Id JobId{get;set;} 
    Map<Id,Set<String>> JobsWithStaff=new Map<Id,Set<String>>();
    
    ProductionEstimate__c setting = ProductionEstimate__c.getOrgDefaults();
    if((setting !=NULL && setting.Team_Auto_Follow_Job_Trigger__c) || system.test.isRunningTest()){ 
        
        
        
        Set<String> staffName=new Set<String>();
        Set<String> staffNameOld=new Set<String>();
        List<EntitySubscription> NewFollowers = new List <EntitySubscription>(); 
        List<EntitySubscription> OldFollowers = new List <EntitySubscription>();
        
        if(trigger.IsInsert ){
            for(Job_team__c team:trigger.new){
                
                //staffName.add(Team.Staff__c);
                //JobId = team.Job__c;
                
                if(JobsWithStaff.containsKey(team.Job__c)){
                    Set<String> staffNames=JobsWithStaff.get(team.Job__c);
                    staffNames.add(Team.Staff__c);
                    JobsWithStaff.put(team.Job__c,staffNames);
                }
                
                else{
                    JobsWithStaff.put(team.Job__c,new Set<String>{Team.Staff__c});
                }
                
                
                system.debug('=====JobsWithStaff====='+JobsWithStaff);
                //system.debug('>>>staffName>>>>>>'+staffName);
                //system.debug('>>>JobId>>>>>>'+JobId);
                
            }      
            
            List<Set<String>> JobTeamsNamesSet=JobsWithStaff.values();
            set<String> NamesList=new set<String>();
            for(Integer i=0;i<JobTeamsNamesSet.size();i++){
                NamesList.addAll(JobTeamsNamesSet[i]);
            }
            
            // Map<Id,User> UserMap=new Map<Id,User>([select Id, Name from User where Name IN:staffName and IsActive=True ]);
            
            Map<Id,List<User>> UserInStaffMap=new  Map<Id,List<User>>();
            Map<Id,List<EntitySubscription>> UserIdwithsubcripionMap=new Map<Id,List<EntitySubscription>>();
            List<User> UserList=[select Id, Name from User where Name In:NamesList and IsActive=True ];//WITH SECURITY_ENFORCED
            List<EntitySubscription> entitySubcribeList=[select Id, ParentId, SubscriberId from EntitySubscription where SubscriberId IN:UserList ];//WITH SECURITY_ENFORCED
            
            for(EntitySubscription es :entitySubcribeList){ 
                if(UserIdwithsubcripionMap.containsKey(es.SubscriberId)){
                    List<EntitySubscription> entityAddedList=UserIdwithsubcripionMap.get(es.SubscriberId);
                    entityAddedList.add(es);
                    UserIdwithsubcripionMap.put(es.SubscriberId,entityAddedList);  
                }
                else{
                    UserIdwithsubcripionMap.put(es.SubscriberId,new List<EntitySubscription>{es});  
                }
            }
            
            for(Id jbid:JobsWithStaff.keyset()){
                for(String st:JobsWithStaff.get(jbid)){
                    for(User us :UserList){ 
                        if(st==us.Name){
                            if(UserInStaffMap.containsKey(jbid)){
                                List<User> addedList=UserInStaffMap.get(jbid);
                                addedList.add(us);
                                UserInStaffMap.put(jbid,addedList);  
                            }
                            else{
                                UserInStaffMap.put(jbid,new List<User>{us});  
                            }
                        }
                       
                    } 
                }         
            }  
            
            
            
            //for(User objStaff :[select Id, Name from User where Name IN:jobstafflist and IsActive=True ])     
            for(Id jbid:JobsWithStaff.keyset()){
                //Set<String> jobstafflist=JobsWithStaff.get(jbid);
                if(UserInStaffMap.get(jbid)!=null){
                    for(User objStaff : UserInStaffMap.get(jbid))
                    {
                        system.debug('>>>objStaff>>>>>>'+objStaff);
                        
                        //List<EntitySubscription> lstES = new List<EntitySubscription>();
                        List<EntitySubscription> lstES1 = new List<EntitySubscription>();
                        boolean isJobFollowedwithUser=true;
                        //lstES= [select Id, ParentId, SubscriberId from EntitySubscription where ParentId =:jbid and SubscriberId=:objStaff.Id];
                        //lstES1= [select Id, ParentId, SubscriberId from EntitySubscription where SubscriberId=:objStaff.Id];
                        if(UserIdwithsubcripionMap.get(objStaff.Id)!=null){
                        lstES1=UserIdwithsubcripionMap.get(objStaff.Id);
                        }
                        //system.debug('entity subscription previous data----->'+lstES);
                        
                        system.debug('>>>lstES1>>>>>>'+lstES1);
                        
                        for(EntitySubscription es : lstES1){
                            if(es.ParentId==jbid){
                                isJobFollowedwithUser=false;
                                break;
                            }
                        }
                        
                        if(isJobFollowedwithUser && lstES1.size()<500){  
                            EntitySubscription es = new EntitySubscription();        
                            if(schema.SobjectType.EntitySubscription.Fields.ParentId.isCreateable()){ es.ParentId = jbid;}  
                            if(schema.SobjectType.EntitySubscription.Fields.SubscriberId.isCreateable()){ es.SubscriberId = objStaff.Id;}
                            system.debug('entity subscription----->'+es);
                            NewFollowers.add(es);                     
                        }         
                    } 
                }
            }
            if(Schema.sObjectType.EntitySubscription.isCreateable()){insert NewFollowers;}
        }
        
        
        
        
        if(trigger.IsDelete ){
            
            for(Job_team__c team:trigger.Old){
                
                staffNameOld.add(Team.Staff__c);
                JobId = team.Job__c;
                
                system.debug('>>>staffNameold>>>>>>'+staffNameOld);
                system.debug('>>>JobId>>>>>>'+JobId);
                
            }      
            
            Map<Id,User> UserMap=new Map<Id,User>([select Id, Name from User where Name IN:staffNameOld and IsActive=True  ]);//WITH SECURITY_ENFORCED
            system.debug('>>>UserMap>>>>>>'+UserMap); 
            
            List<EntitySubscription> lstES = [select Id, ParentId, SubscriberId from EntitySubscription where ParentId =:JobId and SubscriberId=:UserMap.Keyset() ];//WITH SECURITY_ENFORCED
            system.debug('>>>lstES>>>>>>'+lstES);
            
            for(EntitySubscription es:lstES)
            {
                OldFollowers.add(es);
                
            }  
            
            if(Schema.sObjectType.EntitySubscription.isDeletable()){  Delete OldFollowers;}
        }
        
    }
    
    
    
    
}
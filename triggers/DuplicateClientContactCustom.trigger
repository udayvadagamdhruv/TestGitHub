trigger DuplicateClientContactCustom on Client_Contact__c(before insert, before update, after insert, after update) {
    // To check Duplicate Value
    If((Trigger.isBefore && Trigger.isUpdate || Trigger.isBefore && Trigger.isInsert)) {
        Map < String, Client_Contact__c > ContactMap = new Map < String, Client_Contact__c > ();
        // List<User> lstUser=[Select Id,Name,UserName from User];
        List < User > lstUser = new List < User > ();
        for (Client_Contact__c c: System.Trigger.new) {
            
            // Make sure we don't treat an email address that  
            // isn't changing during an update as a duplicate.  
            // 
            If((c.UserName__c != null) && (System.Trigger.isInsert || (c.UserName__c != System.Trigger.oldMap.get(c.Id).UserName__c))) {
                // Make sure another new Contact isn't also a duplicate  
                If(ContactMap.containsKey(c.UserName__c)) {
                    c.UserName__c.addError('Another new Contact has the ' + 'same UserName.');
                } else {
                    ContactMap.put(c.UserName__c, c);
                }
            }
        }
        
        // Using a single database query, find all the Contacts in  
        // the database that have the same email address as any  
        // of the Contacts being inserted or updated.  
        // 
        List < User > lstUserNew = new List < User > ();
        for (Client_Contact__c NewC: Trigger.New) {
            for (Client_Contact__c c: [SELECT Id, Email__c, UserName__c FROM Client_Contact__c WHERE UserName__c IN: ContactMap.KeySet() WITH SECURITY_ENFORCED]) {
                if (NewC.UserName__c == c.UserName__c)
                    NewC.UserName__c.addError('A Contact with UserName ' + c.UserName__c + ' already exists.');
                else {
                    lstUserNew = [Select Id, Name, UserName from User where Username = : NewC.UserName__c limit 1];// WITH SECURITY_ENFORCED
                    if (lstUserNew.size() > 0)
                        NewC.UserName__c.addError('A User with UserName ' + c.UserName__c + ' already exists.');
                }
            }
        }
    } // End of Duplicate check
    
    //variables for @future class
    String Idusr;
    boolean SFflg;
    String UserRole;
    // if Contacts salesforce user checkbox is set to true then its instance should be created in User with 'Client Contact' Profile
    //code updated date 18 Oct for the new client contact
    If(Trigger.isInsert && Trigger.isAfter || Trigger.isUpdate && Trigger.isAfter) {
        system.debug('in the aftetr insert section');
        List < User > usInsert = new List < User > ();
        List < User > usUpdate = new List < User > ();
        Map < String, Id > UserRoleMap = new Map < String, Id > ();
        for (Client_Contact__c c: Trigger.New) {
            List < User > lstUser = new List < User > ();
            if (Trigger.isInsert && Trigger.isAfter) {
                lstUser = [Select Id, Profile.Name from User where Username = : c.Username__c limit 1];// WITH SECURITY_ENFORCED
            } else {
                lstUser = [Select Id, Profile.Name from User where Username = : Trigger.oldMap.get(c.id).Username__c  limit 1];//WITH SECURITY_ENFORCED
            }
            system.debug('list of the user' + lstUser);
            system.debug('list of the user' + lstUser.size());
            Profile p = [select id, Name from Profile where Name = : 'SP Client Contact'
                          limit 1
                        ];//WITH SECURITY_ENFORCED
            //UserRole  R=[select id,Name from UserRole where Name=:c.Client_Contact_Role__c limit 1];
            if (lstUser.size() == 0) {
                If(c.Salesforce_User__c == True) {
                    User u = new User();
                    if(Schema.sObjectType.User.fields.FirstName.isCreateable()){ u.FirstName = c.First_Name__c;}
                    if(Schema.sObjectType.User.fields.LastName.isCreateable()){ u.LastName = c.Last_Name__c;}
                    if(Schema.sObjectType.User.fields.Email.isCreateable()){ u.Email = c.Email__c;}
                    if(Schema.sObjectType.User.fields.isActive.isCreateable()){ u.isActive = true;}
                    if(Schema.sObjectType.User.fields.IsClientContact__c.isCreateable()){ u.IsClientContact__c = true;}
                    if(Schema.sObjectType.User.fields.Username.isCreateable()){ u.Username = c.UserName__c;}
                    if(Schema.sObjectType.User.fields.alias.isCreateable()){ u.alias = (c.First_Name__c).subString(0, 3) + '' + (c.Last_Name__c).subString(0, 1);}
                    if(Schema.sObjectType.User.fields.TimeZoneSidKey.isCreateable()){ u.TimeZoneSidKey = 'America/Los_Angeles';} //for ex'America/Los_Angeles'
                    if(Schema.sObjectType.User.fields.LocaleSidKey.isCreateable()){ u.LocaleSidKey = 'en_GB';} //for ex 'en_GB'
                    if(Schema.sObjectType.User.fields.EmailEncodingKey.isCreateable()){ u.EmailEncodingKey = 'ISO-8859-1';} //for ex'ISO-8859-1';
                    if(Schema.sObjectType.User.fields.ProfileId.isCreateable()){ u.ProfileId = p.Id;}
                    
                    if (c.Client_Contact_Role__c != '' && c.Client_Contact_Role__c != null) {
                        UserRole R = [select id, Name from UserRole where Name = : c.Client_Contact_Role__c  limit 1];//WITH SECURITY_ENFORCED
                        //u.UserRoleId=R.id;
                        UserRoleMap.put(c.UserName__c, R.id);
                        System.debug('======UserRole of Clinet Contact====' + R);
                    }
                    if(Schema.sObjectType.User.fields.LanguageLocaleKey.isCreateable()){u.LanguageLocaleKey = 'en_US'; }//for ex 'en_US'
                    Database.DMLOptions dmo = new Database.DMLOptions();
                    dmo.EmailHeader.triggerUserEmail = true;
                    u.setOptions(dmo);
                    
                    //changed the list name 
                    //usUpdate.add(u);
                    usInsert.add(u);
                    
                    System.debug('User creation successful');
                }
            } else if (lstUser.size() == 1) {
                User u = lstUser[0];
                if (u.Profile.Name == p.Name) {
                    if(Schema.sObjectType.User.fields.FirstName.isCreateable()){ u.FirstName = c.First_Name__c;}
                    if(Schema.sObjectType.User.fields.LastName.isCreateable()){ u.LastName = c.Last_Name__c;}
                    if(Schema.sObjectType.User.fields.IsClientContact__c.isCreateable()){ u.IsClientContact__c = true;}
                    
                    //to activate n deactivate user in based on salesforce user checkbox value.
                    /*                        If(c.Salesforce_User__c==True){                        
u.IsDeleted__c = true;
u.IsActive = u.IsDeleted__c;//True;
}
else If(c.Salesforce_User__c==False){
u.IsDeleted__c = False;
u.IsActive = u.IsDeleted__c;
}
*/
                    
                    // u.IsActive = c.Active__c;
                    if(Schema.sObjectType.User.fields.Email.isCreateable()){ u.Email = c.Email__c;}
                    
                    if(Schema.sObjectType.User.fields.Username.isCreateable()){ u.Username = c.UserName__c;}
                    if(Schema.sObjectType.User.fields.alias.isCreateable()){ u.alias = (c.First_Name__c).subString(0, 3) + '' + (c.Last_Name__c).subString(0, 1);}
                    
                    String URoleId;
                    if (c.Client_Contact_Role__c != '' && c.Client_Contact_Role__c != null) {
                        UserRole R = [select id, Name from UserRole where Name = : c.Client_Contact_Role__c  limit 1];//WITH SECURITY_ENFORCED
                        URoleId = R.id;
                        System.debug('======UserRole of Clinet Contact====' + R);
                    } else {
                        URoleId = '';
                    }
                    System.debug('======UserRole of Clinet Contact====' + URoleId);
                    UserUpdatefromClientContactTrigger.UpdateUserWithDetails(u.id, c.UserName__c, c.First_Name__c, c.Last_Name__c, c.Email__c, URoleId);
                    //usUpdate.add(u);
                    UserRole = c.Client_Contact_Role__c;
                    Idusr = u.id + '';
                    SFflg = c.Salesforce_User__c;
                } else {
                    c.UserName__c.addError('Another user with user name ' + c.UserName__c + ' of profile ' + u.Profile.Name + ' exists');
                }
            }
        }
        
        if (usInsert.size() > 0) {
            if(Schema.sObjectType.user.isCreateable()){ insert usInsert;}
            if (UserRoleMap.size() > 0) {
                UserUpdatefromClientContactTrigger.InsertUserWithDetails(JSON.serialize(UserRoleMap));
            }
        }
        
        if (usUpdate.size() > 0) {
            if(Schema.sObjectType.User.isUpdateable()){ update usUpdate;}
        }
        
        // sharing job records for adding new client contact
        List < Id > MainAccounts = new List < Id > ();
        for (Client_Contact__c CC: trigger.new) {
            mainAccounts.add(cc.id);
        }
        BatchClientConJobShare shn = new BatchClientConJobShare(MainAccounts);
        database.executeBatch(shn, 1);
        
        // End of sharing job records for adding new client contact
        
        /*  String orgId = UserInfo.getOrganizationId();
If(orgId == '00DE0000000Z7vWMAS' || orgId == '00Dc0000000yhAiEAI' || orgId== '00DA0000000Cir8MAC')
{
system.debug('flag ********************************************** '+SFflg);
system.debug('id -------------------------------------------- '+Idusr);

deactiveUsr.updtusr(SFflg, Idusr);
}*/
        
        system.debug('flag ********************************************** ' + SFflg);
        system.debug('id -------------------------------------------- ' + Idusr);
        
        deactiveUsr.updtusr(SFflg, Idusr, UserRole);
        
    }
    
    //Updating sharing records when client contact is changed to another client
    
    if (trigger.isafter && trigger.isupdate) {
        list < Job__share > JobShareAllList=new  list < Job__share >();
        for (Client_Contact__c CC: trigger.old) {
            if (CC.Salesforce_User__c == true) {
                string Name = CC.UserName__c;
                list < user > u = [select id, name, IsActive, Profile.name from user where Username = : Name  limit 1];//WITH SECURITY_ENFORCED
                
                if (u.size() > 0) {
                    List < Job__c > ClientJobs = [select id, name, JS_Client__c from Job__c where JS_Client__c = : CC.Client__c WITH SECURITY_ENFORCED];
                    
                    set < id > jobsid = new set < id > ();
                    
                    for (Job__c job: ClientJobs) {
                        
                        jobsid.add(job.id);
                        
                    }
                    
                    if (cc.Client__c != trigger.newmap.get(cc.id).Client__c) {
                        
                        list < Job__share > JobSh = [select id, ParentId, UserOrGroupId from Job__share where ParentId in : jobsid and UserOrGroupId = : u[0].id and RowCause != 'owner' WITH SECURITY_ENFORCED];
                        JobShareAllList.addAll(JobSh);
                    }
                }
            }
        }
        if(!JobShareAllList.isEmpty()){
            if(Schema.sObjectType.Job__share.isDeletable()){ delete JobShareAllList;}
        } 
        
    }
    
} // End of Trigger
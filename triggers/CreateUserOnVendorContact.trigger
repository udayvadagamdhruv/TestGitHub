// This trigger is used to create User Record fot Vendor Contact
trigger CreateUserOnVendorContact on Vendor_Contact__c (before insert, before update,after insert,after update)
{
    //variables for @future class
    String Idusr;
    boolean SFflg;
    String UserRole;
    //This will create, Activate or Deativate the user account for Vendor contact based on SF flag value.    
    if(Trigger.isInsert && Trigger.isAfter || Trigger.isUpdate && Trigger.isAfter)
    {
        List<User> usInsert=new List<User>();
        List<User> usUpdate=new List<User>();
        for(Vendor_Contact__c c:Trigger.New)
        {
            List<User> lstUser=[Select Id, Profile.Name from User where Username=:c.User_Name__c  limit 1 ];//WITH SECURITY_ENFORCED
            system.debug('list of the user'+ lstUser);
            system.debug('list of the user'+ lstUser.size());
            Profile p=[select id,Name from Profile where Name=: 'SP Vendor Contact'  limit 1]; //WITH SECURITY_ENFORCED
          //  UserRole  R=[select id,Name from UserRole where Name=:c.Role__c limit 1]; 
            if(lstUser.size()== 0)
            {                  
                If(c.Salesforce_User__c==True)
                {
                    User u=new User();
                    if(schema.SobjectType.User.Fields.FirstName.isCreateable()){  u.FirstName=c.First_Name__c;}
                    if(schema.SobjectType.User.Fields.LastName.isCreateable()){  u.LastName=c.Last_Name__c;}
                    if(schema.SobjectType.User.Fields.Email.isCreateable()){  u.Email=c.Email__c;}
                    if(schema.SobjectType.User.Fields.isActive.isCreateable()){   u.isActive=true;}
                    if(schema.SobjectType.User.Fields.IsVendorContact__c.isCreateable()){   u.IsVendorContact__c=true;}
                    if(schema.SobjectType.User.Fields.Username.isCreateable()){   u.Username=c.User_Name__c;}
                    if(schema.SobjectType.User.Fields.alias.isCreateable()){   u.alias=(c.First_Name__c).subString(0,3)+''+(c.Last_Name__c).subString(0,1);}
                    if(schema.SobjectType.User.Fields.TimeZoneSidKey.isCreateable()){   u.TimeZoneSidKey = 'America/Los_Angeles';}//for ex'America/Los_Angeles'
                    if(schema.SobjectType.User.Fields.LocaleSidKey.isCreateable()){   u.LocaleSidKey = 'en_GB';} //for ex 'en_GB'
                    if(schema.SobjectType.User.Fields.EmailEncodingKey.isCreateable()){   u.EmailEncodingKey = 'ISO-8859-1';}//for ex'ISO-8859-1';
                    if(schema.SobjectType.User.Fields.ProfileId.isCreateable()){   u.ProfileId = p.Id;}
                   // u.UserRoleId=r.id;
                    if(schema.SobjectType.User.Fields.LanguageLocaleKey.isCreateable()){   u.LanguageLocaleKey = 'en_US';} //for ex 'en_US'
                    Database.DMLOptions dmo = new Database.DMLOptions();
                    dmo.EmailHeader.triggerUserEmail = true;
                    u.setOptions(dmo);

                    //Add user to the insert list
                    usInsert.add(u);
                    System.debug('User creation successful');
                }
            }
            else if(lstUser.size()== 1)
            {
                User u=lstUser[0];
               if(Trigger.isUpdate && Trigger.isAfter)
               {
                if(u.Profile.Name == p.Name)
                {
                    if(schema.SobjectType.User.Fields.FirstName.isUpdateable()){ u.FirstName=c.First_Name__c;}
                    if(schema.SobjectType.User.Fields.LastName.isUpdateable()){ u.LastName=c.Last_Name__c;}
                    if(schema.SobjectType.User.Fields.Email.isUpdateable()){ u.Email=c.Email__c;}
                    if(schema.SobjectType.User.Fields.Username.isUpdateable()){ u.Username=c.User_Name__c;}
                    if(schema.SobjectType.User.Fields.alias.isUpdateable()){ u.alias=(c.First_Name__c).subString(0,3)+''+(c.Last_Name__c).subString(0,1);}
                    if(schema.SobjectType.User.Fields.IsVendorContact__c.isUpdateable()){ u.IsVendorContact__c=true;}
                    //Add user to update list.
                    usUpdate.add(u);
                    
                    //Get the user id and SF flag values to deactivate if flag is set to FALSE.
                    Idusr = u.id+'';
                    SFflg = c.Salesforce_User__c;
                    UserRole=c.Role__c;
                }
              }
               else
                {
                    c.User_Name__c.addError('Another user with user name '+c.User_Name__c+' of profile '+ u.Profile.Name  +' exists');
                }      
            }
        }
        
        if(usInsert.size() > 0)
        {
            if(Schema.sObjectType.User.isCreateable()) {   insert usInsert;}
        }
        
        if(usUpdate.size() > 0)
        {
            if(Schema.sObjectType.User.isUpdateable()) { update usUpdate;}
        }
        
        //Active or Deactive vendor contact based on SF flag value.
        system.debug('flag ********************************************** '+SFflg);
        system.debug('id -------------------------------------------- '+Idusr);
        deactiveUsr.updtusr(SFflg, Idusr,UserRole);
    }
    //End User creation code.
}// End of Trigger
public with sharing  class UserUpdatefromClientContactTrigger {
    
    @future
    public static void UpdateUserWithDetails(String usid,String uname, String fname, String lname,String em,String URoleId) {
        
     User u=[Select Id, Profile.Name from User where id=:usid  limit 1];//WITH SECURITY_ENFORCED

        // Create new user with a non-null user role ID 
        if(schema.SobjectType.User.Fields.username.isUpdateable()){ 
            u.username=uname;}
        if(schema.SobjectType.User.Fields.FirstName.isUpdateable()){ 
            u.FirstName=fname;}
        if(schema.SobjectType.User.Fields.LastName.isUpdateable()){ 
            u.LastName=lname;}
        if(schema.SobjectType.User.Fields.alias.isUpdateable()){ 
            u.alias =(fname).subString(0,3)+''+(lname).subString(0,1);}
        if(URoleId!='' && URoleId!=null){
            if(schema.SobjectType.User.Fields.UserRoleId.isUpdateable()){ 
                u.UserRoleId=URoleId;}
            System.debug('======UserRole Update when client contact Update===='+URoleId);   
        }
        if(schema.SobjectType.User.Fields.IsClientContact__c.isUpdateable()){ 
            u.IsClientContact__c=true;}
        if(schema.SobjectType.User.Fields.email.isUpdateable()){ 
            u.email=em;}
        if(Schema.sObjectType.User.isUpdateable()){   
            update u;
        }
        
        
    }
    
    @future
    public static void InsertUserWithDetails(String SerelizeUserRoleMap){
        
        Map<String,Id > userMap = (Map<String,Id>)JSON.deserialize(SerelizeUserRoleMap, Map<String,Id>.class);
        List<String> usernamelist=new  List<String>();
        for(String a:userMap.KeySet()){
            usernamelist.add(a);
        }
        
        list<User> ulist=[Select Id,UserName from User where UserName IN:usernamelist ];//WITH SECURITY_ENFORCED
         list<User> updatlist=new  list<User>();
        for(User us:ulist){
            if(schema.SobjectType.User.Fields.UserRoleId.isUpdateable()){ 
                us.UserRoleId=userMap.get(us.UserName);
            }
            updatlist.add(us);
          }
        
        try{
            if(Schema.sObjectType.User.isUpdateable()){
                update updatlist;
            }
        }
        catch(System.DMLException e){
            
        }
        
        
    }
    

}
public with sharing class deactiveUsr{
      @future
      public static void updtusr(boolean SFUsr,string usId,string role){
       UserRole  R;
          system.debug('user ------------------------------------> '+usId);
          system.debug('flag 8888888888888888888888888888888888888 '+SFUsr);
          if((usId != null || usId != '') && SFUsr != null){   
              if(role!=null)  R=[select id,Name from UserRole where Name=:role limit 1];     // WITH SECURITY_ENFORCED  
              User u1 = [SELECT id,IsActive,UserRoleId FROM User WHERE id =: usId  ];//WITH SECURITY_ENFORCED
              
              try{
                  if(schema.SobjectType.User.Fields.IsActive.isUpdateable()){
                      u1.IsActive = SFUsr;
                  }
                  if(r.id!=null) 
                  {
                      if(schema.SobjectType.User.Fields.UserRoleId.isUpdateable()){
                          u1.UserRoleId=r.id;
                      }
                  }
                  if(Schema.sObjectType.User.isUpdateable()) {
                      update u1;
                  }
              }
              catch(exception e){}
          }
      }
}
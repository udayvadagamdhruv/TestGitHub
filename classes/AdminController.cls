public with sharing class AdminController {
    
    @AuraEnabled
    public static Map<String,string> getObjLabels(){
        Map<String, string> optionList = new Map<String, String>();  
        for(Schema.SObjectType o: Schema.getGlobalDescribe().values()){
            if(o.getDescribe().isCustom())  
            {
                optionList.put(o.getDescribe().getName(),o.getDescribe().getLabel());
            }
        }
        return optionList;
    }
    
    
    @AuraEnabled
    public static string getObjPrefix(String Obj){
        Map<String, Schema.SObjectType> m  = Schema.getGlobalDescribe() ;
        system.debug('==>m is==>'+m);
        Schema.SObjectType s = m.get(Obj) ;
        system.debug('==>Sobject Type is ==>'+s);
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        String keyPrefix = r.getKeyPrefix();
        return keyPrefix;
    }
    
    @AuraEnabled
    public static list<Production_Estimate_Temp_Line_Items__c> getPELIRecords(Id recordId){
        List <Production_Estimate_Temp_Line_Items__c> PETempLI = [select id,Name,of_Pages__c,Calc_Unit__c,Sort_Order__c,Material_Item__c,Material_Item__r.Name,Production_Estimate_Template__c from Production_Estimate_Temp_Line_Items__c where Production_Estimate_Template__c=: recordId WITH SECURITY_ENFORCED ORDER BY Sort_Order__c];
        return PETempLI;
    }
    
    @AuraEnabled
    public static string updatePELI(List <Production_Estimate_Temp_Line_Items__c> editPELIList){
        try{
            if(Schema.sObjectType.Production_Estimate_Temp_Line_Items__c.isUpdateable()){
                 update editPELIList;
               return 'true';}
            else{
                return 'Production Estimate Temp Line Items has insufficient access to update';
            }
          
        } catch(Exception e){return ''+e.getMessage();
        }
    }
    
    
    @AuraEnabled
    public static List<string> deleteProEst(String ProEstID){
        list<string> aa=new list<string>();
        List<Production_Estimate_Temp_Line_Items__c> DelProEst= [Select id,Name,Production_Estimate_Template__c,Calc_Unit__c,Color__c,Commission__c,Equipment_Type__c,GL_Department__c,GL_Code__c,of_Pages__c,
                                                 Length_in_Inches__c,Material_Item__c,EachQtyUpforUsed__c,Quantity__c,Qty_Up__c,SheetQtyUpforUsed__c,Sided__c,Vendor__c,Width_in_Inches__c  from Production_Estimate_Temp_Line_Items__c Where Id =:ProEstID WITH SECURITY_ENFORCED Limit 1];
        String PEId=DelProEst[0].Production_Estimate_Template__c;
        try
        {
            if(Schema.sObjectType.Production_Estimate_Temp_Line_Items__c.isDeletable()){
                Database.delete(DelProEst);  
                aa.add('OK');aa.add(''+PEId);
                return aa;
            }else{
                aa.add('Error');
                aa.add('Production Estimate temp line item has insufficient access to delte');
                return aa;
            }
        }
        
        catch(System.DMLException e)
        {
            aa.add('NO');aa.add(''+e.getMessage());
            return aa;
        }  
       
        
    }
     
    @AuraEnabled
    public Static list<Material_Item__c> getMatereialItems(String CalUnit) {   
        system.debug('===CalUnit========'+CalUnit);
        list<Material_Item__c> miList=new list<Material_Item__c>();
        // miList=[SELECT Id, name FROM Material_Item__c where recordtype.name =:CalUnit order by Name];
        miList=[SELECT Id, Name,Calc_Unit__c FROM Material_Item__c where Calc_Unit__c=:CalUnit WITH SECURITY_ENFORCED order by Name];
        return miList;
    }
    
    @AuraEnabled
    public Static list<GL_Department__c> getGLDepartments() 
    {    
        
        list<GL_Department__c>  gldlist=[SELECT Id, name FROM GL_Department__c WITH SECURITY_ENFORCED order by Name];
        return gldlist;  
    }
    
    // ****************************************** This method is used to retrieve all GLCodes under the GL Department into dropdown list *********************************************
    
    @AuraEnabled
    public Static list<GL_Code__c> getGLCodes(String GLDName) 
    {
        List<GL_Code__c> glcodelist=[SELECT Id,Name,GL_Id__c FROM GL_Code__c where GL_Department__c =: GLDName WITH SECURITY_ENFORCED ORDER BY Name];
        return glcodelist;  
    }  
    
    @AuraEnabled
    public Static Decimal getamount(String GLCName){
        Decimal Amount=0.00;
        if(GLCName!=null)
        {
            GL_Code__c  glc=[SELECT Id,GL_Id__c,Name,Unit_Cost__c FROM GL_Code__c where id=: GLCName WITH SECURITY_ENFORCED];
            Amount=glc.Unit_Cost__c;
        }
        return Amount;
    }    
    
    
    // ****************************************** This method is used to retrieve all Vendors under the GL_Code__c into dropdown list *********************************************
    
    @AuraEnabled
    public Static list<Vendor_GL_Code__c> getVendors(String GLCName) 
    {
        list<Vendor_GL_Code__c> vglcodelist=[SELECT Id,Name,Vendor__c,Vendor__r.Name,GL_Code__c FROM Vendor_GL_Code__c where GL_Code__c =: GLCName WITH SECURITY_ENFORCED];
        return vglcodelist;  
    }  
    
    @AuraEnabled
    public static String geLabelforObject(String sObjName) {
        string objlabel = Schema.getGlobalDescribe().get(sObjName).getDescribe().getLabel();
        return objlabel;
    }
    
    @AuraEnabled
    public static String getObjectType(list<String> ObjNames){
        return getDynamicLabelUtility.getDescribedObjects(ObjNames);
    }
    
   // ================================================= FieldSets fields =====================================================================//
    
    @AuraEnabled
    public static List < String > getFieldsforObject(String sObjName) {
        
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.FieldSet > fieldMap = schemaMap.get(sObjName).getDescribe().FieldSets.getMap();
        string fieldsetname;
        for (string s: fieldMap.keyset())
            fieldsetname = s;
        List < Schema.FieldSetMember > fields = fieldMap.get(fieldsetname).getFields();
        List < string > fieldsname = new List < string > ();
        
        for (Schema.FieldSetMember fieldName: fields) {
            fieldsname.add(fieldName.getFieldPath());
        }
        
        return fieldsname;
    }
    
    
    @AuraEnabled
    public static list<UserRole> getRoles() {
        List <UserRole > Role = [Select id, Name from UserRole  limit 1000];//WITH SECURITY_ENFORCED
        return Role;
    }
    /*************************************** Create New Role *************************************************/
    @AuraEnabled
    public static string CreatenewRole(String CreateRole){
        UserRole ur=new UserRole();
        if(Schema.sObjectType.UserRole.fields.Name.isCreateable()) {ur.Name=CreateRole;}
        try{
            if(!Schema.sObjectType.UserRole.isCreateable()){  
                return 'Roles has Insufficient access to Create';
            }
            else{
                insert ur;
                return 'true';
            }
        } catch(Exception e){
            return ''+e.getMessage();
        }
    }
    
    /*************************************** Edit Role from lightning datatable *************************************************/
    @AuraEnabled
    public static string updateRole(List <UserRole> editRoleList){
        try{
            if(Schema.sObjectType.UserRole.isUpdateable()){
                update editRoleList;
                return 'true';
            }
            else{
                return 'Error, Role has insufficient access to update';
            }
        } 
        catch(Exception e){
            return ''+e.getMessage();
        }
    }
    
    /*************************************** Delete Role from lightning datatable *************************************************/
    @AuraEnabled
    public static string DeleteRol(String RolId){
        UserRole ur=[Select id,Name from UserRole where id=:RolId ];//WITH SECURITY_ENFORCED
        String roleName=ur.Name;
        List<Staff__c> lstStaff=[Select id,name from Staff__c where Role__c=: roleName WITH SECURITY_ENFORCED];
        List<User> lstUser=[Select id,name from User where UserRoleId=: RolId and IsActive=True ];//WITH SECURITY_ENFORCED
        try
        {
            if(lstStaff.size()==0 && lstUser.size()==0)
            {
                if(UserRole.sObjectType.getDescribe().isDeletable()){
                    Database.delete(ur); 
                    return 'OK';
                }
                else{
                    return 'Error';
                }
            }
            else
            {
                return 'Your attempt to delete this role could not be completed because staff/users are currently assigned to this role';
            }  
        } 
        catch(Exception e){
            return ''+e.getMessage();
        }
        
    }
    
    
    
    /************************************************************ Staff Tab *********************************************************************/
    
    /**************************************************************** fetching User Records **********************************************************/
    
    @AuraEnabled
    public static list<User> getUsers() {
        List <User> User = [select name,Username,FirstName,Email,UserRoleId,UserRole.Name from User where User_Types__c =: 'Licensed User' and IsActive=: True  Order By FirstName];//WITH SECURITY_ENFORCED
        return User;
    }
    /******************************************************** insert user record ********************************************************/
    @AuraEnabled
    public static string InsertUsers(String userinfostr){
        User us =(User)JSON.deserialize(userinfostr, User.class);
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        us.setOptions(dmo);
        try{
            if(!Schema.sObjectType.User.isCreateable()){                     
                return 'Users has Insufficient access to Create';
            }
            else{
                insert us;
                // createStaff method is a future method and it is invoked to create Staff record for respected User  
                createstaff(us.User_Types__c,us.FirstName,us.LastName,us.Email,us.Username,us.UserRoleId,us.ProfileId,us.alias,us.CommunityNickname,us.Phone,us.Fax,us.emailencodingkey,us.languagelocalekey,us.localesidkey,us.timezonesidkey);
                return 'true';
            }
        }
        catch(Exception e){
            return ''+e.getMessage();
        }
       
    }
    
    
    // Start future method
    // This method is invoked to create Staff for respected User
    @future
    public static void createstaff(String User_Type,String fname,String lname, String email, String username, String role,string profile,String alias,String commNickName,String ph,String fax,String emailEncodingKey, String locale, String language, String TimeZone)
    {
        UserRole u=[Select Id,Name from UserRole where Id =: role];// WITH SECURITY_ENFORCED
        
        Profile pro=[Select Id,Name from Profile where Id =: profile ];//WITH SECURITY_ENFORCED
        
        
        Staff__c st1=new Staff__c();
        if(Schema.sObjectType.Staff__c.fields.User_Type__c.isCreateable()) { st1.User_Type__c=User_Type;}
        if(Schema.sObjectType.Staff__c.fields.First_Name__c.isCreateable()) {   st1.First_Name__c=fname;}
        if(Schema.sObjectType.Staff__c.fields.Last_Name__c.isCreateable()) {   st1.Last_Name__c =lname;}
        if(Schema.sObjectType.Staff__c.fields.Name.isCreateable()) {  st1.Name=fname+' '+lname;}
        if(Schema.sObjectType.Staff__c.fields.Email__c.isCreateable()) {  st1.Email__c=email;}
        if(Schema.sObjectType.Staff__c.fields.Username__c.isCreateable()) {  st1.Username__c=username;}
        if(Schema.sObjectType.Staff__c.fields.Role__c.isCreateable()) { st1.Role__c=u.Name;}
        if(Schema.sObjectType.Staff__c.fields.Profile__c.isCreateable()) { st1.Profile__c=pro.Name;}
        if(Schema.sObjectType.Staff__c.fields.Alias__c.isCreateable()) {st1.Alias__c=alias;}
        if(Schema.sObjectType.Staff__c.fields.CommunityNickName__c.isCreateable()) {st1.CommunityNickName__c=commNickName;}
        if(Schema.sObjectType.Staff__c.fields.Phone_1__c.isCreateable()) { st1.Phone_1__c=ph;}
        if(Schema.sObjectType.Staff__c.fields.Fax__c.isCreateable()) { st1.Fax__c=fax;}
        if(Schema.sObjectType.Staff__c.fields.Time_Zone__c.isCreateable()) { st1.Time_Zone__c=TimeZone;}
        if(Schema.sObjectType.Staff__c.fields.Locale__c.isCreateable()) {st1.Locale__c=locale;}
        if(Schema.sObjectType.Staff__c.fields.Language__c.isCreateable()) {st1.Language__c=language;}
        if(Schema.sObjectType.Staff__c.fields.Email_Encoding__c.isCreateable()) {st1.Email_Encoding__c=emailEncodingKey; }  
        try
        {
            if(Schema.sObjectType.Staff__c.isCreateable()){
                insert st1;
                System.debug('Staff record is inserted successfully '+st1);}
            else{
                System.debug('staff has insufficient accesds to create ');  
            }// Create Staff record for respcted User
        }
        catch(DMLException e)
        {
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e)));
        }
        
    }
    // End of future method
    
    /************************************************ Update User ********************************************************************/
    
    @AuraEnabled
    public static string UpdateUsers(String userinfostr,String oldUsername){
     
        User us =(User)JSON.deserialize(userinfostr, User.class);
        try{
            if(Schema.sObjectType.User.isUpdateable()){
                update us;
                
                User u=[Select Id,Name,UserRoleId,Alias,CommunityNickName,Username,Email,FirstName,LastName,ProfileId,Phone,Extension,Fax,Title,CompanyName,Department,User_Types__c,IsActive from User where Id=:us.Id ];//WITH SECURITY_ENFORCED
                String staffName,roleId,uName,alias,comm,email,fName,lName,profileId,ph,fax,title,companyName,dept,userType;
                
                Boolean active;  staffName = u.Name;  roleId=u.UserRoleId; uName=u.Username; alias=u.alias; comm=u.CommunityNickName; email=u.Email; fName=u.FirstName; lName=u.Lastname; profileId=u.ProfileId; ph=u.Phone; fax=u.Fax; title=u.Title; companyName=u.CompanyName; dept=u.Department; userType=u.User_Types__c; active=u.IsActive;        
                
                // call future method to Update related Staff from the User Update.
                updateStaff(staffName,roleId,uName,alias,comm,email,fName,lName,profileId,ph,fax,dept,userType,oldUsername,active);
                return 'true';
               
            }
            else{
                return 'Error, User has insufficient access to update';
            }
        }
        catch(Exception e){
            return ''+e.getMessage();
        }
        
      
    }
    
    // This is future method and It is invoked to update respected Staff from the User Update.
     @future
    public static void updatestaff(String staffName,String roleId,String username,String alias,String comm,String email,String fName,String lName,String profileId,String ph,String fax,String dept,String userType, String oldUsername,Boolean active)
    {
        UserRole u=[Select Id,Name from UserRole where Id =: roleId ];//WITH SECURITY_ENFORCED
        String uRole1=u.Name;
        Profile pro=[Select Id,Name from Profile where Id =: profileId ];//WITH SECURITY_ENFORCED
        String proName=pro.Name;
    
        Staff__c st1=[Select Id,Active__c,Role__c,Username__c,Alias__c,CommunityNickName__c,Email__c,First_Name__c,Last_Name__c,Name,Profile__c,Phone_1__c,Fax__c,Department__c,User_Type__c from Staff__c where Username__c =: oldUsername WITH SECURITY_ENFORCED LIMIT 1];    
        
        try
        {
            if(Schema.sObjectType.Staff__c.fields.Role__c.isUpdateable()) {
                st1.Role__c = uRole1;}
            if(Schema.sObjectType.Staff__c.fields.Alias__c.isUpdateable()) {st1.Alias__c = alias;}
            if(Schema.sObjectType.Staff__c.fields.CommunityNickName__c.isUpdateable()) {st1.CommunityNickName__c = comm;}
            if(Schema.sObjectType.Staff__c.fields.Email__c.isUpdateable()) {st1.Email__c = email;}
            if(Schema.sObjectType.Staff__c.fields.Username__c.isUpdateable()) {st1.Username__c = username;}
            if(Schema.sObjectType.Staff__c.fields.First_Name__c.isUpdateable()) {st1.First_Name__c = fName;}
            if(Schema.sObjectType.Staff__c.fields.Last_Name__c.isUpdateable()) {st1.Last_Name__c = lName;}
            if(Schema.sObjectType.Staff__c.fields.Name.isUpdateable()) {st1.Name = staffName;}
            if(Schema.sObjectType.Staff__c.fields.Profile__c.isUpdateable()) {st1.Profile__c = proName;}
            if(Schema.sObjectType.Staff__c.fields.Phone_1__c.isUpdateable()) {st1.Phone_1__c = ph;}
            if(Schema.sObjectType.Staff__c.fields.Fax__c.isUpdateable()) {st1.Fax__c = fax;}
            if(Schema.sObjectType.Staff__c.fields.Department__c.isUpdateable()) {st1.Department__c = dept;}
            if(Schema.sObjectType.Staff__c.fields.User_Type__c.isUpdateable()) {st1.User_Type__c = userType;}
            if(Schema.sObjectType.Staff__c.fields.Active__c.isUpdateable()) {st1.Active__c=active;}
             if(Schema.sObjectType.Staff__c.isUpdateable()){
                 update st1;System.debug('@@Staff record is updated successfully '+st1);}
            else{
                System.debug('@@Staff has insufficiet access to update record ');
            }
        }
        catch(DMLException e)
        {
         // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e)));
        }
         
     }
    
    @AuraEnabled
    public static string Staff_To_User(String staffString)
    {
        Staff__c objJTR=(Staff__c)JSON.deserialize(staffString, Staff__c.class);
        System.debug('========Staff Object with objJTR============='+objJTR);
        List<User> lstUser=[Select Id,Name from User where Username=:objJTR.Username__c  limit 1];//WITH SECURITY_ENFORCED
        if(lstUser.size()==1)
        {
            String roleId, staffName,uName, alias,comm,email,fName,lName,profileId,ph,fax,dept,userType,title,companyName,emailEncodingKey,Language,Locale,timeZone;
            Boolean active;
            for(User usr:lstUser)
            {
                if(Schema.sObjectType.User.fields.IsActive.isUpdateable()) { usr.IsActive=True;}
                if(Schema.sObjectType.User.fields.User_Types__c.isUpdateable()) {  usr.User_Types__c='Licensed User';}
                if(Schema.sObjectType.User.isUpdateable()){update usr;}
                
                User u=[Select Id,IsActive, Name, UserRoleId,Alias,CommunityNickName,Username,Email,FirstName,LastName,ProfileId,Phone,Extension,Fax,Title,CompanyName,Department,User_Types__c,timezonesidkey,emailencodingkey,languagelocalekey,localesidkey from User where id=:usr.id ];//WITH SECURITY_ENFORCED
                
                staffName = u.Name;                      roleId=u.UserRoleId;
                uName=u.Username;
                alias=(u.FirstName).subString(0,3)+''+(u.LastName).subString(0,1);
                comm=u.CommunityNickName;                email=u.Email;
                fName=u.FirstName;               		 lName=u.Lastname;
                profileId=u.ProfileId;             		 ph=u.Phone;
                fax=u.Fax;                				 title=u.Title;
                companyName=u.CompanyName;               dept=u.Department;
                userType=u.User_Types__c;                emailEncodingKey=u.EmailEncodingKey;
                Language=u.LanguageLocaleKey;            Locale=u.Localesidkey;
                timeZone=u.timezonesidkey;               active=u.IsActive;
            }
            // updateStaff is a future method. It is called on to update Staff record when Usertype is converted to Licensed User from Unlicensed Staff
            //updateStaff(staffName,roleId,uName,alias,comm,email,fName,lName,profileId,ph,fax,dept,userType,emailEncodingKey,Language,Locale,timeZone,oldUsername,active);
        }
        else
        {
            
            Staff__c st=[Select Role__c,Profile__c from STaff__c where Id=:objJTR.Id WITH SECURITY_ENFORCED];
            String st1=objJTR.Role__c;
            String st2=objJTR.Profile__c;
            
            // Create a user record if User record does not exist for a Staff
            
            User usr=new User();
            if(Schema.sObjectType.User.fields.FirstName.isCreateable()) { usr.FirstName=objJTR.First_Name__c;}
            if(Schema.sObjectType.User.fields.LastName.isCreateable()) { usr.LastName=objJTR.Last_Name__c;}
            if(Schema.sObjectType.User.fields.Email.isCreateable()) { usr.Email=objJTR.Email__c;}
            if(Schema.sObjectType.User.fields.User_Types__c.isCreateable()) {usr.User_Types__c=objJTR.User_Type__c;}
            if(Schema.sObjectType.User.fields.Department.isCreateable()) {usr.Department=objJTR.Department__c;}
            if(Schema.sObjectType.User.fields.Username.isCreateable()) { usr.Username=objJTR.Username__c;}
            if(Schema.sObjectType.User.fields.emailencodingkey.isCreateable()) {usr.emailencodingkey=objJTR.Email_Encoding__c;}
            if(Schema.sObjectType.User.fields.languagelocalekey.isCreateable()) { usr.languagelocalekey=objJTR.Language__c;}
            if(Schema.sObjectType.User.fields.localesidkey.isCreateable()) { usr.localesidkey=objJTR.Locale__c;}
            if(Schema.sObjectType.User.fields.timezonesidkey.isCreateable()) { usr.timezonesidkey=objJTR.Time_Zone__c;}
            if(Schema.sObjectType.User.fields.Alias.isCreateable()) {usr.Alias=objJTR.Alias__c;}
            if(Schema.sObjectType.User.fields.CommunityNickName.isCreateable()) {usr.CommunityNickName=objJTR.CommunityNickName__c;}
            if(Schema.sObjectType.User.fields.EmailEncodingKey.isCreateable()) {
                if(objJTR.Email_Encoding__c==NULL){
                    usr.EmailEncodingKey='ISO-8859-1';
                }
                else{
                    usr.EmailEncodingKey=objJTR.Email_Encoding__c;
                }
            }
            if(Schema.sObjectType.User.fields.languagelocalekey.isCreateable()) {
                if(objJTR.Language__c==NULL){
                    usr.languagelocalekey='en_US';}
                
                else{
                    usr.languagelocalekey=objJTR.Language__c;
                }
            }
            if(Schema.sObjectType.User.fields.timezonesidkey.isCreateable()) { 
                if(objJTR.Time_Zone__c==NULL){    
                    usr.timezonesidkey='America/Panama';
                }
                else{
                    usr.timezonesidkey=objJTR.Time_Zone__c;
                }
            }
            if(Schema.sObjectType.User.fields.localesidkey.isCreateable()) {
                if(objJTR.Locale__c==NULL){
                    usr.localesidkey='en_US';
                }
                else{
                    usr.localesidkey=objJTR.Locale__c;
                }
            }
            
            Profile pro=[Select Id,Name from Profile where Name=:st2 ];//WITH SECURITY_ENFORCED
            UserRole uRole=[Select Id,Name from UserRole where Name=: st1 ];//WITH SECURITY_ENFORCED
             if(Schema.sObjectType.User.fields.ProfileId.isCreateable()) {
                 usr.ProfileId=pro.id;}
            if(Schema.sObjectType.User.fields.UserRoleId.isCreateable()) {
                usr.UserRoleId=uRole.id;}
            try
            {
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.EmailHeader.triggerUserEmail = true;
                usr.setOptions(dmo);
                 if(Schema.sObjectType.User.isCreateable()){
                     insert usr; } // Create User record
            }
            catch(Exception e)
            {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, string.valueOf(e)));
                return ''+string.valueOf(e);
            }
            User u=[Select Id,IsActive,Name,UserRoleId,Alias,CommunityNickName,Username,Email,FirstName,LastName,ProfileId,Phone,Extension,Fax,Title,CompanyName,Department,User_Types__c,timezonesidkey,emailencodingkey,languagelocalekey,localesidkey from User where id=:usr.id ];//WITH SECURITY_ENFORCED
            String staffName = u.Name;                   String roleId=u.UserRoleId;
            String uName=u.Username;
            //String alias=(u.FirstName).subString(0,4);
            String alias=(u.FirstName).subString(0,3)+''+(u.LastName).subString(0,1);
            String comm=u.CommunityNickName;             String email=u.Email;
            String fName=u.FirstName;                    String lName=u.Lastname;
            String profileId=u.ProfileId;                String ph=u.Phone;
            String fax=u.Fax;                            String title=u.Title;
            String companyName=u.CompanyName;            String dept=u.Department;
            String userType=u.User_Types__c;             String locale=u.localesidkey;
            String language=u.languagelocalekey;         String emailEncodingKey=u.emailencodingkey;
            String timeZone= u.timezonesidkey;           Boolean active = u.IsActive;
            
            // updateStaff is a future method and it is called on to update Staff record
            //updateStaff(staffName, roleId,uName,alias,comm,email,fName,lName,profileId,ph,fax,dept,userType,locale,language,emailEncodingKey,timeZone,oldUsername,active);
            
        }
        return 'OK';
    }
    
    
    
    /********************************************** Deactivate User ************************************************************/
    @AuraEnabled
    public static string deactivateUser(Id recordId)
    {
        String staffUsername;
        try
        {
            User userDeactivate=[Select Id,IsActive,Username,User_Types__c from User where id=: recordId  limit 1];//WITH SECURITY_ENFORCED
            if(userDeactivate.User_Types__c!='Licensed User')
            {
                staffUsername=userDeactivate.Username;
                if(Schema.sObjectType.User.fields.IsActive.isUpdateable()) { userDeactivate.IsActive=False;}
                if(Schema.sObjectType.User.fields.IsDeleted__c.isUpdateable()) { userDeactivate.IsDeleted__c=True;}
                if(Schema.sObjectType.User.isUpdateable()){
                    update userDeactivate;}
                deleteStaff(staffUserName);
            }
            else
            {
               // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ' please change the status to Unlicensed Staff.'));
                return 'ChangeUSerType';
            }
            
        }
        catch(Exception e)
        {
           // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error occurred while deactivating the User.'));
            return 'Error occurred while deactivating the User.';
        }
        return 'OK';
        
    }
    // End method deactivate User 
    
     @future
    public static void deleteStaff(String staffUsername)
    {
        try
        {
            Staff__c st=[Select Id from Staff__c where Username__c=: staffUsername WITH SECURITY_ENFORCED];
            if(Schema.sObjectType.Staff__c.fields.IsDeleted__c.isUpdateable()) { 
                st.IsDeleted__c=True;}
             if(Schema.sObjectType.Staff__c.isUpdateable()){
                 update st;
            System.debug('Corresponding staff is deleted');
             }else{
                  System.debug('Staff has insufficient access to update');
             }
        }
        catch(Exception e)
        {
           // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,String.valueOf(e)));
           // return ''+e.getMessage();
        }
        //return 'OK';
    }
    
    /******************************************* RESET Password *********************************************************/
  /*  @AuraEnabled
    public static string resetpassword(Id recordId)
    {
        try
        {
            User u=[Select Id,IsActive,Username,User_Types__c from User where id=: recordId limit 1];
            if(u.IsActive==True)
            {
                System.ResetPasswordResult result = System.resetPassword(u.Id,true);
            }
            else
            {
                return 'User is Inactive';
            }
        }
        catch(Exception e)
        {
           return ''+e.getMessage();
        }
  		return 'OK';
    }  */
    
    
    /**************************************************************** fetching Staff Records **********************************************************/
    
    @AuraEnabled
    public static list<Staff__c> getStaffs() {
        List <Staff__c> Staff = [select Name,Username__c,First_Name__c,Email__c,Role__c from Staff__c where User_Type__c =: 'Unlicensed Staff' and Active__c=: True and IsDeleted__c=:False WITH SECURITY_ENFORCED Order By First_Name__c];
        return Staff;
    }
    
    @AuraEnabled
    public Static Map<Id, String> getSURoles() 
    {
        Map <Id, String> RoleoptionMap = new Map < Id, String > ();        
      //  RoleoptionMap.put(null, '--None--'); //WITH SECURITY_ENFORCED 
        for (UserRole roles :[SELECT Id,Name FROM UserRole  ORDER BY Name ])  
        { 
            RoleoptionMap.put(roles.Id, roles.name);
        }
        return RoleoptionMap;  
    }  
    
    @AuraEnabled
    public Static Map<Id, String> getProfile() 
    {
        Map <Id, String> ProfileoptionMap = new Map < Id, String > ();        
      //  ProfileoptionMap.put(null, '--None--');//WITH SECURITY_ENFORCED  
        for (Profile users1 :[SELECT Id,Name,UserLicense.Name FROM Profile where UserLicense.Name =: 'Salesforce' OR UserLicense.Name =: 'Salesforce Platform'  ORDER BY Name])  
        { 
            ProfileoptionMap.put(users1.Id, users1.name);
        }
        return ProfileoptionMap;  
    }  
    
    @AuraEnabled
    public static String delStaff(String StaffId)
    {
        try
        {
            Staff__c st=[Select Id from Staff__c where Id=: StaffId WITH SECURITY_ENFORCED];
            if(Schema.sObjectType.Staff__c.fields.IsDeleted__c.isUpdateable()) {st.IsDeleted__c=True;}
            if(Schema.sObjectType.Staff__c.isUpdateable()){
                update st;
                System.debug('Corresponding staff is deleted');
                return 'OK';
                }
            else{
                return 'Staff has insufficient access to update';
            }
          
        }
        catch(Exception e)
        {return ''+e.getMessage();
        }
        
    }
    
    /*************************************************************** Approval Schedule Template Tasks and Roles *****************************************************************/  
    
     @AuraEnabled
    public static list<Approval_Schedule_Task__c> getAppSchduleTasks(String schId){
        List<Approval_Schedule_Task__c>  lstST=[Select Id,Name,Days__c,Roles__c ,Approval_Schedule_Template__c,Task_Order__c from Approval_Schedule_Task__c where Approval_Schedule_Template__c=:schId WITH SECURITY_ENFORCED Order By Task_Order__c,CreatedDate DESC];
        return lstST;
    }
    
    
      @AuraEnabled
    public static Decimal getApprovalTaskBelowOrder(String schId){
        decimal task_order_no;
        List<Approval_Schedule_Task__c> lstST=[Select Id,Name,Task_Order__c,Approval_Schedule_Template__c from Approval_Schedule_Task__c where Approval_Schedule_Template__c=:schId and Task_Order__c!=null WITH SECURITY_ENFORCED order by Task_Order__c DESC];
        
        if(!lstST.isEmpty())
        {
            task_order_no=lstST[0].Task_Order__c+1;
        }
        else
        {
            task_order_no=1;
        } 
        return task_order_no;
    }
    
    
     @AuraEnabled
    public static string UpdateApprovalScheuleTasks(list<Approval_Schedule_Task__c> editedScheduleList){
        try{
            if (Approval_Schedule_Task__c.sObjectType.getDescribe().isUpdateable()) {
                update editedScheduleList;
                return 'true';
            }
            else{
                return 'Error';
            }
        }
        Catch(System.DmlException e){return ''+e.getMessage();
        }
        
    }
    
    @AuraEnabled
    public static String UpdateReamingApprovalSTasks(String STaskId){
        List<Approval_Schedule_Task__c> lstST = new List<Approval_Schedule_Task__c>();
        Approval_Schedule_Task__c STins=[Select Id, Task_Order__c,Approval_Schedule_Template__c from Approval_Schedule_Task__c Where Id=:STaskId WITH SECURITY_ENFORCED];
        lstST=[Select id, Task_Order__c from Approval_Schedule_Task__c where Task_Order__c >=:STins.Task_Order__c and id !=:STaskId and Approval_Schedule_Template__c =:STins.Approval_Schedule_Template__c WITH SECURITY_ENFORCED Order BY Task_Order__c ASC];
        
        Double a=STins.Task_Order__c+1;
        List<Approval_Schedule_Task__c> updateTask=new List<Approval_Schedule_Task__c>();
        for(Approval_Schedule_Task__c st:lstST)
        {
            if(Schema.sObjectType.Approval_Schedule_Task__c.fields.Task_Order__c.isUpdateable()){
                st.Task_Order__c=a;
            }
            a++;
            updateTask.add(st);
        }
        try{
            if(Schema.sObjectType.Approval_Schedule_Task__c.isUpdateable()){
                update updateTask;
                return 'OK';
            }
            else{
                return 'Tasks have insufficient access to update';
            }
        }
        Catch(System.DmlException e){return ''+e.getMessage();
        }
      
    }
    
    
    @AuraEnabled
    public Static String DeleteApprovalScheduleTask(String STaskId){
        Approval_Schedule_Task__c objST = [Select Id,Task_Order__c, Approval_Schedule_Template__c from Approval_Schedule_Task__c where Id =:STaskId WITH SECURITY_ENFORCED limit 1];
        Id STId=objST.Approval_Schedule_Template__c;
        Double Task_Order_No=objST.Task_Order__c;
        
        try
        {
            if(Approval_Schedule_Task__c.sObjectType.getDescribe().isDeletable()){
                Database.delete(objST);  }
            else{
                return 'Approval Schedule Taks has insufficient access to delete';
            }
            List<Approval_Schedule_Task__c> updateTask=new List<Approval_Schedule_Task__c>();
            List<Approval_Schedule_Task__c> lstST=[Select id,Task_Order__c from Approval_Schedule_Task__c where Approval_Schedule_Template__c=: STId AND Task_Order__c >: Task_Order_No WITH SECURITY_ENFORCED Order BY Task_Order__c];
            System.debug('Below Task records after deletion : '+lstST);
            
            if(!lstST.isEmpty()){
                for(Integer i=0;i<lstST.size();i++){
                    if(i==0){
                           if(Schema.sObjectType.Approval_Schedule_Task__c.fields.Task_Order__c.isUpdateable()){
                               lstST[i].Task_Order__c = Task_Order_No;}
                    }
                    else{    
                           if(Schema.sObjectType.Approval_Schedule_Task__c.fields.Task_Order__c.isUpdateable()){
                               lstST[i].Task_Order__c= lstST[i-1].Task_Order__c + 1;}
                    }
                    updateTask.add(lstST[i]);
                }
                  if(Schema.sObjectType.Approval_Schedule_Task__c.isUpdateable()){
                      update updateTask;}
                else{
                    return 'Approval Schedule Task has insufficient access to update';
                }
            }
        }
        catch(System.DMLException e)
        {return ''+e.getMessage();
        }
        return 'OK';
    } 
    
    
    
    public class ApprovalRoleWrapper
    {
        @AuraEnabled 
        public UserRole URole{get;set;}
        @AuraEnabled 
        public Boolean checked{get;set;}
    }   
    
    @AuraEnabled
    public Static list<ApprovalRoleWrapper> getApprovalSTRolesWrapper(String STaskId){
        List<ApprovalRoleWrapper> roleWraps=new List<ApprovalRoleWrapper>();
        set<String> sctaro=new set<String>();
        for(Approval_Schedule_Task_Role__c str: [Select Id,Name,Approval_Schedule_Task__c from Approval_Schedule_Task_Role__c where Approval_Schedule_Task__c =: STaskId WITH SECURITY_ENFORCED])
        {
            sctaro.add(str.Name );
        }
        List<UserRole> uRole=[Select Name from UserRole  order by Name  LIMIT 10000];//WITH SECURITY_ENFORCED
        for(UserRole u: uRole)
        {
            ApprovalRoleWrapper rw=new ApprovalRoleWrapper();
            if(sctaro.contains(u.Name))
            {
                rw.URole=u;  rw.checked=True;
            }
            else
            {
                rw.URole=u;
                rw.checked=False;
            }
            roleWraps.add(rw);        
        }
        return roleWraps;
    }
    
    @AuraEnabled
    public Static String AddRolesToApprovalScheduleTask(String STaskId,String selectedRoles){
        List<ApprovalRoleWrapper> roleWraps=(List<ApprovalRoleWrapper>)Json.deserialize(selectedRoles, List<ApprovalRoleWrapper>.Class);
        List<Approval_Schedule_Task_Role__c> lstSTR = [Select id,Name,Approval_Schedule_Task__c from Approval_Schedule_Task_Role__c where Approval_Schedule_Task__c =: STaskId WITH SECURITY_ENFORCED];
        try{
            if(Schema.sObjectType.Approval_Schedule_Task_Role__c.isDeletable()){
                delete lstSTR;}
            else{
                return 'Task roles has insufficient access to delete';
            }
        }
        Catch(System.DmlException e){return ''+e.getMessage();
        }
        
        try
        {
            List<Approval_Schedule_Task_Role__c> lst=new List<Approval_Schedule_Task_Role__c>();
            for(ApprovalRoleWrapper rw:roleWraps){
                if(rw.checked==true){
                    Approval_Schedule_Task_Role__c stRole=new Approval_Schedule_Task_Role__c();
                     if(Schema.sObjectType.Approval_Schedule_Task_Role__c.fields.Name.isCreateable()){
                          stRole.Name=rw.URole.Name;}
                       if(Schema.sObjectType.Approval_Schedule_Task_Role__c.fields.Approval_Schedule_Task__c.isCreateable()){
                           stRole.Approval_Schedule_Task__c=STaskId;}
                    lst.add(stRole);
                }
            }
            if(Schema.sObjectType.Approval_Schedule_Task_Role__c.isCreateable()){
                insert lst;}
            else{
                    return 'Approval Schedule Task Role has insufficient access to insert';
                }
        }
        
        Catch(System.DmlException e){return ''+e.getMessage();
        }
        
        return 'OK';
    }
    
    
    
    
    /*************************************************************** Schedule Template Tasks and Roles *****************************************************************/  
    
    @AuraEnabled
    public static list<Schedule_Task__c> getSchduleTasks(String schId){
        List<Schedule_Task__c>  lstST=[Select Id,Name,Days__c,GL_Code__c,GL_Code__r.Name,GL_Code__r.Id,Locked__c,Report__c,Roles__c ,Hours__c ,Schedule_Template__c,Task_Order__c from Schedule_Task__c where Schedule_Template__c=:schId WITH SECURITY_ENFORCED Order By Task_Order__c,CreatedDate DESC];
        return lstST;
    }
    
    @AuraEnabled
    public static string UpdateScheuleTasks(list<Schedule_Task__c> editedScheduleList){
        try{
            if (Schedule_Task__c.sObjectType.getDescribe().isUpdateable()) {
                update editedScheduleList;
                return 'true';
            }
            else{
                return 'Error';
            }
        }
        Catch(System.DmlException e){return ''+e.getMessage();
        }
        
    }
    
    @AuraEnabled
    public static String UpdateReamingSTasks(String STaskId){
        List<Schedule_Task__c> lstST = new List<Schedule_Task__c>();
        Schedule_Task__c STins=[Select Id, Task_Order__c,Schedule_Template__c from Schedule_Task__c Where Id=:STaskId WITH SECURITY_ENFORCED];
        lstST=[Select id, Task_Order__c from Schedule_Task__c where Task_Order__c >=:STins.Task_Order__c and id !=:STaskId and Schedule_Template__c =:STins.Schedule_Template__c WITH SECURITY_ENFORCED Order BY Task_Order__c ASC];
        
        Double a=STins.Task_Order__c+1;
        List<Schedule_Task__c> updateTask=new List<Schedule_Task__c>();
        for(Schedule_Task__c st:lstST)
        {
            if(Schema.sObjectType.Schedule_Task__c.fields.Task_Order__c.isUpdateable()){
                st.Task_Order__c=a;}
            a++;
            updateTask.add(st);
        }
        try{
            if(Schema.sObjectType.Schedule_Task__c.isUpdateable()){
                update updateTask;
             return 'OK';}
            else{
                return 'Tasks have insufficient access to update';
            }
        }
        Catch(System.DmlException e){return ''+e.getMessage();
        }
      
    }
    
    
    @AuraEnabled
    public static Decimal getTaskBelowOrder(String schId){
        decimal task_order_no;
        List<Schedule_Task__c> lstST=[Select Id,Name,Task_Order__c,Schedule_Template__c from Schedule_Task__c where Schedule_Template__c=:schId and Task_Order__c!=null WITH SECURITY_ENFORCED order by Task_Order__c DESC];
        
        if(!lstST.isEmpty())
        {
            task_order_no=lstST[0].Task_Order__c+1;
        }
        else
        {
            task_order_no=1;
        } 
        return task_order_no;
    }
    
    @AuraEnabled
    public Static String DeleteScheduleTask(String STaskId){
        Schedule_Task__c objST = [Select Id,Task_Order__c, Schedule_Template__c from Schedule_Task__c where Id =:STaskId WITH SECURITY_ENFORCED limit 1];
        Id STId=objST.Schedule_Template__c;
        Double Task_Order_No=objST.Task_Order__c;
        
        try
        {
            if(Schedule_Task__c.sObjectType.getDescribe().isDeletable()){
                Database.delete(objST);  }
            else{
                return 'Taks has insufficient access to delete';
            }
            List<Schedule_Task__c> updateTask=new List<Schedule_Task__c>();
            List<Schedule_Task__c> lstST=[Select id,Task_Order__c from Schedule_Task__c where Schedule_Template__c=: STId AND Task_Order__c >: Task_Order_No WITH SECURITY_ENFORCED Order BY Task_Order__c];
            System.debug('Below Task records after deletion : '+lstST);
            
            if(!lstST.isEmpty()){
                for(Integer i=0;i<lstST.size();i++){
                    if(i==0){
                           if(Schema.sObjectType.Schedule_Task__c.fields.Task_Order__c.isUpdateable()){
                               lstST[i].Task_Order__c = Task_Order_No;}
                    }
                    else{    
                           if(Schema.sObjectType.Schedule_Task__c.fields.Task_Order__c.isUpdateable()){
                               lstST[i].Task_Order__c= lstST[i-1].Task_Order__c + 1;}
                    }
                    updateTask.add(lstST[i]);
                }
                  if(Schema.sObjectType.Schedule_Task__c.isUpdateable()){
                      update updateTask;}
                else{
                    return 'Task has insufficient access to update';
                }
            }
        }
        catch(System.DMLException e)
        {return ''+e.getMessage();
        }
        return 'OK';
    } 
    
    public class RoleWrapper
    {
        @AuraEnabled 
        public UserRole URole{get;set;}
        @AuraEnabled 
        public Boolean checked{get;set;}
    }   
    
    @AuraEnabled
    public Static list<RoleWrapper> getSTRolesWrapper(String STaskId){
        List<RoleWrapper> roleWraps=new List<RoleWrapper>();
        set<String> sctaro=new set<String>();
        for(ScheduleTaskRole__c str: [Select Id,Name,Schedule_Task__c from ScheduleTaskRole__c where Schedule_Task__c =: STaskId WITH SECURITY_ENFORCED])
        {
            sctaro.add(str.Name );
        }
        List<UserRole> uRole=[Select Name from UserRole  order by Name  LIMIT 10000];//WITH SECURITY_ENFORCED
        for(UserRole u: uRole)
        {
            RoleWrapper rw=new RoleWrapper();
            if(sctaro.contains(u.Name))
            {
                rw.URole=u;  rw.checked=True;
            }
            else
            {
                rw.URole=u;
                rw.checked=False;
            }
            roleWraps.add(rw);        
        }
        return roleWraps;
    }
    
    @AuraEnabled
    public Static String AddRolesToScheduleTask(String STaskId,String selectedRoles){
        List<RoleWrapper> roleWraps=(List<RoleWrapper>)Json.deserialize(selectedRoles, List<RoleWrapper>.Class);
        List<ScheduleTaskRole__c> lstSTR = [Select id,Name,Schedule_Task__c from ScheduleTaskRole__c where Schedule_Task__c =: STaskId WITH SECURITY_ENFORCED];
        try{
            if(Schema.sObjectType.ScheduleTaskRole__c.isDeletable()){
                delete lstSTR;}
            else{
                return 'Task roles has insufficient access to delete';
            }
        }
        Catch(System.DmlException e){return ''+e.getMessage();
        }
        
        try
        {
            List<ScheduleTaskRole__c> lst=new List<ScheduleTaskRole__c>();
            for(RoleWrapper rw:roleWraps){
                if(rw.checked==true){
                    ScheduleTaskRole__c stRole=new ScheduleTaskRole__c();
                     if(Schema.sObjectType.ScheduleTaskRole__c.fields.Name.isCreateable()){
                          stRole.Name=rw.URole.Name;}
                       if(Schema.sObjectType.ScheduleTaskRole__c.fields.Schedule_Task__c.isCreateable()){
                           stRole.Schedule_Task__c=STaskId;}
                    lst.add(stRole);
                }
            }
            if(Schema.sObjectType.ScheduleTaskRole__c.isCreateable()){
                insert lst;}
            else{
                    return 'ScheduleTaskRole has insufficient access to insert';
                }
        }
        
        Catch(System.DmlException e){return ''+e.getMessage();
        }
        
        return 'OK';
    }
    
    @AuraEnabled
    public static List<String> DuplicateCBTemp(String CBTempId) {
        List<String> resResult=new List<String>();
        string NewCBTempId;
        string isError='false';
        try
        {
            Specification_Template__c oldCBTemp=[select id,Name,Description__c from Specification_Template__c where id=:CBTempId WITH SECURITY_ENFORCED Limit 1];
            
            List<Spec_Item__c> oldCBSpecItem=[select id,Name,Description__c,Sort_Order__c,Specification_Template__c,Lock__c from Spec_Item__c where Specification_Template__c=:CBTempId WITH SECURITY_ENFORCED order by Sort_Order__c];
            
            Specification_Template__c newCBTemp = new Specification_Template__c();
            
            string CBTName = 'Dup : '+DateTime.Now()+' '+oldCBTemp.Name;
           /* if(CBTName.length() > 80)
            {
                CBTName = CBTName.substring(0,80);
            }*/
            
            if(Schema.sObjectType.Specification_Template__c.fields.Name.isCreateable()) {
                newCBTemp.Name=CBTName;  
            }
            if(Schema.sObjectType.Specification_Template__c.fields.Description__c.isCreateable()) {
                newCBTemp.Description__c=oldCBTemp.Description__c;  
            }
            
            if(Schema.sObjectType.Specification_Template__c.isCreateable()){
                insert newCBTemp ;
            }
            
            NewCBTempId=newCBTemp.Id;
            
            List<Spec_Item__c> insertSpecItems = new List<Spec_Item__c>();
            
            for(Spec_Item__c oldSpecItem : oldCBSpecItem)
            {
                Spec_Item__c newSpecItem = new Spec_Item__c();
                
                if(Schema.SObjectType.Spec_Item__c.Fields.Name.isCreateable()){
                    newSpecItem.Name = oldSpecItem.Name;
                }
                
                if(Schema.SObjectType.Spec_Item__c.Fields.Description__c.isCreateable()){
                    newSpecItem.Description__c = oldSpecItem.Description__c;
                }
                
                if(Schema.SObjectType.Spec_Item__c.Fields.Sort_Order__c.isCreateable()){
                    newSpecItem.Sort_Order__c = oldSpecItem.Sort_Order__c;
                }
                
                if(Schema.SObjectType.Spec_Item__c.Fields.Specification_Template__c.isCreateable()){
                    newSpecItem.Specification_Template__c = newCBTemp.Id;
                }
                
                if(Schema.SObjectType.Spec_Item__c.Fields.Lock__c.isCreateable()){
                    newSpecItem.Lock__c = oldSpecItem.Lock__c;
                }
                
                insertSpecItems.add(newSpecItem);
                
            }
            
            if(Schema.sObjectType.Spec_Item__c.isCreateable()){
                insert insertSpecItems;
            }
            
        }
        
         catch(Exception e)
         {
             isError = 'true';
             resResult.add(isError);
             resResult.add(NewCBTempId);
             resResult.add(''+e.getMessage());
             return resResult;
         }           
        
        
        resResult.add(isError);
        resResult.add(NewCBTempId);
        resResult.add('No Error');
        return resResult;

        
    }
    
    
   
    
}
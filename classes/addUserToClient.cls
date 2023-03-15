global class addUserToClient {  
    
  //  @future   
 /*   public static void ClientAdd(Set<Id> userIds) {
        List<User> user = [select Id, firstname, lastname, email,Profile.Name,IsActive,  Username from user where Id IN :userIds];
        List<Client_Contact__c> clientToInsert = new List<Client_Contact__c>();       
        List<Client_Contact__c> clientToUpdate = new List<Client_Contact__c>();       
        List<Client_Contact__c> checkifExists = new  List<Client_Contact__c>();
        for (User usr : User)
        {
            //check if the user is of SP client contact.   
            if(usr.Profile.Name == 'SP Client Contact' && usr.IsActive == true) 
            {
                //check if the client contact is present
                
                checkifExists  = [SELECT Id, Email__c,UserName__c FROM Client_Contact__c WHERE UserName__c =:usr.Username];
                if(checkifExists.size() > 0)
                {
                    Client_Contact__c clientcontact1 = checkifExists[0];
                    if(Schema.sObjectType.Client_Contact__c.Fields.UserName__c.isUpdateable()){
                        clientcontact1.UserName__c = usr.Username;
                    }
                    if(Schema.sObjectType.Client_Contact__c.Fields.First_Name__c.isUpdateable()){
                        clientcontact1.First_Name__c = usr.FirstName;
                    }
                    if(Schema.sObjectType.Client_Contact__c.Fields.Email__c.isUpdateable()){
                        clientcontact1.Email__c = usr.Email;
                    }
                    if(schema.SobjectType.Client_Contact__c.Fields.Last_Name__c.isUpdateable()){
                        clientcontact1.Last_Name__c = usr.LastName;
                    }
                    if(Schema.sObjectType.Client_Contact__c.Fields.Name.isUpdateable()){
                        clientcontact1.Name = usr.FirstName + ' ' + usr.LastName;
                    }
                    if(Schema.sObjectType.Client_Contact__c.Fields.Active__c.isUpdateable()){
                        clientcontact1.Active__c = usr.IsActive;
                    }
                    if(Schema.sObjectType.Client_Contact__c.Fields.Salesforce_User__c.isUpdateable()){
                        clientcontact1.Salesforce_User__c = true;   
                    }
                    
                    clientToUpdate.add(clientcontact1);
                }
                else
                {                
                    Client_Contact__c clientcontact = new Client_Contact__c (
                        UserName__c = usr.Username,
                        First_Name__c = usr.FirstName,
                        Email__c = usr.Email,
                        Last_Name__c = usr.LastName,
                        Name = usr.FirstName + ' ' + usr.LastName,
                        Active__c = usr.IsActive,
                        Salesforce_User__c = true
                    );                    
                    clientToInsert.add(clientcontact );                
                }                
            }        
        }
        insert clientToInsert ;
        if(Schema.sObjectType.Client_Contact__c.isUpdateable()){
            update clientToUpdate;            
        }
            
    }*/
}
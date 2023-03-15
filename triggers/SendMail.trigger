trigger SendMail on Development_Item__c (after insert, after update) {
    
    String addresses;
    String strHtmlBody;   
    String strPlatform;
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setUseSignature(false);
    
    if(Trigger.IsInsert){
        for(Development_Item__c objTemp:trigger.new){
        strPlatform = string.valueOf(objTemp.Platform__c);
            //if(strPlatform == 'Saleforce' || strPlatform == '' || strPlatform == Null){
                system.debug('new object added--->'+objTemp);
                User lstUserC = new User();
                User lstUserU = new User(); 
                lstUserC = database.query('select name from user where id=\''+String.escapeSingleQuotes(objTemp.CreatedByID)+'\'');//WITH SECURITY_ENFORCED          
                lstUserU = database.query('select name from user where id=\''+String.escapeSingleQuotes(objTemp.LastModifiedByID)+'\'');//WITH SECURITY_ENFORCED
                mail.setSubject('DevList Item - '+ objTemp.Development_Item_Number__c +'(' + objTemp.Name + ') Created.');            
                strHtmlBody = '<table><th colspan="2" style="text-align:center;height:50px;">New DevItem Details:</th><tr><td><b>Development Item Name:</b></td><td>'+objTemp.Name+'</td></tr><tr><td><b>Description:</b></td><td>'+objTemp.Description__c+'</td></tr><tr><td><b>Status:</b></td><td>'+objTemp.Status__c+'</td></tr><tr><td><b>Priority:</b></td> <td>'+objTemp.Priority__c+'</td></tr><tr><td><b>Category: </b></td><td>'+objTemp.Category__c+'</td></tr><tr><td><b>Comments: </b></td><td>'+objTemp.Comment__c+'</td></tr><tr><td><b>Actual Hrs</b></td><td>'+objTemp.Actual_Hrs__c+'</td></tr><tr><td><b>Estimated Hrs</b></td><td>'+objTemp.Estimated_Hrs__c+'</td></tr><tr><td><b>Actual Hours</b></td><td>'+objTemp.Actual_Hours_Old__c+'</td></tr><tr><td><b>Estimated Hours</b></td><td>'+objTemp.Estimated_Hours__c+'</td></tr><tr><td><b>Created By:</b></td><td>'+lstUserC.name+'</td></tr><tr><td><b>Last Modified By:</b></td><td>'+lstUserU.name+'</td></tr></table>';

            //}
        }
    }
    
    if(Trigger.IsUpdate){
        Development_Item__c objOld = new Development_Item__c();                
        Development_Item__c objNew = new Development_Item__c();   

        strHtmlBody = '<table><th colspan="3" style="text-align:center;height:50px;"><u>DevItem Details</u></th>';
        
        for(Development_Item__c objTemp:trigger.old){
            strPlatform = string.valueOf(objTemp.Platform__c);
            
            //if(strPlatform == 'Saleforce' || strPlatform == '' || strPlatform == Null){
                objOld = ObjTemp;
            //}
            /*User lstUserC = new User();
            User lstUserU = new User(); 
            lstUserC = database.query('select name from user where id=\''+objTemp.CreatedByID+'\'');          
            lstUserU = database.query('select name from user where id=\''+objTemp.LastModifiedByID+'\'');        
            system.debug('object old data--->'+objTemp);
            mail.setSubject('DevList Item - '+ objTemp.Development_Item_Number__c +'(' + objTemp.Name + ') Updated.');                        
            strHtmlBody = '<table><th colspan="2" style="text-align:center;height:50px;">DevItem Details Before changes:</th><tr><td><b>Development Item Name:</b></td><td>'+objTemp.Name+'</td></tr><tr><td><b>Description:</b></td><td>'+objTemp.Description__c+'</td></tr><tr><td><b>Status:</b></td><td>'+objTemp.Status__c+'</td></tr><tr><td><b>Priority:</b></td> <td>'+objTemp.Priority__c+'</td></tr><tr><td><b>Category: </b></td><td>'+objTemp.Category__c+'</td></tr><tr><td><b>Comments: </b></td><td>'+objTemp.Comment__c+'</td></tr><tr><td><b>Actual Hrs</b></td><td>'+objTemp.Actual_Hrs__c+'</td></tr><tr><td><b>Estimated Hrs</b></td><td>'+objTemp.Estimated_Hrs__c+'</td></tr><tr><td><b>Actual Hours</b></td><td>'+objTemp.Actual_Hours_Old__c+'</td></tr><tr><td><b>Estimated Hours</b></td><td>'+objTemp.Estimated_Hours__c+'</td></tr><tr><td><b>Created By:</b></td><td>'+lstUserC.name+'</td></tr><tr><td><b>Last Modified By:</b></td><td>'+lstUserU.name+'</td></tr></table>';            
            */
        }
            //strHtmlBody = strHtmlBody + '<br /><br />'; 
        for(Development_Item__c objTemp:trigger.new){
            //if(strPlatform == 'Saleforce' || strPlatform == '' || strPlatform == Null){
                objNew = objTemp;
                User lstUserC = new User();
                User lstUserU = new User(); 
                lstUserC = database.query('select name from user where id=\''+String.escapeSingleQuotes(objTemp.CreatedByID)+'\' ');    //WITH SECURITY_ENFORCED      
                lstUserU = database.query('select name from user where id=\''+String.escapeSingleQuotes(objTemp.LastModifiedByID)+'\' ');     //WITH SECURITY_ENFORCED   
                system.debug('object new data--->'+objTemp);        
                mail.setSubject('DevList Item - '+ objTemp.Development_Item_Number__c +'(' + objTemp.Name + ') Updated');
                strHtmlBody = strHtmlBody + '<tr><td><b>Created By:</b></td><td>'+lstUserC.name+'</td></tr><tr><td><b>Last Modified By:</b></td><td>'+lstUserU.name+'</td></tr>';            
            //}            
        }
        
    if(strPlatform == 'Saleforce' || strPlatform == '' || strPlatform == Null){ 
        addresses = 'subhranshu@dhruvsoft.com,';  
    }
    else{
        addresses = 'subhranshu@dhruvsoft.com,';
    }
    
    addresses = addresses.left(addresses.length()-1);
    String[] toAddresses = addresses.split(',', 0);
    system.debug('&&&&&&&&&&&&&&&'+toAddresses);
    mail.setToAddresses(toAddresses);
    
        //if(strPlatform == 'Saleforce' || strPlatform == '' || strPlatform == Null){
            strHtmlBody = strHtmlBody + '<tr></tr><tr></tr><tr><td></td><td><b>New Values</b></td><td><b>Previous Values</b></td></tr>';
            
            if(objOld.Description__c != objNew.Description__c){
                strHtmlBody = strHtmlBody + '<tr><td><b>Description:</b></td><td>'+objNew.Description__c+'</td><td bgcolor="#CCFFFF">'+objOld.Description__c+'</td></tr>';
            }
            else{
                strHtmlBody = strHtmlBody + '<tr><td><b>Description:</b></td><td>'+objNew.Description__c+'</td></tr>';            
            }
            if(objOld.Status__c != objNew.Status__c){
                strHtmlBody = strHtmlBody + '<tr><td><b>Status:</b></td><td>'+objNew.Status__c+'</td><td bgcolor="#CCFFFF">'+objOld.Status__c+'</td></tr>';
            }
            else{
                strHtmlBody = strHtmlBody + '<tr><td><b>Status:</b></td><td>'+objNew.Status__c+'</td></tr>';
            }
            if(objOld.Priority__c != objNew.Priority__c){
                strHtmlBody = strHtmlBody + '<tr><td><b>Priority:</b></td><td>'+objNew.Priority__c+'</td><td bgcolor="#CCFFFF">'+objOld.Priority__c+'</td></tr>';
            }
            else{
                strHtmlBody = strHtmlBody + '<tr><td><b>Priority:</b></td><td>'+objNew.Priority__c+'</td></tr>';
            }
            if(objOld.Category__c != objNew.Category__c){
                strHtmlBody = strHtmlBody + '<tr><td><b>Category: </b></td><td>'+objNew.Category__c+'</td><td bgcolor="#CCFFFF">'+objOld.Category__c+'</td></tr>';
            }
            else{
                strHtmlBody = strHtmlBody + '<tr><td><b>Category: </b></td><td>'+objNew.Category__c+'</td></tr>';
            }
            if(objOld.Actual_Hours_Old__c != objNew.Actual_Hours_Old__c){
                strHtmlBody = strHtmlBody + '<tr><td><b>Actual Hours: </b></td><td>'+objNew.Actual_Hours_Old__c+'</td><td bgcolor="#CCFFFF">'+objOld.Actual_Hours_Old__c+'</td></tr>';
            }
            else{
                strHtmlBody = strHtmlBody + '<tr><td><b>Actual Hours: </b></td><td>'+objNew.Actual_Hours_Old__c+'</td></tr>';
            }
            if(objOld.Estimated_Hours__c != objNew.Estimated_Hours__c){
                strHtmlBody = strHtmlBody + '<tr><td><b>Estimated Hours: </b></td><td>'+objNew.Estimated_Hours__c+'</td><td bgcolor="#CCFFFF">'+objOld.Estimated_Hours__c+'</td></tr>';
            }
            else{
                strHtmlBody = strHtmlBody + '<tr><td><b>Estimated Hours: </b></td><td>'+objNew.Estimated_Hours__c+'</td></tr>';
            }
            if(objOld.Actual_Hrs__c != objNew.Actual_Hrs__c){
                strHtmlBody = strHtmlBody + '<tr><td><b>Actual Hrs: </b></td><td>'+objNew.Actual_Hrs__c+'</td><td bgcolor="#CCFFFF">'+objOld.Actual_Hrs__c+'</td></tr>';
            }                                                
            else{
                strHtmlBody = strHtmlBody + '<tr><td><b>Actual Hrs: </b></td><td>'+objNew.Actual_Hrs__c+'</td></tr>';
            }
            if(objOld.Estimated_Hrs__c != objNew.Estimated_Hrs__c){
                strHtmlBody = strHtmlBody + '<tr><td><b>Estimated Hrs: </b></td><td>'+objNew.Estimated_Hrs__c+'</td><td bgcolor="#CCFFFF">'+objOld.Estimated_Hrs__c+'</td></tr>';
            }
            else{
                strHtmlBody = strHtmlBody + '<tr><td><b>Estimated Hrs: </b></td><td>'+objNew.Estimated_Hrs__c+'</td></tr>';            
            }
            if(objOld.Comment__c != objNew.Comment__c){
                strHtmlBody = strHtmlBody + '<tr><td><b>Comments: </b></td><td>'+objNew.Comment__c+'</td><td bgcolor="#CCFFFF">'+objOld.Comment__c+'</td></tr>';
            }           
            else{
                strHtmlBody = strHtmlBody + '<tr><td><b>Comments: </b></td><td>'+objNew.Comment__c+'</td></tr>';
            }
            strHtmlBody = strHtmlBody + '</table>';
        //}
            
    }   
    system.debug('email body--->'+strHtmlBody);
    
    //if(strPlatform == 'Saleforce' || strPlatform == '' || strPlatform == Null){    
        mail.setHtmlBody(strHtmlBody);    
        try
        {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
        }
        catch(Exception e)
        {            
            system.debug('Error:'+e);
        }    
    //}   
}